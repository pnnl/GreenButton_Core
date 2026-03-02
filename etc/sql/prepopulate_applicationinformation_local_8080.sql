/*
 * Legacy-style prepopulation of application_information and related tables
 * for a local environment where BOTH DataCustodian and ThirdParty run on
 * http://localhost:8080.
 */

SET sql_mode = 'PIPES_AS_CONCAT';
SET @dcbaseurl = 'http://localhost:8080';
SET @tpbaseurl = 'http://localhost:9090';

USE datacustodian;

/* application_information records (Data Custodian Admin, Third Party, Upload) */
INSERT INTO `application_information` (
  `id`, `kind`, `description`, `published`, `self_link_href`, `self_link_rel`, `up_link_href`, `up_link_rel`,
  `updated`, `uuid`, `authorizationServerAuthorizationEndpoint`, `authorizationServerRegistrationEndpoint`,
  `authorizationServerTokenEndpoint`, `authorizationServerUri`, `clientId`, `clientIdIssuedAt`, `clientName`,
  `clientSecret`, `clientSecretExpiresAt`, `clientUri`, `contacts`, `dataCustodianApplicationStatus`,
  `dataCustodianBulkRequestURI`, `dataCustodianDefaultBatchResource`, `dataCustodianDefaultSubscriptionResource`,
  `dataCustodianId`, `dataCustodianResourceEndpoint`, `dataCustodianThirdPartySelectionScreenURI`, `logoUri`,
  `policyUri`, `redirectUri`, `registrationAccessToken`, `registrationClientUri`, `responseTypes`, `softwareId`,
  `softwareVersion`, `thirdPartyApplicationDescription`, `thirdPartyApplicationName`, `thirdPartyApplicationStatus`,
  `thirdPartyApplicationType`, `thirdPartyApplicationUse`, `thirdPartyDataCustodianSelectionScreenURI`,
  `thirdPartyLoginScreenURI`, `thirdPartyNotifyUri`, `thirdPartyPhone`, `thirdPartyScopeSelectionScreenURI`,
  `thirdPartyUserPortalScreenURI`, `tokenEndpointAuthMethod`, `tosUri`, `dataCustodianScopeSelectionScreenURI`
) VALUES
  (1, 'DATA_CUSTODIAN_ADMIN', 'Green Button Alliance OpenESPI Data Custodian Admin Application',
   '2014-01-02 05:00:00', '/espi/1_1/resource/DataCustodian/ApplicationInformation/1', 'self',
   '/espi/1_1/resource/DataCustodian/ApplicationInformation', 'up', '2014-01-02 05:00:00',
   '185C9C3F-5B4A-44A9-8959-3AE79E60A9F5', @dcbaseurl || '/DataCustodian/oauth/authorize',
   @dcbaseurl || '/DataCustodian/espi/1_1/register', @dcbaseurl || '/DataCustodian/oauth/token',
   @dcbaseurl || '/DataCustodian/', 'data_custodian', 1403190000, 'Green Button DataCustodian Admin', 'secret', 0,
   @dcbaseurl || '/DataCustodian','john.teeter@energyos.org,martin.burns@nist.gov,donald.coffin@reminetworks.com', '1',
   @dcbaseurl || '/DataCustodian/espi/1_1/resource/Batch/Bulk', @dcbaseurl || '/DataCustodian/espi/1_1/resource/Batch',
   @dcbaseurl || '/DataCustodian/espi/1_1/resource/Batch/Subscription', 'data_custodian',
   @dcbaseurl || '/DataCustodian/espi/1_1/resource',
   @dcbaseurl || '/DataCustodian/RetailCustomer/{retailCustomerId}/ThirdPartyList', NULL, NULL, NULL, NULL,
   @dcbaseurl || '/DataCustodian/espi/1_1/resource/ApplicationInformation/1', 0, 'EnergyOS OpenESPI', '1.2',
   'EnergyOS OpenESPI Example DataCustodian Admin', 'Data Custodian Admin (localhost)', '1', '1', '1', NULL, NULL,
   NULL, NULL, NULL, NULL, 'client_secret_basic', NULL,
   @dcbaseurl || '/DataCustodian/RetailCustomer/ScopeSelection/'),

  (2, 'THIRD_PARTY', 'Green Button Alliance OpenESPI Third Party Application',
   '2014-01-02 05:00:00', '/espi/1_1/resource/DataCustodian/ApplicationInformation/2', 'self',
   '/espi/1_1/resource/DataCustodian/ApplicationInformation', 'up', '2014-01-02 05:00:00',
   'AF6E8B03-0299-467E-972A-A883ECDCC575', @dcbaseurl || '/DataCustodian/oauth/authorize',
   @dcbaseurl || '/DataCustodian/espi/1_1/register', @dcbaseurl || '/DataCustodian/oauth/token',
   @dcbaseurl || '/DataCustodian/', 'third_party', 1403190000, 'Green Button Third Party', 'secret', 0,
   @tpbaseurl || '/ThirdParty','john.teeter@energyos.org,martin.burns@nist.gov,donald.coffin@reminetworks.com', '1',
   @dcbaseurl || '/DataCustodian/espi/1_1/resource/Batch/Bulk', @dcbaseurl || '/DataCustodian/espi/1_1/resource/Batch',
   @dcbaseurl || '/DataCustodian/espi/1_1/resource/Batch/Subscription', 'data_custodian',
   @dcbaseurl || '/DataCustodian/espi/1_1/resource', @dcbaseurl || '/DataCustodian/RetailCustomer/1/ThirdPartyList',
   @tpbaseurl || '/ThirdParty/resources/ico/favicon.png', NULL,
   @tpbaseurl || '/ThirdParty/espi/1_1/OAuthCallBack', 'd89bb056-0f02-4d47-9fd2-ec6a19ba8d0c',
   @dcbaseurl || '/DataCustodian/espi/1_1/resource/ApplicationInformation/2', 0, 'EnergyOS OpenESPI Example Third Party',
   '1.2', 'EnergyOS OpenESPI Example Third Party', 'Third Party (localhost)', '1', '1', '1',
   @tpbaseurl || '/ThirdParty/RetailCustomer/{retailCustomerId}/DataCustodianList',
   @tpbaseurl || '/ThirdParty/login', @tpbaseurl || '/ThirdParty/espi/1_1/Notification', NULL,
   @tpbaseurl || '/ThirdParty/RetailCustomer/ScopeSelection', @tpbaseurl || '/ThirdParty', 'client_secret_basic', NULL,
   @dcbaseurl || '/DataCustodian/RetailCustomer/ScopeSelectionList?ThirdPartyID=third_party'),

  (3, 'UPLOAD_ADMIN', 'Green Button Alliance OpenESPI MDM Upload Application',
   '2014-01-02 05:00:00', '/espi/1_1/resource/DataCustodian/ApplicationInformation/3', 'self',
   '/espi/1_1/resource/DataCustodian/ApplicationInformation', 'up', '2014-01-02 05:00:00',
   '185C9C3F-5B4A-44A9-8959-3AE79E60A9F7', @dcbaseurl || '/DataCustodian/oauth/authorize',
   @dcbaseurl || '/DataCustodian/espi/1_1/register', @dcbaseurl || '/DataCustodian/oauth/token',
   @dcbaseurl || '/DataCustodian/', 'upload', 1403190000, 'Green Button DMD Upload Service', 'secret', 0, NULL,
   'john.teeter@energyos.org,martin.burns@nist.gov,donald.coffin@reminetworks.com', '1',
   @dcbaseurl || '/DataCustodian/espi/1_1/resource/Batch/Bulk', @dcbaseurl || '/DataCustodian/espi/1_1/resource/Batch',
   @dcbaseurl || '/DataCustodian/espi/1_1/resource/Batch/Subscription', 'data_custodian',
   @dcbaseurl || '/DataCustodian/espi/1_1/resource', @dcbaseurl || '/DataCustodian/RetailCustomer/1/ThirdPartyList',
   NULL, NULL, NULL, NULL, @dcbaseurl || '/DataCustodian/espi/1_1/resource/ApplicationInformation/3', 0,
   'EnergyOS OpenESPI DMD Upload Service', '1.2', 'EnergyOS OpenESPI DMD Upload Service', 'MDM Upload (localhost)',
   NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'client_secret_basic', NULL, NULL);

/* application_information_scopes (feature bundle examples + privacy levels) */
INSERT INTO application_information_scopes (application_information_id, scope) VALUES
  (1, 'FB=1_3_4_5_13_14_19_32_33_34_35_36_37_38_41_44_45');
INSERT INTO application_information_scopes (application_information_id, scope) VALUES
  (2, 'FB=1_3_4_5_13_14_39;IntervalDuration=3600;BlockDuration=monthly;HistoryLength=13');
INSERT INTO application_information_scopes (application_information_id, scope) VALUES
  (2, 'FB=1_3_4_5_13_14_15_39;IntervalDuration=900;BlockDuration=monthly;HistoryLength=13');
INSERT INTO application_information_scopes (application_information_id, scope) VALUES
  (2, 'FB=1_3_4_5_13_14_39;IntervalDuration=3600;BlockDuration=monthly;HistoryLength=13');
INSERT INTO application_information_scopes (application_information_id, scope) VALUES
  (2, 'FB=1_3_4_5_6_7_8_9_10_11_29_12_13_14_15_16_17_18_19_27_28_32_33_34_35_37_38_39_40_41_44;IntervalDuration=3600;BlockDuration=monthly;HistoryLength=13');

/* Align with privacy levels used in testing */
INSERT INTO application_information_scopes (application_information_id, scope)
  SELECT id, 'privacy:full' FROM application_information;
INSERT INTO application_information_scopes (application_information_id, scope)
  SELECT id, 'privacy:medium' FROM application_information;
INSERT INTO application_information_scopes (application_information_id, scope)
  SELECT id, 'privacy:low' FROM application_information;
INSERT INTO application_information_scopes (application_information_id, scope)
  SELECT id, 'privacy:high' FROM application_information;

/* application_information_grant_types */
INSERT INTO application_information_grant_types (application_information_id, grantTypes) VALUES (1, 'CLIENT_CREDENTIALS');
INSERT INTO application_information_grant_types (application_information_id, grantTypes) VALUES (2, 'AUTHORIZATION_CODE');
INSERT INTO application_information_grant_types (application_information_id, grantTypes) VALUES (2, 'REFRESH_TOKEN');
INSERT INTO application_information_grant_types (application_information_id, grantTypes) VALUES (2, 'CLIENT_CREDENTIALS');
INSERT INTO application_information_grant_types (application_information_id, grantTypes) VALUES (3, 'CLIENT_CREDENTIALS');

/* Note: We intentionally do NOT pre-create authorizations/subscriptions here
 * to keep the environment clean for tests; they will be created by the flow.
 */
