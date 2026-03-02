-- MySQL dump 10.13  Distrib 8.0.42, for Linux (x86_64)
--
-- Host: localhost    Database: datacustodian
-- ------------------------------------------------------
-- Server version	8.0.42-0ubuntu0.24.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `datacustodian`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `datacustodian` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `datacustodian`;

--
-- Table structure for table `BatchList`
--

DROP TABLE IF EXISTS `BatchList`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `BatchList` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BatchList`
--

LOCK TABLES `BatchList` WRITE;
/*!40000 ALTER TABLE `BatchList` DISABLE KEYS */;
/*!40000 ALTER TABLE `BatchList` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `application_information`
--

DROP TABLE IF EXISTS `application_information`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `application_information` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `kind` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `published` datetime DEFAULT NULL,
  `self_link_href` varchar(255) DEFAULT NULL,
  `self_link_rel` varchar(255) DEFAULT NULL,
  `up_link_href` varchar(255) DEFAULT NULL,
  `up_link_rel` varchar(255) DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  `uuid` varchar(255) NOT NULL,
  `authorizationServerAuthorizationEndpoint` varchar(255) DEFAULT NULL,
  `authorizationServerRegistrationEndpoint` varchar(255) DEFAULT NULL,
  `authorizationServerTokenEndpoint` varchar(255) DEFAULT NULL,
  `authorizationServerUri` varchar(255) DEFAULT NULL,
  `clientId` varchar(64) NOT NULL,
  `clientIdIssuedAt` bigint DEFAULT NULL,
  `clientName` varchar(255) DEFAULT NULL,
  `clientSecret` varchar(255) DEFAULT NULL,
  `clientSecretExpiresAt` bigint DEFAULT NULL,
  `clientUri` varchar(255) DEFAULT NULL,
  `contacts` tinyblob,
  `dataCustodianApplicationStatus` varchar(255) DEFAULT NULL,
  `dataCustodianBulkRequestURI` varchar(255) DEFAULT NULL,
  `dataCustodianDefaultBatchResource` varchar(255) DEFAULT NULL,
  `dataCustodianDefaultSubscriptionResource` varchar(255) DEFAULT NULL,
  `dataCustodianId` varchar(64) DEFAULT NULL,
  `dataCustodianResourceEndpoint` varchar(255) DEFAULT NULL,
  `dataCustodianThirdPartySelectionScreenURI` varchar(255) DEFAULT NULL,
  `logoUri` varchar(255) DEFAULT NULL,
  `policyUri` varchar(255) DEFAULT NULL,
  `redirectUri` varchar(255) DEFAULT NULL,
  `registrationAccessToken` varchar(255) DEFAULT NULL,
  `registrationClientUri` varchar(255) DEFAULT NULL,
  `responseTypes` int DEFAULT NULL,
  `softwareId` varchar(255) DEFAULT NULL,
  `softwareVersion` varchar(255) DEFAULT NULL,
  `thirdPartyApplicationDescription` varchar(255) DEFAULT NULL,
  `thirdPartyApplicationName` varchar(64) NOT NULL,
  `thirdPartyApplicationStatus` varchar(255) DEFAULT NULL,
  `thirdPartyApplicationType` varchar(255) DEFAULT NULL,
  `thirdPartyApplicationUse` varchar(255) DEFAULT NULL,
  `thirdPartyDataCustodianSelectionScreenURI` varchar(255) DEFAULT NULL,
  `thirdPartyLoginScreenURI` varchar(255) DEFAULT NULL,
  `thirdPartyNotifyUri` varchar(255) DEFAULT NULL,
  `thirdPartyPhone` varchar(255) DEFAULT NULL,
  `thirdPartyScopeSelectionScreenURI` varchar(255) DEFAULT NULL,
  `thirdPartyUserPortalScreenURI` varchar(255) DEFAULT NULL,
  `tokenEndpointAuthMethod` varchar(255) DEFAULT NULL,
  `tosUri` varchar(255) DEFAULT NULL,
  `dataCustodianScopeSelectionScreenURI` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `clientId_UNIQUE` (`clientId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `application_information`
--

LOCK TABLES `application_information` WRITE;
/*!40000 ALTER TABLE `application_information` DISABLE KEYS */;
INSERT INTO `application_information` VALUES (1,'DATA_CUSTODIAN_ADMIN','Green Button Alliance OpenESPI Data Custodian Admin Application','2014-01-02 05:00:00','/espi/1_1/resource/DataCustodian/ApplicationInformation/1','self','/espi/1_1/resource/DataCustodian/ApplicationInformation','up','2014-01-02 05:00:00','185C9C3F-5B4A-44A9-8959-3AE79E60A9F5','http://localhost:8080/DataCustodian/oauth/authorize','http://localhost:8080/DataCustodian/espi/1_1/register','http://localhost:8080/DataCustodian/oauth/token','http://localhost:8080/DataCustodian/','data_custodian',1403190000,'Green Button DataCustodian Admin','secret',0,'http://localhost:8080/DataCustodian',_binary 'john.teeter@energyos.org,martin.burns@nist.gov,donald.coffin@reminetworks.com','1','http://localhost:8080/DataCustodian/espi/1_1/resource/Batch/Bulk','http://localhost:8080/DataCustodian/espi/1_1/resource/Batch','http://localhost:8080/DataCustodian/espi/1_1/resource/Batch/Subscription','data_custodian','http://localhost:8080/DataCustodian/espi/1_1/resource','http://localhost:8080/DataCustodian/RetailCustomer/{retailCustomerId}/ThirdPartyList',NULL,NULL,NULL,NULL,'http://localhost:8080/DataCustodian/espi/1_1/resource/ApplicationInformation/1',0,'EnergyOS OpenESPI','1.2','EnergyOS OpenESPI Example DataCustodian Admin','Data Custodian Admin (localhost)','1','1','1',NULL,NULL,NULL,NULL,NULL,NULL,'client_secret_basic',NULL,'http://localhost:8080/DataCustodian/RetailCustomer/ScopeSelection/'),(2,'THIRD_PARTY','Green Button Alliance OpenESPI Third Party Application','2014-01-02 05:00:00','/espi/1_1/resource/DataCustodian/ApplicationInformation/2','self','/espi/1_1/resource/DataCustodian/ApplicationInformation','up','2014-01-02 05:00:00','AF6E8B03-0299-467E-972A-A883ECDCC575','http://localhost:8080/DataCustodian/oauth/authorize','http://localhost:8080/DataCustodian/espi/1_1/register','http://localhost:8080/DataCustodian/oauth/token','http://localhost:8080/DataCustodian/','third_party',1403190000,'Green Button Third Party','secret',0,'http://localhost:9090/ThirdParty',_binary 'john.teeter@energyos.org,martin.burns@nist.gov,donald.coffin@reminetworks.com','1','http://localhost:8080/DataCustodian/espi/1_1/resource/Batch/Bulk','http://localhost:8080/DataCustodian/espi/1_1/resource/Batch','http://localhost:8080/DataCustodian/espi/1_1/resource/Batch/Subscription','data_custodian','http://localhost:8080/DataCustodian/espi/1_1/resource','http://localhost:8080/DataCustodian/RetailCustomer/1/ThirdPartyList','http://localhost:9090/ThirdParty/resources/ico/favicon.png',NULL,'http://localhost:9090/ThirdParty/espi/1_1/OAuthCallBack','d89bb056-0f02-4d47-9fd2-ec6a19ba8d0c','http://localhost:8080/DataCustodian/espi/1_1/resource/ApplicationInformation/2',0,'EnergyOS OpenESPI Example Third Party','1.2','EnergyOS OpenESPI Example Third Party','Third Party (localhost)','1','1','1','http://localhost:9090/ThirdParty/RetailCustomer/{retailCustomerId}/DataCustodianList','http://localhost:9090/ThirdParty/login','http://localhost:9090/ThirdParty/espi/1_1/Notification',NULL,'http://localhost:9090/ThirdParty/RetailCustomer/ScopeSelection','http://localhost:9090/ThirdParty','client_secret_basic',NULL,'http://localhost:8080/DataCustodian/RetailCustomer/ScopeSelectionList?ThirdPartyID=third_party'),(3,'UPLOAD_ADMIN','Green Button Alliance OpenESPI MDM Upload Application','2014-01-02 05:00:00','/espi/1_1/resource/DataCustodian/ApplicationInformation/3','self','/espi/1_1/resource/DataCustodian/ApplicationInformation','up','2014-01-02 05:00:00','185C9C3F-5B4A-44A9-8959-3AE79E60A9F7','http://localhost:8080/DataCustodian/oauth/authorize','http://localhost:8080/DataCustodian/espi/1_1/register','http://localhost:8080/DataCustodian/oauth/token','http://localhost:8080/DataCustodian/','upload',1403190000,'Green Button DMD Upload Service','secret',0,NULL,_binary 'john.teeter@energyos.org,martin.burns@nist.gov,donald.coffin@reminetworks.com','1','http://localhost:8080/DataCustodian/espi/1_1/resource/Batch/Bulk','http://localhost:8080/DataCustodian/espi/1_1/resource/Batch','http://localhost:8080/DataCustodian/espi/1_1/resource/Batch/Subscription','data_custodian','http://localhost:8080/DataCustodian/espi/1_1/resource','http://localhost:8080/DataCustodian/RetailCustomer/1/ThirdPartyList',NULL,NULL,NULL,NULL,'http://localhost:8080/DataCustodian/espi/1_1/resource/ApplicationInformation/3',0,'EnergyOS OpenESPI DMD Upload Service','1.2','EnergyOS OpenESPI DMD Upload Service','MDM Upload (localhost)',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'client_secret_basic',NULL,NULL);
/*!40000 ALTER TABLE `application_information` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `application_information_grant_types`
--

DROP TABLE IF EXISTS `application_information_grant_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `application_information_grant_types` (
  `application_information_id` bigint NOT NULL,
  `grantTypes` varchar(255) DEFAULT NULL,
  KEY `FK_61a6f8b0091946139543874e559` (`application_information_id`),
  CONSTRAINT `FK_61a6f8b0091946139543874e559` FOREIGN KEY (`application_information_id`) REFERENCES `application_information` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `application_information_grant_types`
--

LOCK TABLES `application_information_grant_types` WRITE;
/*!40000 ALTER TABLE `application_information_grant_types` DISABLE KEYS */;
INSERT INTO `application_information_grant_types` VALUES (1,'CLIENT_CREDENTIALS'),(2,'AUTHORIZATION_CODE'),(2,'REFRESH_TOKEN'),(2,'CLIENT_CREDENTIALS'),(3,'CLIENT_CREDENTIALS');
/*!40000 ALTER TABLE `application_information_grant_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `application_information_scopes`
--

DROP TABLE IF EXISTS `application_information_scopes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `application_information_scopes` (
  `application_information_id` bigint NOT NULL,
  `scope` varchar(255) DEFAULT NULL,
  KEY `FK_61a6f8b0091946139543874d559` (`application_information_id`),
  CONSTRAINT `FK_61a6f8b0091946139543874d559` FOREIGN KEY (`application_information_id`) REFERENCES `application_information` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `application_information_scopes`
--

LOCK TABLES `application_information_scopes` WRITE;
/*!40000 ALTER TABLE `application_information_scopes` DISABLE KEYS */;
INSERT INTO `application_information_scopes` VALUES (1,'FB=1_3_4_5_13_14_19_32_33_34_35_36_37_38_41_44_45'),(2,'FB=1_3_4_5_13_14_39;IntervalDuration=3600;BlockDuration=monthly;HistoryLength=13'),(2,'FB=1_3_4_5_13_14_15_39;IntervalDuration=900;BlockDuration=monthly;HistoryLength=13'),(2,'FB=1_3_4_5_13_14_39;IntervalDuration=3600;BlockDuration=monthly;HistoryLength=13'),(2,'FB=1_3_4_5_6_7_8_9_10_11_29_12_13_14_15_16_17_18_19_27_28_32_33_34_35_37_38_39_40_41_44;IntervalDuration=3600;BlockDuration=monthly;HistoryLength=13'),(3,'FB=45');
/*!40000 ALTER TABLE `application_information_scopes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `authorizations`
--

DROP TABLE IF EXISTS `authorizations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `authorizations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  `published` datetime DEFAULT NULL,
  `self_link_href` varchar(255) DEFAULT NULL,
  `self_link_rel` varchar(255) DEFAULT 'self',
  `up_link_href` varchar(255) DEFAULT NULL,
  `up_link_rel` varchar(255) DEFAULT 'up',
  `updated` datetime DEFAULT NULL,
  `uuid` varchar(255) NOT NULL,
  `access_token` varchar(255) DEFAULT NULL,
  `authorization_uri` varchar(255) DEFAULT NULL,
  `ap_duration` bigint DEFAULT NULL,
  `ap_start` bigint DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  `error` int DEFAULT NULL,
  `errorDescription` varchar(255) DEFAULT NULL,
  `errorUri` varchar(255) DEFAULT NULL,
  `expiresIn` bigint DEFAULT NULL,
  `grantType` int DEFAULT NULL,
  `pp_duration` bigint DEFAULT NULL,
  `pp_start` bigint DEFAULT NULL,
  `refreshToken` varchar(255) DEFAULT NULL,
  `resourceURI` varchar(255) DEFAULT NULL,
  `responseType` int DEFAULT NULL,
  `scope` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `third_party` varchar(255) DEFAULT NULL,
  `tokenType` int DEFAULT NULL,
  `application_information_id` bigint DEFAULT NULL,
  `retail_customer_id` bigint DEFAULT NULL,
  `subscription_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_d0761ae9d2dd44c49867ac4ec4b` (`application_information_id`),
  KEY `FK_a4fccef421a14e0ead5c1b9753d` (`retail_customer_id`),
  KEY `FK_subscriptionkey` (`subscription_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `authorizations`
--

LOCK TABLES `authorizations` WRITE;
/*!40000 ALTER TABLE `authorizations` DISABLE KEYS */;
INSERT INTO `authorizations` VALUES (1,NULL,'2015-05-15 15:02:39',NULL,'self',NULL,'up','2015-05-15 15:02:40','A1635478-76A7-449D-8AE9-EBB191352C25','2a85f4bd-30db-4b7d-8f41-b046b0566cb3','http://localhost:8080/DataCustodian/espi/1_1/resource/Authorization/1',0,0,NULL,NULL,NULL,NULL,1747076559,NULL,0,0,NULL,'http://localhost:8080/DataCustodian/espi/1_1/resource/',NULL,'FB=3_19_32_33_34_35_36_37_38_41_44_45',NULL,'1','data_custodian',0,1,0,1),(2,NULL,'2015-05-15 15:02:53',NULL,'self',NULL,'up','2015-05-15 15:02:53','63463495-7D32-4E45-8775-3B35AC60E13F','03909715-b0ca-4797-9a9a-601fff1d2848','http://localhost:8080/DataCustodian/espi/1_1/resource/Authorization/2',0,0,NULL,NULL,NULL,NULL,1747076572,NULL,0,0,NULL,'http://localhost:8080/DataCustodian/espi/1_1/resource/Batch/RetailCustomer/**/UsagePoint',NULL,'FB=45',NULL,'1','upload',0,3,0,2),(3,NULL,'2015-05-15 15:02:56',NULL,'self',NULL,'up','2015-05-15 15:02:56','766A7FBC-BB0B-41D1-801F-0E91EA0A3A64','53520584-d640-4812-a721-8a1afa459ff7','http://localhost:8080/DataCustodian/espi/1_1/resource/Authorization/3',0,0,NULL,NULL,NULL,NULL,1747076575,NULL,0,0,NULL,'http://localhost:8080/DataCustodian/espi/1_1/resource/Batch/Bulk/**',NULL,'FB=34_35',NULL,'1','third_party_admin',0,2,0,3),(4,NULL,'2015-05-15 15:03:02',NULL,'self',NULL,'up','2015-05-15 15:03:02','403CBA0C-46F5-4E64-816C-5D11C06DEB7A','c66b0854-ea1f-4e24-afb7-afab9e0f6c5e','http://localhost:8080/DataCustodian/espi/1_1/resource/Authorization/4',0,0,NULL,NULL,NULL,NULL,1747076581,NULL,0,0,NULL,'http://localhost:8080/DataCustodian/espi/1_1/resource/ApplicationInformation/2',NULL,'FB=36_40',NULL,'1','REGISTRATION_third_party',0,2,0,4),(5,NULL,'2025-05-14 08:46:31',NULL,'self',NULL,'up','2025-05-14 08:46:31','D167DA0C-B47C-4736-AF9E-98B1A88B3955','ZDBnykYV45-AmAzsYuttR0qcJyA','http://localhost:8080/DataCustodian/espi/1_1/resource/Authorization/5',0,0,NULL,NULL,NULL,NULL,2062597589,NULL,0,0,NULL,'http://localhost:8080/DataCustodian/espi/1_1/resource/',NULL,'FB=3_19_32_33_34_35_36_37_38_41_44_45',NULL,'1','data_custodian',0,1,0,5);
/*!40000 ALTER TABLE `authorizations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `electric_power_quality_summaries`
--

DROP TABLE IF EXISTS `electric_power_quality_summaries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `electric_power_quality_summaries` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  `published` datetime DEFAULT NULL,
  `self_link_href` varchar(255) DEFAULT NULL,
  `self_link_rel` varchar(255) DEFAULT NULL,
  `up_link_href` varchar(255) DEFAULT NULL,
  `up_link_rel` varchar(255) DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  `uuid` varchar(255) NOT NULL,
  `flickerPlt` bigint DEFAULT NULL,
  `flickerPst` bigint DEFAULT NULL,
  `harmonicVoltage` bigint DEFAULT NULL,
  `longInterruptions` bigint DEFAULT NULL,
  `mainsVoltage` bigint DEFAULT NULL,
  `measurementProtocol` smallint DEFAULT NULL,
  `powerFrequency` bigint DEFAULT NULL,
  `rapidVoltageChanges` bigint DEFAULT NULL,
  `shortInterruptions` bigint DEFAULT NULL,
  `duration` bigint DEFAULT NULL,
  `start` bigint DEFAULT NULL,
  `supplyVoltageDips` bigint DEFAULT NULL,
  `supplyVoltageImbalance` bigint DEFAULT NULL,
  `supplyVoltageVariations` bigint DEFAULT NULL,
  `tempOvervoltage` bigint DEFAULT NULL,
  `usage_point_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_a2b7b05e45914898bb9f3e8f2f7` (`uuid`),
  KEY `FK_804ec1c7cfd4488a8fa95388b74` (`usage_point_id`),
  CONSTRAINT `FK_804ec1c7cfd4488a8fa95388b74` FOREIGN KEY (`usage_point_id`) REFERENCES `usage_points` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `electric_power_quality_summaries`
--

LOCK TABLES `electric_power_quality_summaries` WRITE;
/*!40000 ALTER TABLE `electric_power_quality_summaries` DISABLE KEYS */;
/*!40000 ALTER TABLE `electric_power_quality_summaries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `electric_power_usage_summaries`
--

DROP TABLE IF EXISTS `electric_power_usage_summaries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `electric_power_usage_summaries` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  `published` datetime DEFAULT NULL,
  `self_link_href` varchar(255) DEFAULT NULL,
  `self_link_rel` varchar(255) DEFAULT NULL,
  `up_link_href` varchar(255) DEFAULT NULL,
  `up_link_rel` varchar(255) DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  `uuid` varchar(255) NOT NULL,
  `billLastPeriod` bigint DEFAULT NULL,
  `billToDate` bigint DEFAULT NULL,
  `billingPeriod_duration` bigint DEFAULT NULL,
  `billingPeriod_start` bigint DEFAULT NULL,
  `costAdditionalLastPeriod` bigint DEFAULT NULL,
  `currency` varchar(255) DEFAULT NULL,
  `currentBillingPeriodOverAllConsumption_powerOfTenMultiplier` varchar(255) DEFAULT NULL,
  `currentBillingPeriodOverAllConsumption_timeStamp` bigint DEFAULT NULL,
  `currentBillingPeriodOverAllConsumption_uom` varchar(255) DEFAULT NULL,
  `currentBillingPeriodOverAllConsumption_value` bigint DEFAULT NULL,
  `currentDayLastYearNetConsumption_powerOfTenMultiplier` varchar(255) DEFAULT NULL,
  `currentDayLastYearNetConsumption_timeStamp` bigint DEFAULT NULL,
  `currentDayLastYearNetConsumption_uom` varchar(255) DEFAULT NULL,
  `currentDayLastYearNetConsumption_value` bigint DEFAULT NULL,
  `currentDayNetConsumption_powerOfTenMultiplier` varchar(255) DEFAULT NULL,
  `currentDayNetConsumption_timeStamp` bigint DEFAULT NULL,
  `currentDayNetConsumption_uom` varchar(255) DEFAULT NULL,
  `currentDayNetConsumption_value` bigint DEFAULT NULL,
  `currentDayOverallConsumption_powerOfTenMultiplier` varchar(255) DEFAULT NULL,
  `currentDayOverallConsumption_timeStamp` bigint DEFAULT NULL,
  `currentDayOverallConsumption_uom` varchar(255) DEFAULT NULL,
  `currentDayOverallConsumption_value` bigint DEFAULT NULL,
  `overallConsumptionLastPeriod_powerOfTenMultiplier` varchar(255) DEFAULT NULL,
  `overallConsumptionLastPeriod_timeStamp` bigint DEFAULT NULL,
  `overallConsumptionLastPeriod_uom` varchar(255) DEFAULT NULL,
  `overallConsumptionLastPeriod_value` bigint DEFAULT NULL,
  `peakDemand_powerOfTenMultiplier` varchar(255) DEFAULT NULL,
  `peakDemand_timeStamp` bigint DEFAULT NULL,
  `peakDemand_uom` varchar(255) DEFAULT NULL,
  `peakDemand_value` bigint DEFAULT NULL,
  `previousDayLastYearOverallConsumption_powerOfTenMultiplier` varchar(255) DEFAULT NULL,
  `previousDayLastYearOverallConsumption_timeStamp` bigint DEFAULT NULL,
  `previousDayLastYearOverallConsumption_uom` varchar(255) DEFAULT NULL,
  `previousDayLastYearOverallConsumption_value` bigint DEFAULT NULL,
  `previousDayNetConsumption_powerOfTenMultiplier` varchar(255) DEFAULT NULL,
  `previousDayNetConsumption_timeStamp` bigint DEFAULT NULL,
  `previousDayNetConsumption_uom` varchar(255) DEFAULT NULL,
  `previousDayNetConsumption_value` bigint DEFAULT NULL,
  `previousDayOverallConsumption_powerOfTenMultiplier` varchar(255) DEFAULT NULL,
  `previousDayOverallConsumption_timeStamp` bigint DEFAULT NULL,
  `previousDayOverallConsumption_uom` varchar(255) DEFAULT NULL,
  `previousDayOverallConsumption_value` bigint DEFAULT NULL,
  `qualityOfReading` varchar(255) DEFAULT NULL,
  `ratchetDemand_powerOfTenMultiplier` varchar(255) DEFAULT NULL,
  `ratchetDemand_timeStamp` bigint DEFAULT NULL,
  `ratchetDemand_uom` varchar(255) DEFAULT NULL,
  `ratchetDemand_value` bigint DEFAULT NULL,
  `ratchetDemandPeriod_duration` bigint DEFAULT NULL,
  `ratchetDemandPeriod_start` bigint DEFAULT NULL,
  `statusTimeStamp` bigint NOT NULL,
  `usage_point_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_7b7325ca02a9414ea62fcabc984` (`uuid`),
  KEY `FK_73bd63f6333f44ff8c7f628f79d` (`usage_point_id`),
  CONSTRAINT `FK_73bd63f6333f44ff8c7f628f79d` FOREIGN KEY (`usage_point_id`) REFERENCES `usage_points` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `electric_power_usage_summaries`
--

LOCK TABLES `electric_power_usage_summaries` WRITE;
/*!40000 ALTER TABLE `electric_power_usage_summaries` DISABLE KEYS */;
/*!40000 ALTER TABLE `electric_power_usage_summaries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `interval_blocks`
--

DROP TABLE IF EXISTS `interval_blocks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interval_blocks` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  `published` datetime DEFAULT NULL,
  `self_link_href` varchar(255) DEFAULT NULL,
  `self_link_rel` varchar(255) DEFAULT NULL,
  `up_link_href` varchar(255) DEFAULT NULL,
  `up_link_rel` varchar(255) DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  `uuid` varchar(255) NOT NULL,
  `duration` bigint DEFAULT NULL,
  `start` bigint DEFAULT NULL,
  `meter_reading_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_52e33c3a319146ea9dcc64bebd0` (`uuid`),
  KEY `FK_23dcffa0baa44ffb817767d815f` (`meter_reading_id`),
  CONSTRAINT `FK_23dcffa0baa44ffb817767d815f` FOREIGN KEY (`meter_reading_id`) REFERENCES `meter_readings` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `interval_blocks`
--

LOCK TABLES `interval_blocks` WRITE;
/*!40000 ALTER TABLE `interval_blocks` DISABLE KEYS */;
INSERT INTO `interval_blocks` VALUES (1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'173d3a11-d6c6-42a9-b169-8a82fbc12501',86400,1330578000,1),(2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'174bde2e-3c11-4b50-af8a-20c2e3dfef02',86400,1330664400,1);
/*!40000 ALTER TABLE `interval_blocks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `interval_readings`
--

DROP TABLE IF EXISTS `interval_readings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interval_readings` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `cost` bigint DEFAULT NULL,
  `duration` bigint DEFAULT NULL,
  `start` bigint DEFAULT NULL,
  `value` bigint DEFAULT NULL,
  `interval_block_id` bigint DEFAULT NULL,
  `consumptionTier` bigint DEFAULT NULL,
  `tou` bigint DEFAULT NULL,
  `cpp` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_982b1bcd359b47fcb5823a43d21` (`interval_block_id`),
  CONSTRAINT `FK_982b1bcd359b47fcb5823a43d21` FOREIGN KEY (`interval_block_id`) REFERENCES `interval_blocks` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=193 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `interval_readings`
--

LOCK TABLES `interval_readings` WRITE;
/*!40000 ALTER TABLE `interval_readings` DISABLE KEYS */;
INSERT INTO `interval_readings` VALUES (1,974,900,1330578000,282,1,NULL,NULL,NULL),(2,965,900,1330578900,323,1,NULL,NULL,NULL),(3,884,900,1330579800,294,1,NULL,NULL,NULL),(4,995,900,1330580700,331,1,NULL,NULL,NULL),(5,965,900,1330581600,321,1,NULL,NULL,NULL),(6,948,900,1330582500,316,1,NULL,NULL,NULL),(7,898,900,1330583400,299,1,NULL,NULL,NULL),(8,976,900,1330584300,325,1,NULL,NULL,NULL),(9,991,900,1330585200,330,1,NULL,NULL,NULL),(10,828,900,1330586100,276,1,NULL,NULL,NULL),(11,892,900,1330587000,297,1,NULL,NULL,NULL),(12,875,900,1330587900,291,1,NULL,NULL,NULL),(13,978,900,1330588800,326,1,NULL,NULL,NULL),(14,954,900,1330589700,318,1,NULL,NULL,NULL),(15,839,900,1330590600,279,1,NULL,NULL,NULL),(16,821,900,1330591500,273,1,NULL,NULL,NULL),(17,910,900,1330592400,303,1,NULL,NULL,NULL),(18,977,900,1330593300,325,1,NULL,NULL,NULL),(19,987,900,1330594200,329,1,NULL,NULL,NULL),(20,858,900,1330595100,286,1,NULL,NULL,NULL),(21,2561,900,1330596000,853,1,NULL,NULL,NULL),(22,2558,900,1330596900,852,1,NULL,NULL,NULL),(23,2542,900,1330597800,847,1,NULL,NULL,NULL),(24,2630,900,1330598700,876,1,NULL,NULL,NULL),(25,9643,900,1330599600,1607,1,NULL,NULL,NULL),(26,9787,900,1330600500,1631,1,NULL,NULL,NULL),(27,9547,900,1330601400,1591,1,NULL,NULL,NULL),(28,9574,900,1330602300,1595,1,NULL,NULL,NULL),(29,8282,900,1330603200,1380,1,NULL,NULL,NULL),(30,9330,900,1330604100,1555,1,NULL,NULL,NULL),(31,8667,900,1330605000,1444,1,NULL,NULL,NULL),(32,8544,900,1330605900,1424,1,NULL,NULL,NULL),(33,8332,900,1330606800,1388,1,NULL,NULL,NULL),(34,9694,900,1330607700,1615,1,NULL,NULL,NULL),(35,8304,900,1330608600,1384,1,NULL,NULL,NULL),(36,9711,900,1330609500,1618,1,NULL,NULL,NULL),(37,8682,900,1330610400,1447,1,NULL,NULL,NULL),(38,8427,900,1330611300,1404,1,NULL,NULL,NULL),(39,9584,900,1330612200,1597,1,NULL,NULL,NULL),(40,8448,900,1330613100,1408,1,NULL,NULL,NULL),(41,5292,900,1330614000,882,1,NULL,NULL,NULL),(42,5123,900,1330614900,853,1,NULL,NULL,NULL),(43,5963,900,1330615800,993,1,NULL,NULL,NULL),(44,5641,900,1330616700,940,1,NULL,NULL,NULL),(45,5656,900,1330617600,942,1,NULL,NULL,NULL),(46,5677,900,1330618500,946,1,NULL,NULL,NULL),(47,5075,900,1330619400,845,1,NULL,NULL,NULL),(48,5168,900,1330620300,861,1,NULL,NULL,NULL),(49,5877,900,1330621200,979,1,NULL,NULL,NULL),(50,5611,900,1330622100,935,1,NULL,NULL,NULL),(51,5932,900,1330623000,988,1,NULL,NULL,NULL),(52,5243,900,1330623900,873,1,NULL,NULL,NULL),(53,5599,900,1330624800,933,1,NULL,NULL,NULL),(54,5786,900,1330625700,964,1,NULL,NULL,NULL),(55,5475,900,1330626600,912,1,NULL,NULL,NULL),(56,5592,900,1330627500,932,1,NULL,NULL,NULL),(57,11422,900,1330628400,951,1,NULL,NULL,NULL),(58,11026,900,1330629300,918,1,NULL,NULL,NULL),(59,10592,900,1330630200,882,1,NULL,NULL,NULL),(60,10094,900,1330631100,841,1,NULL,NULL,NULL),(61,16299,900,1330632000,905,1,NULL,NULL,NULL),(62,17502,900,1330632900,972,1,NULL,NULL,NULL),(63,15167,900,1330633800,842,1,NULL,NULL,NULL),(64,14879,900,1330634700,826,1,NULL,NULL,NULL),(65,20511,900,1330635600,854,1,NULL,NULL,NULL),(66,21834,900,1330636500,909,1,NULL,NULL,NULL),(67,23895,900,1330637400,995,1,NULL,NULL,NULL),(68,21110,900,1330638300,879,1,NULL,NULL,NULL),(69,33485,900,1330639200,1116,1,NULL,NULL,NULL),(70,37850,900,1330640100,1261,1,NULL,NULL,NULL),(71,39192,900,1330641000,1306,1,NULL,NULL,NULL),(72,34924,900,1330641900,1164,1,NULL,NULL,NULL),(73,44125,900,1330642800,1470,1,NULL,NULL,NULL),(74,47955,900,1330643700,1598,1,NULL,NULL,NULL),(75,45117,900,1330644600,1503,1,NULL,NULL,NULL),(76,45246,900,1330645500,1508,1,NULL,NULL,NULL),(77,35606,900,1330646400,1483,1,NULL,NULL,NULL),(78,34141,900,1330647300,1422,1,NULL,NULL,NULL),(79,38734,900,1330648200,1613,1,NULL,NULL,NULL),(80,38415,900,1330649100,1600,1,NULL,NULL,NULL),(81,27463,900,1330650000,1525,1,NULL,NULL,NULL),(82,29200,900,1330650900,1622,1,NULL,NULL,NULL),(83,29211,900,1330651800,1622,1,NULL,NULL,NULL),(84,29495,900,1330652700,1638,1,NULL,NULL,NULL),(85,19146,900,1330653600,1595,1,NULL,NULL,NULL),(86,18504,900,1330654500,1542,1,NULL,NULL,NULL),(87,18624,900,1330655400,1552,1,NULL,NULL,NULL),(88,19830,900,1330656300,1652,1,NULL,NULL,NULL),(89,5833,900,1330657200,972,1,NULL,NULL,NULL),(90,5919,900,1330658100,986,1,NULL,NULL,NULL),(91,5012,900,1330659000,835,1,NULL,NULL,NULL),(92,5262,900,1330659900,877,1,NULL,NULL,NULL),(93,934,900,1330660800,311,1,NULL,NULL,NULL),(94,839,900,1330661700,279,1,NULL,NULL,NULL),(95,835,900,1330662600,278,1,NULL,NULL,NULL),(96,974,900,1330663500,324,1,NULL,NULL,NULL),(97,938,900,1330664400,312,2,NULL,NULL,NULL),(98,888,900,1330665300,296,2,NULL,NULL,NULL),(99,909,900,1330666200,303,2,NULL,NULL,NULL),(100,862,900,1330667100,287,2,NULL,NULL,NULL),(101,991,900,1330668000,330,2,NULL,NULL,NULL),(102,901,900,1330668900,300,2,NULL,NULL,NULL),(103,945,900,1330669800,315,2,NULL,NULL,NULL),(104,931,900,1330670700,310,2,NULL,NULL,NULL),(105,839,900,1330671600,279,2,NULL,NULL,NULL),(106,877,900,1330672500,292,2,NULL,NULL,NULL),(107,872,900,1330673400,290,2,NULL,NULL,NULL),(108,911,900,1330674300,303,2,NULL,NULL,NULL),(109,976,900,1330675200,325,2,NULL,NULL,NULL),(110,991,900,1330676100,330,2,NULL,NULL,NULL),(111,828,900,1330677000,276,2,NULL,NULL,NULL),(112,892,900,1330677900,297,2,NULL,NULL,NULL),(113,875,900,1330678800,291,2,NULL,NULL,NULL),(114,978,900,1330679700,326,2,NULL,NULL,NULL),(115,954,900,1330680600,318,2,NULL,NULL,NULL),(116,839,900,1330681500,279,2,NULL,NULL,NULL),(117,821,900,1330682400,273,2,NULL,NULL,NULL),(118,910,900,1330683300,303,2,NULL,NULL,NULL),(119,977,900,1330684200,325,2,NULL,NULL,NULL),(120,987,900,1330685100,329,2,NULL,NULL,NULL),(121,858,900,1330686000,286,2,NULL,NULL,NULL),(122,2561,900,1330686900,853,2,NULL,NULL,NULL),(123,2558,900,1330687800,852,2,NULL,NULL,NULL),(124,2542,900,1330688700,847,2,NULL,NULL,NULL),(125,2630,900,1330689600,876,2,NULL,NULL,NULL),(126,9643,900,1330690500,1607,2,NULL,NULL,NULL),(127,9787,900,1330691400,1631,2,NULL,NULL,NULL),(128,9547,900,1330692300,1591,2,NULL,NULL,NULL),(129,9574,900,1330693200,1595,2,NULL,NULL,NULL),(130,8282,900,1330694100,1380,2,NULL,NULL,NULL),(131,9330,900,1330695000,1555,2,NULL,NULL,NULL),(132,8667,900,1330695900,1444,2,NULL,NULL,NULL),(133,8544,900,1330696800,1424,2,NULL,NULL,NULL),(134,8332,900,1330697700,1388,2,NULL,NULL,NULL),(135,9694,900,1330698600,1615,2,NULL,NULL,NULL),(136,8304,900,1330699500,1384,2,NULL,NULL,NULL),(137,9711,900,1330700400,1618,2,NULL,NULL,NULL),(138,8682,900,1330701300,1447,2,NULL,NULL,NULL),(139,8427,900,1330702200,1404,2,NULL,NULL,NULL),(140,9584,900,1330703100,1597,2,NULL,NULL,NULL),(141,8448,900,1330704000,1408,2,NULL,NULL,NULL),(142,5292,900,1330704900,882,2,NULL,NULL,NULL),(143,5123,900,1330705800,853,2,NULL,NULL,NULL),(144,5963,900,1330706700,993,2,NULL,NULL,NULL),(145,5641,900,1330707600,940,2,NULL,NULL,NULL),(146,5656,900,1330708500,942,2,NULL,NULL,NULL),(147,5677,900,1330709400,946,2,NULL,NULL,NULL),(148,5075,900,1330710300,845,2,NULL,NULL,NULL),(149,5168,900,1330711200,861,2,NULL,NULL,NULL),(150,5877,900,1330712100,979,2,NULL,NULL,NULL),(151,5611,900,1330713000,935,2,NULL,NULL,NULL),(152,5932,900,1330713900,988,2,NULL,NULL,NULL),(153,5243,900,1330714800,873,2,NULL,NULL,NULL),(154,5599,900,1330715700,933,2,NULL,NULL,NULL),(155,5786,900,1330716600,964,2,NULL,NULL,NULL),(156,5475,900,1330717500,912,2,NULL,NULL,NULL),(157,5592,900,1330718400,932,2,NULL,NULL,NULL),(158,11422,900,1330719300,951,2,NULL,NULL,NULL),(159,11026,900,1330720200,918,2,NULL,NULL,NULL),(160,10592,900,1330721100,882,2,NULL,NULL,NULL),(161,10094,900,1330722000,841,2,NULL,NULL,NULL),(162,16299,900,1330722900,905,2,NULL,NULL,NULL),(163,17502,900,1330723800,972,2,NULL,NULL,NULL),(164,15167,900,1330724700,842,2,NULL,NULL,NULL),(165,14879,900,1330725600,826,2,NULL,NULL,NULL),(166,20511,900,1330726500,854,2,NULL,NULL,NULL),(167,21834,900,1330727400,909,2,NULL,NULL,NULL),(168,23895,900,1330728300,995,2,NULL,NULL,NULL),(169,45871,900,1330729200,1529,2,NULL,NULL,NULL),(170,45108,900,1330730100,1503,2,NULL,NULL,NULL),(171,46485,900,1330731000,1543,2,NULL,NULL,NULL),(172,34924,900,1330731900,1164,2,NULL,NULL,NULL),(173,44125,900,1330732800,1470,2,NULL,NULL,NULL),(174,47955,900,1330733700,1598,2,NULL,NULL,NULL),(175,45117,900,1330734600,1503,2,NULL,NULL,NULL),(176,45246,900,1330735500,1508,2,NULL,NULL,NULL),(177,35606,900,1330736400,1483,2,NULL,NULL,NULL),(178,34141,900,1330737300,1422,2,NULL,NULL,NULL),(179,38734,900,1330738200,1613,2,NULL,NULL,NULL),(180,38415,900,1330739100,1600,2,NULL,NULL,NULL),(181,27463,900,1330740000,1525,2,NULL,NULL,NULL),(182,29200,900,1330740900,1622,2,NULL,NULL,NULL),(183,29211,900,1330741800,1622,2,NULL,NULL,NULL),(184,29495,900,1330742700,1638,2,NULL,NULL,NULL),(185,19146,900,1330743600,1595,2,NULL,NULL,NULL),(186,18504,900,1330744500,1542,2,NULL,NULL,NULL),(187,5012,900,1330745400,835,2,NULL,NULL,NULL),(188,5262,900,1330746300,877,2,NULL,NULL,NULL),(189,934,900,1330747200,311,2,NULL,NULL,NULL),(190,839,900,1330748100,279,2,NULL,NULL,NULL),(191,835,900,1330749000,278,2,NULL,NULL,NULL),(192,974,900,1330749900,324,2,NULL,NULL,NULL);
/*!40000 ALTER TABLE `interval_readings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `line_item`
--

DROP TABLE IF EXISTS `line_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `line_item` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `amount` bigint NOT NULL,
  `dateTime` bigint NOT NULL,
  `note` varchar(255) DEFAULT NULL,
  `rounding` bigint DEFAULT NULL,
  `electric_power_usage_summary_id` bigint DEFAULT NULL,
  `usage_summary_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_5910ba965b7e41cd9bbe7949fbb` (`electric_power_usage_summary_id`),
  KEY `fk_line_item_1_idx` (`usage_summary_id`),
  CONSTRAINT `FK_5910ba965b7e41cd9bbe7949fbb` FOREIGN KEY (`electric_power_usage_summary_id`) REFERENCES `electric_power_usage_summaries` (`id`),
  CONSTRAINT `fk_line_item_1` FOREIGN KEY (`usage_summary_id`) REFERENCES `usage_summaries` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `line_item`
--

LOCK TABLES `line_item` WRITE;
/*!40000 ALTER TABLE `line_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `line_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `meter_reading_related_links`
--

DROP TABLE IF EXISTS `meter_reading_related_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `meter_reading_related_links` (
  `meter_reading_id` bigint NOT NULL,
  `href` varchar(255) DEFAULT NULL,
  `rel` varchar(255) DEFAULT NULL,
  KEY `FK_bf71138af7384923bd0b190ac4c` (`meter_reading_id`),
  CONSTRAINT `FK_bf71138af7384923bd0b190ac4c` FOREIGN KEY (`meter_reading_id`) REFERENCES `meter_readings` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `meter_reading_related_links`
--

LOCK TABLES `meter_reading_related_links` WRITE;
/*!40000 ALTER TABLE `meter_reading_related_links` DISABLE KEYS */;
/*!40000 ALTER TABLE `meter_reading_related_links` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `meter_readings`
--

DROP TABLE IF EXISTS `meter_readings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `meter_readings` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  `published` datetime DEFAULT NULL,
  `self_link_href` varchar(255) DEFAULT NULL,
  `self_link_rel` varchar(255) DEFAULT NULL,
  `up_link_href` varchar(255) DEFAULT NULL,
  `up_link_rel` varchar(255) DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  `uuid` varchar(255) NOT NULL,
  `reading_type_id` bigint DEFAULT NULL,
  `usage_point_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_445adb83af2e4fa4928a31692e4` (`uuid`),
  KEY `FK_67563dc6050e46ba9fcbc86b721` (`reading_type_id`),
  KEY `FK_8eaf32259169401e8cae99a5891` (`usage_point_id`),
  CONSTRAINT `FK_67563dc6050e46ba9fcbc86b721` FOREIGN KEY (`reading_type_id`) REFERENCES `reading_types` (`id`),
  CONSTRAINT `FK_8eaf32259169401e8cae99a5891` FOREIGN KEY (`usage_point_id`) REFERENCES `usage_points` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `meter_readings`
--

LOCK TABLES `meter_readings` WRITE;
/*!40000 ALTER TABLE `meter_readings` DISABLE KEYS */;
INSERT INTO `meter_readings` VALUES (1,'Fifteen-Minute Electricity Consumption',NULL,NULL,NULL,NULL,NULL,NULL,'01a91442-cd08-4fa5-94e6-2e384b7169b8',1,1);
/*!40000 ALTER TABLE `meter_readings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reading_qualities`
--

DROP TABLE IF EXISTS `reading_qualities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reading_qualities` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `quality` varchar(255) DEFAULT NULL,
  `interval_reading_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_11d630a57d684f26894e1cd6aa6` (`interval_reading_id`),
  CONSTRAINT `FK_11d630a57d684f26894e1cd6aa6` FOREIGN KEY (`interval_reading_id`) REFERENCES `interval_readings` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reading_qualities`
--

LOCK TABLES `reading_qualities` WRITE;
/*!40000 ALTER TABLE `reading_qualities` DISABLE KEYS */;
/*!40000 ALTER TABLE `reading_qualities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reading_types`
--

DROP TABLE IF EXISTS `reading_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reading_types` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  `published` datetime DEFAULT NULL,
  `self_link_href` varchar(255) DEFAULT NULL,
  `self_link_rel` varchar(255) DEFAULT NULL,
  `up_link_href` varchar(255) DEFAULT NULL,
  `up_link_rel` varchar(255) DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  `uuid` varchar(255) NOT NULL,
  `accumulationBehaviour` varchar(255) DEFAULT NULL,
  `rational_denominator` decimal(19,2) DEFAULT NULL,
  `rational_numerator` decimal(19,2) DEFAULT NULL,
  `commodity` varchar(255) DEFAULT NULL,
  `consumptionTier` varchar(255) DEFAULT NULL,
  `cpp` varchar(255) DEFAULT NULL,
  `currency` varchar(255) DEFAULT NULL,
  `dataQualifier` varchar(255) DEFAULT NULL,
  `defaultQuality` varchar(255) DEFAULT NULL,
  `flowDirection` varchar(255) DEFAULT NULL,
  `interharmonic_denominator` decimal(19,2) DEFAULT NULL,
  `interharmonic_numerator` decimal(19,2) DEFAULT NULL,
  `intervalLength` bigint DEFAULT NULL,
  `kind` varchar(255) DEFAULT NULL,
  `measuringPeriod` varchar(255) DEFAULT NULL,
  `phase` varchar(255) DEFAULT NULL,
  `powerOfTenMultiplier` varchar(255) DEFAULT NULL,
  `timeAttribute` varchar(255) DEFAULT NULL,
  `tou` varchar(255) DEFAULT NULL,
  `uom` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_0246e3bcf2a34f8f9a8c992140f` (`uuid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reading_types`
--

LOCK TABLES `reading_types` WRITE;
/*!40000 ALTER TABLE `reading_types` DISABLE KEYS */;
INSERT INTO `reading_types` VALUES (1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'07e2c1d4-31d3-4a9f-9626-7a5e5f0b3100','4',NULL,NULL,'1',NULL,NULL,'840','12',NULL,'1',NULL,NULL,900,'12',NULL,'769','0','0',NULL,'72');
/*!40000 ALTER TABLE `reading_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reading_types_meter_readings`
--

DROP TABLE IF EXISTS `reading_types_meter_readings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reading_types_meter_readings` (
  `reading_types_id` bigint NOT NULL,
  `meterReadings_id` bigint NOT NULL,
  UNIQUE KEY `UK_47a670721527488b84a5a98d629` (`meterReadings_id`),
  KEY `FK_041b1404ae52437480cb75e6966` (`meterReadings_id`),
  KEY `FK_5268261ff37f4147a4d1250213f` (`reading_types_id`),
  CONSTRAINT `FK_041b1404ae52437480cb75e6966` FOREIGN KEY (`meterReadings_id`) REFERENCES `meter_readings` (`id`),
  CONSTRAINT `FK_5268261ff37f4147a4d1250213f` FOREIGN KEY (`reading_types_id`) REFERENCES `reading_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reading_types_meter_readings`
--

LOCK TABLES `reading_types_meter_readings` WRITE;
/*!40000 ALTER TABLE `reading_types_meter_readings` DISABLE KEYS */;
/*!40000 ALTER TABLE `reading_types_meter_readings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `resources`
--

DROP TABLE IF EXISTS `resources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `resources` (
  `id` bigint NOT NULL,
  `uri` varchar(255) DEFAULT NULL,
  KEY `FK_37f4ae42a5f94b85ac063017869` (`id`),
  CONSTRAINT `FK_37f4ae42a5f94b85ac063017869` FOREIGN KEY (`id`) REFERENCES `BatchList` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resources`
--

LOCK TABLES `resources` WRITE;
/*!40000 ALTER TABLE `resources` DISABLE KEYS */;
/*!40000 ALTER TABLE `resources` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `retail_customers`
--

DROP TABLE IF EXISTS `retail_customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `retail_customers` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  `published` datetime DEFAULT NULL,
  `self_link_href` varchar(255) DEFAULT NULL,
  `self_link_rel` varchar(255) DEFAULT NULL,
  `up_link_href` varchar(255) DEFAULT NULL,
  `up_link_rel` varchar(255) DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  `uuid` varchar(255) NOT NULL,
  `enabled` bit(1) NOT NULL,
  `first_name` varchar(30) NOT NULL,
  `last_name` varchar(30) NOT NULL,
  `password` varchar(100) DEFAULT NULL,
  `role` varchar(255) NOT NULL,
  `username` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `retail_customers`
--

LOCK TABLES `retail_customers` WRITE;
/*!40000 ALTER TABLE `retail_customers` DISABLE KEYS */;
INSERT INTO `retail_customers` VALUES (0,'','2014-01-02 05:00:00','/RetailCustomer/1','self','/RetailCustomer','up','2014-01-02 05:00:00','F06E8B03-0299-467E-972A-A883ECDCC575',_binary '','Grace','Hopper','koala','ROLE_CUSTODIAN','grace'),(1,'','2014-01-02 05:00:00','/RetailCustomer/1','self','/RetailCustomer','up','2014-01-02 05:00:00','106E8B03-0299-467E-972A-A883ECDCC575',_binary '','Alan','Turing','koala','ROLE_USER','alan'),(2,'','2014-01-02 05:00:00','/RetailCustomer/1','self','/RetailCustomer','up','2014-01-02 05:00:00','206E8B03-0299-467E-972A-A883ECDCC575',_binary '','Donald','Knuth','koala','ROLE_USER','donald'),(3,'','2014-01-02 05:00:00','/RetailCustomer/1','self','/RetailCustomer','up','2014-01-02 05:00:00','306E8B03-0299-467E-972A-A883ECDCC575',_binary '','Paul','Dirac','koala','ROLE_USER','paul'),(4,'','2014-01-02 05:00:00','/RetailCustomer/1','self','/RetailCustomer','up','2014-01-02 05:00:00','406E8B03-0299-467E-972A-A883ECDCC575',_binary '','Alonzo','Church','koala','ROLE_USER','alonzo'),(5,'','2014-01-02 05:00:00','/RetailCustomer/1','self','/RetailCustomer','up','2014-01-02 05:00:00','506E8B03-0299-467E-972A-A883ECDCC575',_binary '','Charles','Babbage','koala','ROLE_USER','charles'),(6,'','2014-01-02 05:00:00','/RetailCustomer/1','self','/RetailCustomer','up','2014-01-02 05:00:00','606E8B03-0299-467E-972A-A883ECDCC575',_binary '','John','von Neumann','koala','ROLE_USER','john'),(7,'','2014-01-02 05:00:00','/RetailCustomer/1','self','/RetailCustomer','up','2014-01-02 05:00:00','706E8B03-0299-467E-972A-A883ECDCC575',_binary '','Marian','Rejewski','koala','ROLE_USER','marian'),(8,'','2014-01-02 05:00:00','/RetailCustomer/1','self','/RetailCustomer','up','2014-01-02 05:00:00','806E8B03-0299-467E-972A-A883ECDCC575',_binary '','Vint','Koala','koala','ROLE_USER','vinny'),(9,'','2014-01-02 05:00:00','/RetailCustomer/1','self','/RetailCustomer','up','2014-01-02 05:00:00','906E8B03-0299-467E-972A-A883ECDCC575',_binary '','Johnny','Koala','koala','ROLE_USER','johnny'),(10,'','2014-01-02 05:00:00','/RetailCustomer/1','self','/RetailCustomer','up','2014-01-02 05:00:00','A06E8B03-0299-467E-972A-A883ECDCC575',_binary '','Don','Koala','koala','ROLE_USER','don'),(11,'','2014-01-02 05:00:00','/RetailCustomer/1','self','/RetailCustomer','up','2014-01-02 05:00:00','B06E8B03-0299-467E-972A-A883ECDCC575',_binary '','Marty','Koala','koala','ROLE_USER','marty'),(12,'','2014-01-02 05:00:00','/RetailCustomer/1','self','/RetailCustomer','up','2014-01-02 05:00:00','C06E8B03-0299-467E-972A-A883ECDCC575',_binary '','Ron','Koala','koala','ROLE_USER','ron'),(13,'','2014-01-02 05:00:00','/RetailCustomer/1','self','/RetailCustomer','up','2014-01-02 05:00:00','D06E8B03-0299-467E-972A-A883ECDCC575',_binary '','Dave','Koala','koala','ROLE_USER','dave'),(14,'','2014-01-02 05:00:00','/RetailCustomer/1','self','/RetailCustomer','up','2014-01-02 05:00:00','E06E8B03-0299-467E-972A-A883ECDCC575',_binary '','net0','NIST','koala','ROLE_USER','net0');
/*!40000 ALTER TABLE `retail_customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service_delivery_points`
--

DROP TABLE IF EXISTS `service_delivery_points`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_delivery_points` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `customerAgreement` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `tariffProfile` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_delivery_points`
--

LOCK TABLES `service_delivery_points` WRITE;
/*!40000 ALTER TABLE `service_delivery_points` DISABLE KEYS */;
/*!40000 ALTER TABLE `service_delivery_points` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subscriptions`
--

DROP TABLE IF EXISTS `subscriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subscriptions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  `published` datetime DEFAULT NULL,
  `self_link_href` varchar(255) DEFAULT NULL,
  `self_link_rel` varchar(255) DEFAULT 'self',
  `up_link_href` varchar(255) DEFAULT NULL,
  `up_link_rel` varchar(255) DEFAULT 'up',
  `updated` datetime DEFAULT NULL,
  `uuid` varchar(255) NOT NULL,
  `hashedId` varchar(255) DEFAULT NULL,
  `lastUpdate` datetime DEFAULT NULL,
  `applicationInformation_id` bigint NOT NULL,
  `authorization_id` bigint DEFAULT NULL,
  `retail_customer_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_a027c87418ce4d7abbde7ee5eec` (`applicationInformation_id`),
  KEY `FK_a68a2938cbc142c3b82f57cb4b1` (`authorization_id`),
  KEY `FK_e38a940ce8ed4d8983d1d5dac6e` (`retail_customer_id`),
  CONSTRAINT `FK_a027c87418ce4d7abbde7ee5eec` FOREIGN KEY (`applicationInformation_id`) REFERENCES `application_information` (`id`),
  CONSTRAINT `FK_e38a940ce8ed4d8983d1d5dac6e` FOREIGN KEY (`retail_customer_id`) REFERENCES `retail_customers` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subscriptions`
--

LOCK TABLES `subscriptions` WRITE;
/*!40000 ALTER TABLE `subscriptions` DISABLE KEYS */;
INSERT INTO `subscriptions` VALUES (1,NULL,'2015-05-15 15:02:40',NULL,'self',NULL,'up','2015-05-15 15:02:40','BE830DC5-3F21-4967-AA35-EFDF8C61A914','4e625c48-3ec2-4571-9e21-d1da0c57516d','2015-05-15 15:02:40',1,1,0),(2,NULL,'2015-05-15 15:02:53',NULL,'self',NULL,'up','2015-05-15 15:02:53','55AE97C3-2DD4-4762-B7BF-11AED8D7AE58','7a60b601-f2c0-41aa-8e71-8dbe42c028d9','2015-05-15 15:02:53',3,2,0),(3,NULL,'2015-05-15 15:02:56',NULL,'self',NULL,'up','2015-05-15 15:02:56','991C0B49-97BA-48C2-BE30-7545C027F72E','82e034de-0812-4c8f-879a-fc367e7fe224','2015-05-15 15:02:56',2,3,0),(4,NULL,'2015-05-15 15:03:02',NULL,'self',NULL,'up','2015-05-15 15:03:02','99F1F395-8883-44F7-8D1D-1DBABDCB7C1F','38a6bea3-cdad-4ab6-af81-2034ad112b0e','2015-05-15 15:03:02',2,4,0),(5,NULL,'2025-05-14 08:46:31',NULL,'self',NULL,'up','2025-05-14 08:46:31','2B880E7B-EA11-4072-A36A-A7B961B8B92F','945ed81f-d37e-486c-88a6-d9edb3cee443','2025-05-14 08:46:31',1,5,0);
/*!40000 ALTER TABLE `subscriptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subscriptions_usage_points`
--

DROP TABLE IF EXISTS `subscriptions_usage_points`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subscriptions_usage_points` (
  `subscriptions_id` bigint NOT NULL,
  `usagePoints_id` bigint NOT NULL,
  KEY `FK_862cd528c4954f4cb2bcdadaf08` (`usagePoints_id`),
  KEY `FK_c138e968ff2d4cd49398210f48c` (`subscriptions_id`),
  CONSTRAINT `FK_c138e968ff2d4cd49398210f48c` FOREIGN KEY (`subscriptions_id`) REFERENCES `subscriptions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subscriptions_usage_points`
--

LOCK TABLES `subscriptions_usage_points` WRITE;
/*!40000 ALTER TABLE `subscriptions_usage_points` DISABLE KEYS */;
/*!40000 ALTER TABLE `subscriptions_usage_points` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `time_configurations`
--

DROP TABLE IF EXISTS `time_configurations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `time_configurations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  `published` datetime DEFAULT NULL,
  `self_link_href` varchar(255) DEFAULT NULL,
  `self_link_rel` varchar(255) DEFAULT NULL,
  `up_link_href` varchar(255) DEFAULT NULL,
  `up_link_rel` varchar(255) DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  `uuid` varchar(255) NOT NULL,
  `dstEndRule` tinyblob,
  `dstOffset` bigint NOT NULL,
  `dstStartRule` tinyblob,
  `tzOffset` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_322e8ed3a1024462a1061593ae2` (`uuid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `time_configurations`
--

LOCK TABLES `time_configurations` WRITE;
/*!40000 ALTER TABLE `time_configurations` DISABLE KEYS */;
INSERT INTO `time_configurations` VALUES (1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'01b347ae-5a1f-4b5a-9e2b-1984ff26e6e1',_binary '´ \0',3600,_binary '6 \0',-18000);
/*!40000 ALTER TABLE `time_configurations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usage_point_related_links`
--

DROP TABLE IF EXISTS `usage_point_related_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usage_point_related_links` (
  `usage_point_id` bigint NOT NULL,
  `href` varchar(255) DEFAULT NULL,
  `rel` varchar(255) DEFAULT NULL,
  KEY `FK_4f728266adfa41b2b8abc65c6e9` (`usage_point_id`),
  CONSTRAINT `FK_4f728266adfa41b2b8abc65c6e9` FOREIGN KEY (`usage_point_id`) REFERENCES `usage_points` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usage_point_related_links`
--

LOCK TABLES `usage_point_related_links` WRITE;
/*!40000 ALTER TABLE `usage_point_related_links` DISABLE KEYS */;
/*!40000 ALTER TABLE `usage_point_related_links` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usage_points`
--

DROP TABLE IF EXISTS `usage_points`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usage_points` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  `published` datetime DEFAULT NULL,
  `self_link_href` varchar(255) DEFAULT NULL,
  `self_link_rel` varchar(255) DEFAULT NULL,
  `up_link_href` varchar(255) DEFAULT NULL,
  `up_link_rel` varchar(255) DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  `uuid` varchar(255) NOT NULL,
  `roleFlags` tinyblob,
  `status` smallint DEFAULT NULL,
  `uri` varchar(255) DEFAULT NULL,
  `localTimeParameters_id` bigint DEFAULT NULL,
  `retail_customer_id` bigint DEFAULT NULL,
  `serviceCategory_kind` bigint NOT NULL,
  `serviceDeliveryPoint_id` bigint DEFAULT NULL,
  `subscription_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_d3b5c06a4b994ad8906ead9757f` (`uuid`),
  KEY `FK_9fa5cbe1eaeb4dbfb7209cb0213` (`localTimeParameters_id`),
  KEY `FK_41107ba4248e4bf79b62c405385` (`retail_customer_id`),
  KEY `FK_c3909436c6934c8bb14da2bb93b` (`serviceDeliveryPoint_id`),
  KEY `FK_53bcef9479ff4522b63a46e018c` (`subscription_id`),
  CONSTRAINT `FK_41107ba4248e4bf79b62c405385` FOREIGN KEY (`retail_customer_id`) REFERENCES `retail_customers` (`id`),
  CONSTRAINT `FK_53bcef9479ff4522b63a46e018c` FOREIGN KEY (`subscription_id`) REFERENCES `subscriptions` (`id`),
  CONSTRAINT `FK_9fa5cbe1eaeb4dbfb7209cb0213` FOREIGN KEY (`localTimeParameters_id`) REFERENCES `time_configurations` (`id`),
  CONSTRAINT `FK_c3909436c6934c8bb14da2bb93b` FOREIGN KEY (`serviceDeliveryPoint_id`) REFERENCES `service_delivery_points` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usage_points`
--

LOCK TABLES `usage_points` WRITE;
/*!40000 ALTER TABLE `usage_points` DISABLE KEYS */;
INSERT INTO `usage_points` VALUES (1,'Front Electric Meter',NULL,NULL,NULL,NULL,NULL,NULL,'5446af3f-7d2b-4b40-8f3b-9dfa49c22eeb',NULL,NULL,NULL,1,1,0,NULL,NULL);
/*!40000 ALTER TABLE `usage_points` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usage_summaries`
--

DROP TABLE IF EXISTS `usage_summaries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usage_summaries` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  `published` datetime DEFAULT NULL,
  `self_link_href` varchar(255) DEFAULT NULL,
  `self_link_rel` varchar(255) DEFAULT NULL,
  `up_link_href` varchar(255) DEFAULT NULL,
  `up_link_rel` varchar(255) DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  `uuid` varchar(255) NOT NULL,
  `billLastPeriod` bigint DEFAULT NULL,
  `billToDate` bigint DEFAULT NULL,
  `billingPeriod_duration` bigint DEFAULT NULL,
  `billingPeriod_start` bigint DEFAULT NULL,
  `costAdditionalLastPeriod` bigint DEFAULT NULL,
  `currency` varchar(255) DEFAULT NULL,
  `currentBillingPeriodOverAllConsumption_powerOfTenMultiplier` varchar(255) DEFAULT NULL,
  `currentBillingPeriodOverAllConsumption_timeStamp` bigint DEFAULT NULL,
  `currentBillingPeriodOverAllConsumption_uom` varchar(255) DEFAULT NULL,
  `currentBillingPeriodOverAllConsumption_value` bigint DEFAULT NULL,
  `currentDayLastYearNetConsumption_powerOfTenMultiplier` varchar(255) DEFAULT NULL,
  `currentDayLastYearNetConsumption_timeStamp` bigint DEFAULT NULL,
  `currentDayLastYearNetConsumption_uom` varchar(255) DEFAULT NULL,
  `currentDayLastYearNetConsumption_value` bigint DEFAULT NULL,
  `currentDayNetConsumption_powerOfTenMultiplier` varchar(255) DEFAULT NULL,
  `currentDayNetConsumption_timeStamp` bigint DEFAULT NULL,
  `currentDayNetConsumption_uom` varchar(255) DEFAULT NULL,
  `currentDayNetConsumption_value` bigint DEFAULT NULL,
  `currentDayOverallConsumption_powerOfTenMultiplier` varchar(255) DEFAULT NULL,
  `currentDayOverallConsumption_timeStamp` bigint DEFAULT NULL,
  `currentDayOverallConsumption_uom` varchar(255) DEFAULT NULL,
  `currentDayOverallConsumption_value` bigint DEFAULT NULL,
  `overallConsumptionLastPeriod_powerOfTenMultiplier` varchar(255) DEFAULT NULL,
  `overallConsumptionLastPeriod_timeStamp` bigint DEFAULT NULL,
  `overallConsumptionLastPeriod_uom` varchar(255) DEFAULT NULL,
  `overallConsumptionLastPeriod_value` bigint DEFAULT NULL,
  `peakDemand_powerOfTenMultiplier` varchar(255) DEFAULT NULL,
  `peakDemand_timeStamp` bigint DEFAULT NULL,
  `peakDemand_uom` varchar(255) DEFAULT NULL,
  `peakDemand_value` bigint DEFAULT NULL,
  `previousDayLastYearOverallConsumption_powerOfTenMultiplier` varchar(255) DEFAULT NULL,
  `previousDayLastYearOverallConsumption_timeStamp` bigint DEFAULT NULL,
  `previousDayLastYearOverallConsumption_uom` varchar(255) DEFAULT NULL,
  `previousDayLastYearOverallConsumption_value` bigint DEFAULT NULL,
  `previousDayNetConsumption_powerOfTenMultiplier` varchar(255) DEFAULT NULL,
  `previousDayNetConsumption_timeStamp` bigint DEFAULT NULL,
  `previousDayNetConsumption_uom` varchar(255) DEFAULT NULL,
  `previousDayNetConsumption_value` bigint DEFAULT NULL,
  `previousDayOverallConsumption_powerOfTenMultiplier` varchar(255) DEFAULT NULL,
  `previousDayOverallConsumption_timeStamp` bigint DEFAULT NULL,
  `previousDayOverallConsumption_uom` varchar(255) DEFAULT NULL,
  `previousDayOverallConsumption_value` bigint DEFAULT NULL,
  `qualityOfReading` varchar(255) DEFAULT NULL,
  `ratchetDemand_powerOfTenMultiplier` varchar(255) DEFAULT NULL,
  `ratchetDemand_timeStamp` bigint DEFAULT NULL,
  `ratchetDemand_uom` varchar(255) DEFAULT NULL,
  `ratchetDemand_value` bigint DEFAULT NULL,
  `ratchetDemandPeriod_duration` bigint DEFAULT NULL,
  `ratchetDemandPeriod_start` bigint DEFAULT NULL,
  `statusTimeStamp` bigint NOT NULL,
  `usage_point_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uuid_UNIQUE` (`uuid`),
  KEY `fk_usage_summaries_1_idx` (`usage_point_id`),
  CONSTRAINT `fk_usage_summaries_1` FOREIGN KEY (`usage_point_id`) REFERENCES `usage_points` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usage_summaries`
--

LOCK TABLES `usage_summaries` WRITE;
/*!40000 ALTER TABLE `usage_summaries` DISABLE KEYS */;
/*!40000 ALTER TABLE `usage_summaries` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-23 16:42:48
