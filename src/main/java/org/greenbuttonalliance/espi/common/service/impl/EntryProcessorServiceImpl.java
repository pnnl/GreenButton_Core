/*
 *
 *    Copyright (c) 2018-2021 Green Button Alliance, Inc.
 *
 *    Portions (c) 2013-2018 EnergyOS.org
 *
 *     Licensed under the Apache License, Version 2.0 (the "License");
 *     you may not use this file except in compliance with the License.
 *     You may obtain a copy of the License at
 *
 *         http://www.apache.org/licenses/LICENSE-2.0
 *
 *     Unless required by applicable law or agreed to in writing, software
 *     distributed under the License is distributed on an "AS IS" BASIS,
 *     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *     See the License for the specific language governing permissions and
 *     limitations under the License.
 *
 */

package org.greenbuttonalliance.espi.common.service.impl;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.greenbuttonalliance.espi.common.domain.*;
import org.greenbuttonalliance.espi.common.models.atom.EntryType;
import org.greenbuttonalliance.espi.common.models.atom.LinkType;
import org.greenbuttonalliance.espi.common.service.EntryProcessorService;
import org.greenbuttonalliance.espi.common.service.ResourceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Transactional(rollbackFor = { javax.xml.bind.JAXBException.class }, noRollbackFor = {
		javax.persistence.NoResultException.class,
		org.springframework.dao.EmptyResultDataAccessException.class })
@Service
public class EntryProcessorServiceImpl implements EntryProcessorService {

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private ResourceService resourceService;

	public EntryType process(EntryType entry) {
		logger.debug("EntryProcessorServiceImpl.process called for entry: " + entry.getId());
		convert(entry);
		for (IdentifiedObject resource : entry.getContent().getResources()) {
			IdentifiedObject managedResource;
			try {

				IdentifiedObject existingResource = resourceService.findByUUID(
						resource.getUUID(), resource.getClass());
				
				// Merge the new into the old and throw the new away
				existingResource.merge(resource);
				managedResource = resourceService.merge(existingResource);

			} catch (EmptyResultDataAccessException | javax.persistence.NoResultException x) {
				// Check if the resource is a UsagePoint and ensure no duplicate UUIDs
				if (resource instanceof UsagePoint) {
					UsagePoint usagePoint = (UsagePoint) resource;
					// findByUUID will throw if not present; treat null result as non-existent
					try {
						UsagePoint existing = resourceService.findByUUID(usagePoint.getUUID(), UsagePoint.class);
						if (existing != null) {
							System.out.println("[DEBUG] Duplicate UsagePoint detected: " + usagePoint.getUUID());
							continue; // Skip processing this duplicate UsagePoint
						}
					} catch (Exception ignore) {
						// Not found, proceed to merge as new
					}
				}

				// For new entities, clear collections to avoid cascade issues during initial merge
				if (resource instanceof UsagePoint) {
					UsagePoint up = (UsagePoint) resource;
					up.getMeterReadings().clear();
					up.getElectricPowerUsageSummaries().clear();
					up.getUsageSummaries().clear();
					up.getElectricPowerQualitySummaries().clear();
				}
				if (resource instanceof MeterReading) {
					MeterReading mr = (MeterReading) resource;
					mr.getIntervalBlocks().clear();
				}
				// Clear any collections that might have cascade issues
				if (resource instanceof UsagePoint) {
					UsagePoint up = (UsagePoint) resource;
					up.getMeterReadings().clear();
					up.getElectricPowerUsageSummaries().clear();
					up.getUsageSummaries().clear();
					up.getElectricPowerQualitySummaries().clear();
				}
				if (resource instanceof MeterReading) {
					MeterReading mr = (MeterReading) resource;
					mr.getIntervalBlocks().clear();
				}
				
				managedResource = resourceService.merge(resource);
			}

			// Link the managed resource
			link(managedResource);

			// Update the entry content with the managed resource
			if (managedResource instanceof UsagePoint) {
				entry.getContent().setUsagePoint((UsagePoint) managedResource);
			} else if (managedResource instanceof MeterReading) {
				entry.getContent().setMeterReading((MeterReading) managedResource);
			} else if (managedResource instanceof IntervalBlock) {
				// Handle IntervalBlock relationships
				List<IntervalBlock> intervalBlocks = entry.getContent().getIntervalBlocks();
				List<IntervalBlock> newList = new ArrayList<>();
				for (IntervalBlock block : intervalBlocks) {
					if (block.getUUID().equals(managedResource.getUUID())) {
						managedResource.merge(block);
						newList.add((IntervalBlock) managedResource);
					} else {
						newList.add(block);
					}
				}
				entry.getContent().setIntervalBlocks(newList);
			} else if (managedResource instanceof ReadingType) {
				entry.getContent().setReadingType((ReadingType) managedResource);
			} else if (managedResource instanceof TimeConfiguration) {
				entry.getContent().setLocalTimeParameters((TimeConfiguration) managedResource);
			} else if (managedResource instanceof ElectricPowerUsageSummary) {
				entry.getContent().setElectricPowerUsageSummary((ElectricPowerUsageSummary) managedResource);
			} else if (managedResource instanceof ElectricPowerQualitySummary) {
				entry.getContent().setElectricPowerQualitySummary((ElectricPowerQualitySummary) managedResource);
			} else if (managedResource instanceof ApplicationInformation) {
				entry.getContent().setApplicationInformation((ApplicationInformation) managedResource);
			}
		}

		return entry;
	}

	// the private functions that do the work
	//
	private void link(IdentifiedObject resource) {
	// Always operate on a managed instance to avoid detached entity issues
	linkUp(resource);
	linkUpMember(resource);
	linkRelatedCollection(resource);
	}

	// Copy the entry attributes into the resource attributes
	//
	public void convert(EntryType entry) {
		// support for entries that contain multiple resources has been added here
		// the result of entry.getContent().getResources()) can return a mixed back of resources, only one of which
		// will have appropriate UUID and self references - the rest will need UUIDs and self references created
		// NOTE: that this means, in effect, that if the resources types MUST have the same up reference (because there
		// is only one available in the <entry> structure itself
		Integer resourceCount = 0;
		for (IdentifiedObject resource : entry.getContent().getResources()) {
			resourceCount++;
			if (resourceCount > 1) {
				// make a new UUID and stash it in the entry
				entry.setId(UUID.randomUUID().toString());
			} 
			resource.setMRID(entry.getId());
	
			for (LinkType link : entry.getLinks()) {
				if (link.getRel().equals(LinkType.SELF)) {
					LinkType newLink = link;
					if (resourceCount >1) {
						// it doesn't mater what this is, except that it must be
						// unique - the UUID works just fine
						newLink = new LinkType();
						newLink.setHref(entry.getId());
						newLink.setRel(LinkType.SELF);
					}
					resource.setSelfLink(newLink);
				}
				if (link.getRel().equals(LinkType.UP))
					resource.setUpLink(link);
				if (link.getRel().equals(LinkType.RELATED))
					resource.getRelatedLinks().add(link);
			}
			resource.setDescription(entry.getTitle());
			resource.setPublished(entry.getPublished().getValue()
					.toGregorianCalendar());
			resource.setUpdated(entry.getUpdated().getValue()
					.toGregorianCalendar());
		}

	}

	// Establish the rel="up" links into the parent collections
	//
	private void linkUp(IdentifiedObject resource) {
	// Ensure the resource itself is managed before linking to parents
	if (resource.getUpLink() != null) {
			List<IdentifiedObject> parents = resourceService
		    .findByAllParentsHref(resource.getUpLink().getHref(),
			    resource);
			for (IdentifiedObject parent : parents) {
				// add the parent to the transaction
				resourceService.merge(parent);
				// add the resource to the parent collection
		resource.setUpResource(parent);
			}
		}
	}

	// Establish the rel="related" links to the associated resources
	//
	private void linkUpMember(IdentifiedObject resource) {
	// Ensure the resource itself is managed before updating parents
	if (resource.getSelfLink() != null) {
			List<IdentifiedObject> parents = resourceService
		    .findByAllParentsHref(resource.getSelfLink().getHref(),
			    resource);
			for (IdentifiedObject parent : parents) {
				// put the existing resource in the transaction
				resourceService.merge(parent);

				// Based on the kind of resource, do the appropriate fixup
		if (resource instanceof TimeConfiguration) {
					UsagePoint usagePoint = (UsagePoint) parent;

					if (usagePoint.getLocalTimeParameters() == null) {

			usagePoint
				.setLocalTimeParameters((TimeConfiguration) resource);

					}
				}

		if (resource instanceof ReadingType) {

					MeterReading meterReading = (MeterReading) parent;
					if (meterReading.getReadingType() == null) {
			meterReading.setReadingType((ReadingType) resource);
					}
				}
			}
		}
	}

	private void linkRelatedCollection(IdentifiedObject resource) {
	// Ensure we operate on a managed instance of the resource itself
	logger.debug("linkRelatedCollection called for resource: " + resource.getMRID());
	List<IdentifiedObject> relatedResources = resourceService
		.findAllRelated(resource);

	logger.debug("linkRelatedCollection: " + resource.getClass().getSimpleName() + 
	                   " UUID=" + resource.getMRID() + " has " + relatedResources.size() + " related resources");

		for (IdentifiedObject relatedResource : relatedResources) {
			// Put the relatedResource in the Transaction
	    IdentifiedObject managedRelated = resourceService.merge(relatedResource);
	    
	    logger.debug("Processing related: " + managedRelated.getClass().getSimpleName() +
	                       " UUID=" + managedRelated.getMRID());

	    if (resource instanceof UsagePoint) {
		if (managedRelated instanceof TimeConfiguration) {
		    ((UsagePoint) resource)
			    .setLocalTimeParameters((TimeConfiguration) managedRelated);
				}

		if (managedRelated instanceof MeterReading) {
		    MeterReading meterReading = (MeterReading) managedRelated;
		    UsagePoint usagePoint = (UsagePoint) resource;
		    logger.debug("Setting MeterReading->UsagePoint relationship: MR=" +
		                       meterReading.getMRID() + " -> UP=" + usagePoint.getMRID());
		    // Set bidirectional relationship
		    meterReading.setUsagePoint(usagePoint);
		    usagePoint.addMeterReading(meterReading);
				}

		if (managedRelated instanceof ElectricPowerUsageSummary) {
		    ((UsagePoint) resource)
			    .addElectricPowerUsageSummary((ElectricPowerUsageSummary) managedRelated);
				}

		if (managedRelated instanceof ElectricPowerQualitySummary) {
		    ((UsagePoint) resource)
			    .addElectricPowerQualitySummary((ElectricPowerQualitySummary) managedRelated);
				}
			}
	    if (resource instanceof MeterReading) {

		if (managedRelated instanceof ReadingType) {
		    ((MeterReading) resource)
			    .setReadingType((ReadingType) managedRelated);
				}

		if (managedRelated instanceof IntervalBlock) {
		    IntervalBlock intervalBlock = (IntervalBlock) managedRelated;
		    MeterReading meterReading = (MeterReading) resource;
		    logger.debug("Setting IntervalBlock->MeterReading relationship: IB=" +
		                       intervalBlock.getMRID() + " -> MR=" + meterReading.getMRID());
		    // Set bidirectional relationship
		    intervalBlock.setMeterReading(meterReading);
		    meterReading.addIntervalBlock(intervalBlock);
				}
			}

		}

	}

	public void setResourceService(ResourceService resourceService) {
		this.resourceService = resourceService;
	}

	public ResourceService getResourceService(ResourceService resourceService) {
		return resourceService;
	}
}
