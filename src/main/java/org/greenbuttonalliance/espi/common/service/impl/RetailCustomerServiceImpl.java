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

import org.greenbuttonalliance.espi.common.domain.*;
import org.greenbuttonalliance.espi.common.repositories.RetailCustomerRepository;
import org.greenbuttonalliance.espi.common.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.security.core.userdetails.UserDetails;
    import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.InputStream;
import java.util.List;
import java.util.UUID;

@Service
public class RetailCustomerServiceImpl implements RetailCustomerService {

    @Autowired
    private RetailCustomerRepository retailCustomerRepository;

    @Autowired
    private ResourceService resourceService;

    @Autowired
    private ImportService importService;

    @Autowired
    private AuthorizationService authorizationService;

    @Autowired
    private SubscriptionService subscriptionService;

    @Autowired
    private UsagePointService usagePointService;

    @Override
    public List<RetailCustomer> findAll() {
        System.out.println("list user");
        return retailCustomerRepository.findAll();
    }

    @Override
    public void persist(RetailCustomer customer) {
        System.out.println("persist user");
        if (customer.getUUID() == null) {
            customer.setUUID(UUID.randomUUID());
        }
        retailCustomerRepository.persist(customer);
    }

    @Override
    public RetailCustomer findById(Long id) {
        System.out.println("found by id");
        return retailCustomerRepository.findById(id);
    }

    @Override
    public RetailCustomer findById(String retailCustomerId) {
        System.out.println("found by id");
        return retailCustomerRepository.findById(retailCustomerId);
    }

    @Override
    public RetailCustomer findByHashedId(Long retailCustomerId) {
        System.out.println("found hashedID");
        return findById(retailCustomerId);
    }

    @Override
    public UserDetails loadUserByUsername(String username)
            throws UsernameNotFoundException {
        try {
            System.out.println("found user");
            return retailCustomerRepository.findByUsername(username);

        } catch (EmptyResultDataAccessException x) {
            System.out.println("didnt found user");
            throw new UsernameNotFoundException("Unable to find user");
        }
    }

    @Override
    public void add(RetailCustomer retailCustomer) {
        // TODO Auto-generated method stub

    }

    @Override
    public void delete(RetailCustomer retailCustomer) {
        retailCustomerRepository.deleteById(retailCustomer.getId());

    }

    @Override
    public RetailCustomer importResource(InputStream stream) {
        RetailCustomer retailCustomer = null;
        try {
            importService.importData(stream, null);
            // TODO - Make RetailCustomer inherit from IdentifiedObject and add
            // RetailCustomer to the entrytype structure

            // EntryType entry = importService.getEntries().get(0);
            // RetailCustomer retailCustomer =
            // entry.getContent().getRetailCustomer();
            // persist(retailCustomer);
        } catch (Exception e) {
            System.out.printf(
                    "**** RetailCustomerService:importResource Failed %s\n",
                    e.toString());
        }
        return retailCustomer;
    }

    /**
     * Associates a UsagePoint identified by {@code uuid} with the given
     * {@code retailCustomerId}.  This implementation saves and updates the
     * UsagePoint, Authorization and Subscription using their own services so
     * each persist/merge runs in its own transaction.  Without this, JPA can
     * throw “No EntityManager with actual transaction available” when
     * {@code resourceService.persist} is invoked outside a transaction.
     */
    @Transactional
    @Override
    public Subscription associateByUUID(Long retailCustomerId, UUID uuid) {
        Subscription subscription = null;
        try {
            // Look up the retail customer
            RetailCustomer retailCustomer =
                    resourceService.findById(retailCustomerId, RetailCustomer.class);

            // Try to find an existing UsagePoint with this UUID
            UsagePoint usagePoint;
            try {
                usagePoint = resourceService.findByUUID(uuid, UsagePoint.class);
            } catch (Exception e) {
                // None exists – create a temporary UsagePoint and persist it via UsagePointService
                usagePoint = new UsagePoint();
                usagePoint.setUUID(uuid);
                usagePoint.setDescription("A Temporary UsagePoint Description");
                usagePoint.setServiceCategory(new ServiceCategory(ServiceCategory.ELECTRICITY_SERVICE));
                usagePointService.persist(usagePoint);  // start its own transaction and flush
            }

            // Associate the usage point with the customer and persist/merge
            usagePoint.setRetailCustomer(retailCustomer);
            usagePointService.persist(usagePoint);  // update via its own transaction

            // Find all authorizations for this customer and link the usage point
            List<Authorization> auths =
                    authorizationService.findAllByRetailCustomerId(retailCustomer.getId());
            for (Authorization authorization : auths) {
                // Determine the subscription for this authorization
                subscription = subscriptionService.findByAuthorizationId(authorization.getId());

                // Ensure resourceURI is set if missing
                if (authorization.getResourceURI() == null && subscription != null) {
                    String base = authorization.getApplicationInformation().getDataCustodianResourceEndpoint();
                    authorization.setResourceURI(base + "/Batch/Subscription/" + subscription.getId());
                }
                // Save the authorization and subscription via their own services
                authorizationService.merge(authorization);

                if (subscription != null) {
                    subscription.getUsagePoints().add(usagePoint);
                    subscriptionService.merge(subscription);
                }
            }

        } catch (Exception e) {
            // Log a meaningful error instead of printing null references
            System.out.printf("****Error Associating UsagePoint: %s%n", e.toString());
            return null;
        }

        return subscription;
    }

    public void setRetailCustomerRepository(
            RetailCustomerRepository retailCustomerRepository) {
        this.retailCustomerRepository = retailCustomerRepository;
    }

    public RetailCustomerRepository getRetailCustomerRepository() {
        return this.retailCustomerRepository;
    }

    public void setResourceService(ResourceService resourceService) {
        this.resourceService = resourceService;
    }

    public ResourceService getResourceService() {
        return this.resourceService;
    }

    public void setImportService(ImportService importService) {
        this.importService = importService;
    }

    public ImportService getImportService() {
        return this.importService;
    }

    public void setAuthorizationService(
            AuthorizationService authorizationService) {
        this.authorizationService = authorizationService;
    }

    public AuthorizationService getAuthorizationService() {
        return this.authorizationService;
    }

    public void setSubscriptionService(SubscriptionService subscriptionService) {
        this.subscriptionService = subscriptionService;
    }

    public SubscriptionService getSubscriptionService() {
        return this.subscriptionService;
    }

    public void setUsagePointService(UsagePointService usagePointService) {
        this.usagePointService = usagePointService;
    }

    public UsagePointService getUsagePointService() {
        return this.usagePointService;
    }
}
