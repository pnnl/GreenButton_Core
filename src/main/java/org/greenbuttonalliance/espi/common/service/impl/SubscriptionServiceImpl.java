package org.greenbuttonalliance.espi.common.service.impl;

import org.greenbuttonalliance.espi.common.domain.RetailCustomer;
import org.greenbuttonalliance.espi.common.domain.Subscription;
import org.greenbuttonalliance.espi.common.domain.UsagePoint;
import org.greenbuttonalliance.espi.common.models.atom.EntryType;
import org.greenbuttonalliance.espi.common.repositories.SubscriptionRepository;
import org.greenbuttonalliance.espi.common.repositories.UsagePointRepository;
import org.greenbuttonalliance.espi.common.service.ApplicationInformationService;
import org.greenbuttonalliance.espi.common.service.ImportService;
import org.greenbuttonalliance.espi.common.service.ResourceService;
import org.greenbuttonalliance.espi.common.service.RetailCustomerService;
import org.greenbuttonalliance.espi.common.service.SubscriptionService;
import org.greenbuttonalliance.espi.common.utils.EntryTypeIterator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.oauth2.provider.OAuth2Authentication;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.PersistenceContext;
import javax.xml.bind.JAXBException;
import java.util.ArrayList;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Set;
import java.util.UUID;

@Service
public class SubscriptionServiceImpl implements SubscriptionService {

    @PersistenceContext
    private EntityManager em;

    @Autowired
    private SubscriptionRepository subscriptionRepository;

    @Autowired
    private UsagePointRepository usagePointRepository;

    @Autowired
    private ApplicationInformationService applicationInformationService;

    @Autowired
    private ResourceService resourceService;

    @Autowired
    private ImportService importService;

    @Autowired
    private RetailCustomerService retailCustomerService;

    @Override
    @Transactional(
        propagation = Propagation.REQUIRES_NEW,
        rollbackFor = JAXBException.class,
        noRollbackFor = {
            NoResultException.class,
            org.springframework.dao.EmptyResultDataAccessException.class
        }
    )
    public Subscription createSubscription(OAuth2Authentication authentication) {
        Subscription subscription = new Subscription();
        subscription.setUUID(UUID.randomUUID());

        Set<String> role = AuthorityUtils.authorityListToSet(authentication.getAuthorities());
        if (role.contains("ROLE_USER")) {
            subscription.setApplicationInformation(
                applicationInformationService.findByClientId(
                    authentication.getOAuth2Request().getClientId()
                )
            );
            subscription.setRetailCustomer((RetailCustomer) authentication.getPrincipal());
            subscription.setUsagePoints(new ArrayList<>());
            List<Long> upIds = resourceService.findAllIdsByXPath(
                subscription.getRetailCustomer().getId(),
                UsagePoint.class
            );
            for (Long id : upIds) {
                UsagePoint up = resourceService.findById(id, UsagePoint.class);
                subscription.getUsagePoints().add(up);
            }
        } else {
            String ci = authentication.getOAuth2Request().getClientId();
            if (ci.startsWith("REGISTRATION_")) {
                ci = ci.substring("REGISTRATION_".length());
            }
            if (ci.contains("_admin")) {
                ci = ci.substring(0, ci.indexOf("_admin"));
            }
            subscription.setApplicationInformation(
                applicationInformationService.findByClientId(ci)
            );
            subscription.setRetailCustomer(retailCustomerService.findById(0L));
        }

        subscription.setLastUpdate(new GregorianCalendar());
        subscriptionRepository.persist(subscription);
        em.flush();  // force INSERT now
        return subscription;
    }

    @Override
    public Subscription findByHashedId(String hashedId) {
        return subscriptionRepository.findByHashedId(hashedId);
    }

    @Override
    public EntryTypeIterator findEntriesByHashedId(String hashedId) {
        Subscription subscription = subscriptionRepository.findByHashedId(hashedId);
        List<Long> ids = new ArrayList<>();
        ids.add(subscription.getId());
        return new EntryTypeIterator(resourceService, ids, Subscription.class);
    }

    @Override
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void merge(Subscription subscription) {
        subscriptionRepository.merge(subscription);
        em.flush();  // force UPDATE now
    }

    @Override
    public Subscription findById(Long subscriptionId) {
        return subscriptionRepository.findById(subscriptionId);
    }

    @Override
    public List<Long> findUsagePointIds(Long subscriptionId) {
        Subscription s = findById(subscriptionId);
        List<Long> result = new ArrayList<>();
        for (UsagePoint up : s.getUsagePoints()) {
            result.add(up.getId());
        }
        return result;
    }

    @Override
    public Subscription findByAuthorizationId(Long id) {
        return subscriptionRepository.findByAuthorizationId(id);
    }

    @Override
    @Transactional(
        propagation = Propagation.REQUIRES_NEW,
        rollbackFor = JAXBException.class,
        noRollbackFor = {
            NoResultException.class,
            org.springframework.dao.EmptyResultDataAccessException.class
        }
    )
    public Subscription addUsagePoint(Subscription subscription, UsagePoint usagePoint) {
        subscription.getUsagePoints().add(usagePoint);
        em.flush();  // force UPDATE now
        return subscription;
    }

    @Override
    public Long findRetailCustomerId(Long subscriptionId, Long usagePointId) {
        Subscription s = resourceService.findById(subscriptionId, Subscription.class);
        Long result = s.getRetailCustomer().getId();
        if (result.equals(0L)) {
            result = resourceService.findById(usagePointId, UsagePoint.class)
                                     .getRetailCustomer().getId();
        }
        return result;
    }

    @Override
    public void setRepository(SubscriptionRepository subscriptionRepository) {
        this.subscriptionRepository = subscriptionRepository;
    }

    @Override
    public EntryType findEntryType(Long retailCustomerId, Long subscriptionId) {
        try {
            List<Long> ids = new ArrayList<>();
            ids.add(subscriptionId);
            return new EntryTypeIterator(resourceService, ids, Subscription.class)
                    .nextEntry(Subscription.class);
        } catch (Exception e) {
            return null;
        }
    }

    @Override
    public EntryTypeIterator findEntryTypeIterator(Long retailCustomerId) {
        try {
            List<Long> ids = findUsagePointIds(retailCustomerId);
            EntryTypeIterator it = new EntryTypeIterator(resourceService, ids, Subscription.class);
            it.setSubscriptionId(retailCustomerId);
            return it;
        } catch (Exception e) {
            return null;
        }
    }
}
