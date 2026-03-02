package org.greenbuttonalliance.espi.common.service.impl;

import org.greenbuttonalliance.espi.common.domain.Authorization;
import org.greenbuttonalliance.espi.common.domain.Subscription;
import org.greenbuttonalliance.espi.common.domain.UsagePoint;
import org.greenbuttonalliance.espi.common.models.atom.EntryType;
import org.greenbuttonalliance.espi.common.repositories.AuthorizationRepository;
import org.greenbuttonalliance.espi.common.repositories.UsagePointRepository;
import org.greenbuttonalliance.espi.common.service.AuthorizationService;
import org.greenbuttonalliance.espi.common.service.ImportService;
import org.greenbuttonalliance.espi.common.service.ResourceService;
import org.greenbuttonalliance.espi.common.utils.EntryTypeIterator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
@Transactional  // default transaction settings for read‑only methods etc.
public class AuthorizationServiceImpl implements AuthorizationService {

    @PersistenceContext
    private EntityManager em;

    @Autowired
    private AuthorizationRepository authorizationRepository;

    @Autowired
    private UsagePointRepository usagePointRepository;

    @Autowired
    private ResourceService resourceService;

    @Autowired
    private ImportService importService;

    // Setter for testing
    public void setAuthorizationRepository(AuthorizationRepository authorizationRepository) {
        this.authorizationRepository = authorizationRepository;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Authorization> findAllByRetailCustomerId(Long retailCustomerId) {
        return authorizationRepository.findAllByRetailCustomerId(retailCustomerId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Long> findAllIdsByApplicationInformationId(Long applicationInformationId) {
        return authorizationRepository.findAllIdsByApplicationInformationId(applicationInformationId);
    }

    @Override
    @Transactional(readOnly = true)
    public Authorization findByUUID(UUID uuid) {
        return authorizationRepository.findByUUID(uuid);
    }

    // ←— NEW: run in its own TX and force a flush
    @Override
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public Authorization createAuthorization(Subscription subscription, String accessToken) {
        Authorization authorization = new Authorization();
        authorization.setUUID(UUID.randomUUID());
        authorizationRepository.persist(authorization);
        em.flush();    // ← forces the INSERT now, so any DB constraint error is thrown here
        return authorization;
    }

    @Override
    @Transactional(readOnly = true)
    public Authorization findByState(String state) {
        return authorizationRepository.findByState(state);
    }

    @Override
    @Transactional(readOnly = true)
    public Authorization findByScope(String scope, Long retailCustomerId) {
        return authorizationRepository.findByScope(scope, retailCustomerId);
    }

    // stubbed: not implemented yet
    @Override
    public List<Authorization> findAll() {
        throw new UnsupportedOperationException("findAll() not supported");
    }

    // stubbed: not implemented yet
    @Override
    public String feedFor(List<Authorization> authorizations) {
        throw new UnsupportedOperationException("feedFor() not supported");
    }

    @Override
    @Transactional(readOnly = true)
    public String entryFor(Authorization authorization) {
        throw new UnsupportedOperationException("entryFor() not supported");
    }

    @Override
    @Transactional(readOnly = true)
    public Authorization findByURI(String uri) {
        UsagePoint usagePoint = usagePointRepository.findByURI(uri);
        return usagePoint.getSubscription().getAuthorization();
    }

    // ←— RE‑ADD persist(…) so you implement the interface
    @Override
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void persist(Authorization authorization) {
        authorizationRepository.persist(authorization);
        em.flush();    // ← force DB validation immediately
    }

    // ←— MAKE merge(…) its own TX and flush
    @Override
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void merge(Authorization authorization) {
        authorizationRepository.merge(authorization);
        em.flush();    // ← force the UPDATE now
    }

    @Override
    @Transactional(readOnly = true)
    public Authorization findById(Long authorizationId) {
        return authorizationRepository.findById(authorizationId);
    }

    @Override
    @Transactional(readOnly = true)
    public EntryType findEntryType(Long retailCustomerId, Long authorizationId) {
        try {
            List<Long> ids = new ArrayList<>();
            ids.add(authorizationId);
            return new EntryTypeIterator(resourceService, ids, Authorization.class)
                    .nextEntry(Authorization.class);
        } catch (Exception e) {
            return null;
        }
    }

    @Override
    @Transactional(readOnly = true)
    public EntryTypeIterator findEntryTypeIterator(Long retailCustomerId) {
        try {
            List<Long> ids = authorizationRepository.findAllIds(retailCustomerId);
            return new EntryTypeIterator(resourceService, ids, Authorization.class);
        } catch (Exception e) {
            return null;
        }
    }

    @Override
    @Transactional(readOnly = true)
    public EntryType findRoot(Long authorizationId) {
        try {
            List<Long> ids = new ArrayList<>();
            ids.add(authorizationId);
            return new EntryTypeIterator(resourceService, ids, Authorization.class).next();
        } catch (Exception e) {
            return null;
        }
    }

    @Override
    @Transactional(readOnly = true)
    public EntryTypeIterator findEntryTypeIterator() {
        try {
            List<Long> ids = authorizationRepository.findAllIds();
            return new EntryTypeIterator(resourceService, ids, Authorization.class);
        } catch (Exception e) {
            return null;
        }
    }

    @Override
    public void add(Authorization authorization) {
        throw new UnsupportedOperationException("add() not supported");
    }

    @Override
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void delete(Authorization authorization) {
        authorizationRepository.deleteById(authorization.getId());
        em.flush();
    }

    @Override
    public Authorization importResource(InputStream stream) {
        try {
            importService.importData(stream, null);
            return importService.getEntries().get(0).getContent().getAuthorization();
        } catch (Exception e) {
            return null;
        }
    }

    @Override
    @Transactional(readOnly = true)
    public Authorization findById(Long retailCustomerId, long authorizationId) {
        return authorizationRepository.findById(authorizationId);
    }

    @Override
    @Transactional(readOnly = true)
    public Authorization findByAccessToken(String accessToken) {
        return authorizationRepository.findByAccessToken(accessToken);
    }

    @Override
    @Transactional(readOnly = true)
    public Authorization findByRefreshToken(String refreshToken) {
        return authorizationRepository.findByRefreshToken(refreshToken);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Long> findAllIdsByBulkId(String thirdParty, Long bulkId) {
        return authorizationRepository.findAllIdsByBulkId(thirdParty, bulkId);
    }
}
