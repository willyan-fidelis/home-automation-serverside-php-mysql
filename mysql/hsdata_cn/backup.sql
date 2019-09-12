-- MySQL dump 10.13  Distrib 5.6.24, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: hsdata_db
-- ------------------------------------------------------
-- Server version	5.6.21

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `tdevcmdreqtodblog`
--

DROP TABLE IF EXISTS `tdevcmdreqtodblog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tdevcmdreqtodblog` (
  `OID` bigint(1) unsigned NOT NULL AUTO_INCREMENT,
  `Args` int(1) unsigned DEFAULT NULL,
  `Cmd` varchar(200) DEFAULT NULL,
  `DeviceOID` int(10) unsigned NOT NULL,
  `MobID` varchar(30) DEFAULT '0',
  PRIMARY KEY (`OID`),
  UNIQUE KEY `OID_UNIQUE` (`OID`),
  KEY `FK_tdevcmdreqtodblog_DeviceOID_idx` (`DeviceOID`),
  CONSTRAINT `FK_tdevcmdreqtodblog_DeviceOID` FOREIGN KEY (`DeviceOID`) REFERENCES `tdevice` (`OID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='TDevCmdReqToDBLog - (Table) Device Command Request To Data Base Log';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tdevcmdreqtodblog`
--

LOCK TABLES `tdevcmdreqtodblog` WRITE;
/*!40000 ALTER TABLE `tdevcmdreqtodblog` DISABLE KEYS */;
/*!40000 ALTER TABLE `tdevcmdreqtodblog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tdevice`
--

DROP TABLE IF EXISTS `tdevice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tdevice` (
  `OID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Number` varchar(25) NOT NULL,
  `Name` varchar(30) NOT NULL,
  `TDeviceVersion_OID` int(10) unsigned NOT NULL,
  `Desactvated` tinyint(1) NOT NULL DEFAULT '0',
  `MQTTHost` varchar(45) NOT NULL DEFAULT 'broker.mqttdashboard.com',
  `MQTTPort` int(1) NOT NULL DEFAULT '1883',
  `MQTTClientID` varchar(45) NOT NULL,
  `MQTTPath` varchar(30) NOT NULL,
  `MQTTUser` varchar(30) NOT NULL,
  `MQTTUserPwd` varchar(30) NOT NULL,
  `MQTTTimeOut` int(1) NOT NULL,
  `MQTTQoS` int(1) NOT NULL,
  `MQTTType` varchar(10) NOT NULL COMMENT 'MQTT Type -> Could be null. For exemple: WebSocket, Mosquito..',
  PRIMARY KEY (`OID`),
  UNIQUE KEY `OID_UNIQUE` (`OID`),
  UNIQUE KEY `Number_UNIQUE` (`Number`),
  KEY `fk_TDeviceVersion_OID_idx` (`TDeviceVersion_OID`),
  CONSTRAINT `fk_TDeviceVersion_OID` FOREIGN KEY (`TDeviceVersion_OID`) REFERENCES `tdeviceversion` (`OID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=194 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tdevice`
--

LOCK TABLES `tdevice` WRITE;
/*!40000 ALTER TABLE `tdevice` DISABLE KEYS */;
INSERT INTO `tdevice` VALUES (187,'20161220.001.1206973','NovoComMQTT',3,0,'broker.mqttdashboard.com',1883,'','','','',0,0,''),(188,'20161220.001.16668185','MeuPrimeiroDevice',3,0,'broker.mqttdashboard.com',1883,'0','none','none','none',5,55,'ws'),(193,'20161220.001.16668185B','Last Shared',1,0,'Seu Própio Servidor(Mosquitto)',1883,'','','','',70,0,'4');
/*!40000 ALTER TABLE `tdevice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tdevicemodule`
--

DROP TABLE IF EXISTS `tdevicemodule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tdevicemodule` (
  `OID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `TDevice_OID` int(10) unsigned NOT NULL,
  `Name` varchar(30) NOT NULL,
  `Favorite` tinyint(1) NOT NULL DEFAULT '0',
  `Desactvated` tinyint(1) NOT NULL DEFAULT '0',
  `Position` int(1) NOT NULL,
  `ParentModule` int(1) NOT NULL DEFAULT '0' COMMENT 'Parent Module:\n0 -> Doesn''t have parent module.\n1 - n - > Number of parent module(Position number)',
  PRIMARY KEY (`OID`),
  UNIQUE KEY `OID_UNIQUE` (`OID`),
  KEY `fk_TDevice_OID_idx` (`TDevice_OID`),
  CONSTRAINT `fk_TDeviceOID` FOREIGN KEY (`TDevice_OID`) REFERENCES `tdevice` (`OID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=489 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tdevicemodule`
--

LOCK TABLES `tdevicemodule` WRITE;
/*!40000 ALTER TABLE `tdevicemodule` DISABLE KEYS */;
INSERT INTO `tdevicemodule` VALUES (454,187,'Saida 1',0,0,1,0),(455,187,'Saida 2',0,0,2,0),(456,187,'Fita Vermelha',0,0,3,0),(457,187,'Fita Verde',0,0,4,0),(458,187,'Fita Azul',0,0,5,0),(459,188,'Saida 1',0,0,1,0),(460,188,'Saida 2',0,0,2,0),(461,188,'Fita Vermelha',0,1,3,0),(462,188,'Fita Verde',0,1,4,0),(463,188,'Fita Azul',0,1,5,0),(484,193,'Saida 1',0,0,1,0),(485,193,'Saida 2',0,0,2,0),(486,193,'Fita Vermelha',0,1,3,0),(487,193,'Fita Verde',0,1,4,0),(488,193,'Fita Azul',0,1,5,0);
/*!40000 ALTER TABLE `tdevicemodule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tdeviceversion`
--

DROP TABLE IF EXISTS `tdeviceversion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tdeviceversion` (
  `OID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Type` varchar(4) NOT NULL,
  `SwVersion` varchar(4) NOT NULL,
  `HwVersion` varchar(4) NOT NULL,
  PRIMARY KEY (`OID`),
  UNIQUE KEY `OID_UNIQUE` (`OID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tdeviceversion`
--

LOCK TABLES `tdeviceversion` WRITE;
/*!40000 ALTER TABLE `tdeviceversion` DISABLE KEYS */;
INSERT INTO `tdeviceversion` VALUES (1,'1.0','1.1','1.2'),(2,'1.0','1.2','1.5'),(3,'1.0','1.0','1.0');
/*!40000 ALTER TABLE `tdeviceversion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tdevnetdevicecmd`
--

DROP TABLE IF EXISTS `tdevnetdevicecmd`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tdevnetdevicecmd` (
  `OID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `TDevice_Number` varchar(25) NOT NULL,
  `Cmd` varchar(100) NOT NULL,
  `Position` int(1) NOT NULL,
  `MobileID` varchar(20) NOT NULL,
  PRIMARY KEY (`OID`),
  UNIQUE KEY `OID_UNIQUE` (`OID`),
  KEY `Tdevice_Number_Index` (`TDevice_Number`),
  CONSTRAINT `fk_Number_TDevice` FOREIGN KEY (`TDevice_Number`) REFERENCES `tdevice` (`Number`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=786 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tdevnetdevicecmd`
--

LOCK TABLES `tdevnetdevicecmd` WRITE;
/*!40000 ALTER TABLE `tdevnetdevicecmd` DISABLE KEYS */;
INSERT INTO `tdevnetdevicecmd` VALUES (751,'20161220.001.1206973','-1',0,'-1'),(752,'20161220.001.1206973','-1',1,'-1'),(753,'20161220.001.1206973','-1',2,'-1'),(754,'20161220.001.1206973','-1',3,'-1'),(755,'20161220.001.1206973','-1',4,'-1'),(756,'20161220.001.16668185','-1',0,'-1'),(757,'20161220.001.16668185','-1',1,'-1'),(758,'20161220.001.16668185','-1',2,'-1'),(759,'20161220.001.16668185','-1',3,'-1'),(760,'20161220.001.16668185','-1',4,'-1'),(781,'20161220.001.16668185B','-1',0,'-1'),(782,'20161220.001.16668185B','-1',1,'-1'),(783,'20161220.001.16668185B','-1',2,'-1'),(784,'20161220.001.16668185B','-1',3,'-1'),(785,'20161220.001.16668185B','-1',4,'-1');
/*!40000 ALTER TABLE `tdevnetdevicecmd` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tdevnetdevicecmdctrl`
--

DROP TABLE IF EXISTS `tdevnetdevicecmdctrl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tdevnetdevicecmdctrl` (
  `OID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `TDevice_Number` varchar(25) NOT NULL,
  `InsertPosition` int(1) NOT NULL DEFAULT '0',
  `RemovePosition` int(1) NOT NULL DEFAULT '0',
  `Size` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`OID`),
  UNIQUE KEY `OID_UNIQUE` (`OID`),
  UNIQUE KEY `tdevice_number_UNIQUE` (`TDevice_Number`),
  KEY `fk_TDevice_Number_idx` (`TDevice_Number`),
  CONSTRAINT `fk_TDevice_Number` FOREIGN KEY (`TDevice_Number`) REFERENCES `tdevice` (`Number`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=185 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tdevnetdevicecmdctrl`
--

LOCK TABLES `tdevnetdevicecmdctrl` WRITE;
/*!40000 ALTER TABLE `tdevnetdevicecmdctrl` DISABLE KEYS */;
INSERT INTO `tdevnetdevicecmdctrl` VALUES (178,'20161220.001.1206973',0,0,0),(179,'20161220.001.16668185',0,0,0),(184,'20161220.001.16668185B',0,0,0);
/*!40000 ALTER TABLE `tdevnetdevicecmdctrl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tdevnetdeviceresponse`
--

DROP TABLE IF EXISTS `tdevnetdeviceresponse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tdevnetdeviceresponse` (
  `OID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `TDevice_Number` varchar(25) NOT NULL,
  `Response` varchar(100) NOT NULL,
  `Position` int(1) NOT NULL,
  `MobileID` varchar(20) NOT NULL,
  PRIMARY KEY (`OID`),
  UNIQUE KEY `OID_UNIQUE` (`OID`),
  KEY `Tdevice_Number_TDevice_idx` (`TDevice_Number`),
  CONSTRAINT `fk_Numbe_TDevicer` FOREIGN KEY (`TDevice_Number`) REFERENCES `tdevice` (`Number`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=721 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tdevnetdeviceresponse`
--

LOCK TABLES `tdevnetdeviceresponse` WRITE;
/*!40000 ALTER TABLE `tdevnetdeviceresponse` DISABLE KEYS */;
INSERT INTO `tdevnetdeviceresponse` VALUES (686,'20161220.001.1206973','-1',0,'-1'),(687,'20161220.001.1206973','-1',1,'-1'),(688,'20161220.001.1206973','-1',2,'-1'),(689,'20161220.001.1206973','-1',3,'-1'),(690,'20161220.001.1206973','-1',4,'-1'),(691,'20161220.001.16668185','-1',0,'-1'),(692,'20161220.001.16668185','-1',1,'-1'),(693,'20161220.001.16668185','-1',2,'-1'),(694,'20161220.001.16668185','-1',3,'-1'),(695,'20161220.001.16668185','-1',4,'-1'),(716,'20161220.001.16668185B','-1',0,'-1'),(717,'20161220.001.16668185B','-1',1,'-1'),(718,'20161220.001.16668185B','-1',2,'-1'),(719,'20161220.001.16668185B','-1',3,'-1'),(720,'20161220.001.16668185B','-1',4,'-1');
/*!40000 ALTER TABLE `tdevnetdeviceresponse` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tdevnetdeviceresponsectrl`
--

DROP TABLE IF EXISTS `tdevnetdeviceresponsectrl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tdevnetdeviceresponsectrl` (
  `OID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `TDevice_Number` varchar(25) NOT NULL,
  `InsertPosition` int(1) NOT NULL DEFAULT '0',
  `RemovePosition` int(1) NOT NULL DEFAULT '0',
  `Size` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`OID`),
  UNIQUE KEY `OID_UNIQUE` (`OID`),
  UNIQUE KEY `TDevice_Number_UNIQUE` (`TDevice_Number`),
  KEY `fk_TDevice_Number_idx` (`TDevice_Number`),
  CONSTRAINT `TDevice_Number` FOREIGN KEY (`TDevice_Number`) REFERENCES `tdevice` (`Number`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=167 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tdevnetdeviceresponsectrl`
--

LOCK TABLES `tdevnetdeviceresponsectrl` WRITE;
/*!40000 ALTER TABLE `tdevnetdeviceresponsectrl` DISABLE KEYS */;
INSERT INTO `tdevnetdeviceresponsectrl` VALUES (160,'20161220.001.1206973',0,0,0),(161,'20161220.001.16668185',0,0,0),(166,'20161220.001.16668185B',0,0,0);
/*!40000 ALTER TABLE `tdevnetdeviceresponsectrl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tdevnetstatus`
--

DROP TABLE IF EXISTS `tdevnetstatus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tdevnetstatus` (
  `OID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Status` varchar(100) NOT NULL,
  `TimeStamp` varchar(30) NOT NULL,
  `TDevice_OID` int(10) unsigned NOT NULL,
  PRIMARY KEY (`OID`),
  UNIQUE KEY `OID_UNIQUE` (`OID`),
  UNIQUE KEY `TDevice_OID_UNIQUE` (`TDevice_OID`),
  CONSTRAINT `fk_TDeviceOID_` FOREIGN KEY (`TDevice_OID`) REFERENCES `tdevice` (`OID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tdevnetstatus`
--

LOCK TABLES `tdevnetstatus` WRITE;
/*!40000 ALTER TABLE `tdevnetstatus` DISABLE KEYS */;
/*!40000 ALTER TABLE `tdevnetstatus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tdevtodblog`
--

DROP TABLE IF EXISTS `tdevtodblog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tdevtodblog` (
  `OID` bigint(1) unsigned NOT NULL AUTO_INCREMENT,
  `TDevToDBLogMsgOID` int(1) unsigned NOT NULL,
  `Args` varchar(200) DEFAULT NULL,
  `DeviceOID` int(10) unsigned NOT NULL,
  `MobID` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`OID`),
  UNIQUE KEY `OID_UNIQUE` (`OID`),
  KEY `FK_MsgOID_idx` (`TDevToDBLogMsgOID`),
  KEY `FK_DeviceOID_idx` (`DeviceOID`),
  CONSTRAINT `FK_DeviceOID` FOREIGN KEY (`DeviceOID`) REFERENCES `tdevice` (`OID`) ON DELETE CASCADE,
  CONSTRAINT `FK_MsgOID` FOREIGN KEY (`TDevToDBLogMsgOID`) REFERENCES `tdevtodblogmsg` (`OID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='TDevToDBLog - (Table) Device To Data Base Log';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tdevtodblog`
--

LOCK TABLES `tdevtodblog` WRITE;
/*!40000 ALTER TABLE `tdevtodblog` DISABLE KEYS */;
/*!40000 ALTER TABLE `tdevtodblog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tdevtodblogmsg`
--

DROP TABLE IF EXISTS `tdevtodblogmsg`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tdevtodblogmsg` (
  `OID` int(1) unsigned NOT NULL AUTO_INCREMENT,
  `Msg` varchar(200) NOT NULL,
  PRIMARY KEY (`OID`),
  UNIQUE KEY `OID_UNIQUE` (`OID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='TDevToDBLogMsg - (Table) Device To Data Base Log Messages';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tdevtodblogmsg`
--

LOCK TABLES `tdevtodblogmsg` WRITE;
/*!40000 ALTER TABLE `tdevtodblogmsg` DISABLE KEYS */;
INSERT INTO `tdevtodblogmsg` VALUES (1,'Resposta de Comando Remoto'),(2,'Sensor detectou presença!'),(3,'Dispositivo foi acessado remotamente atraves da nuvem!'),(4,'Novo Endereço de IP atribuido ao dispositivo pela rede local!');
/*!40000 ALTER TABLE `tdevtodblogmsg` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tmod1details`
--

DROP TABLE IF EXISTS `tmod1details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tmod1details` (
  `OID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `TDevice_OID` int(10) unsigned NOT NULL,
  `StaName` varchar(30) NOT NULL DEFAULT 'homesense',
  `StaPwd` varchar(30) NOT NULL DEFAULT 'homesense',
  `ApName` varchar(30) NOT NULL,
  `ApPwd` varchar(30) NOT NULL DEFAULT 'homesense',
  `StaIP` varchar(15) NOT NULL DEFAULT '192.168.0.1',
  PRIMARY KEY (`OID`),
  UNIQUE KEY `TDevice_OID_UNIQUE` (`TDevice_OID`),
  CONSTRAINT `fk_TDevice_OID_` FOREIGN KEY (`TDevice_OID`) REFERENCES `tdevice` (`OID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='TABLE DELETED. DONT USE THIS TABLE ANY MORE!!';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tmod1details`
--

LOCK TABLES `tmod1details` WRITE;
/*!40000 ALTER TABLE `tmod1details` DISABLE KEYS */;
/*!40000 ALTER TABLE `tmod1details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tuser`
--

DROP TABLE IF EXISTS `tuser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tuser` (
  `OID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Email` varchar(30) NOT NULL,
  `Pwd` char(32) NOT NULL,
  `ActiveAcount` tinyint(1) NOT NULL DEFAULT '1',
  `SessionCode` char(32) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`OID`),
  UNIQUE KEY `OID_UNIQUE` (`OID`),
  UNIQUE KEY `Email_UNIQUE` (`Email`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tuser`
--

LOCK TABLES `tuser` WRITE;
/*!40000 ALTER TABLE `tuser` DISABLE KEYS */;
INSERT INTO `tuser` VALUES (1,'abc@gmail','202cb962ac59075b964b07152d234b70',1,'-1'),(16,'teste@gmail','202cb962ac59075b964b07152d234b70',1,'1f11423c839e7122c6ad046b27745dbd');
/*!40000 ALTER TABLE `tuser` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tuserdevice`
--

DROP TABLE IF EXISTS `tuserdevice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tuserdevice` (
  `TUser_OID` int(10) unsigned NOT NULL,
  `TDevice_OID` int(10) unsigned NOT NULL,
  `TUserRoom_Name` varchar(30) NOT NULL,
  `UserRights` int(1) NOT NULL DEFAULT '1' COMMENT 'User Rights:\n1 - Full\n2 - Device was Shared with full rights\n3 - Device was Shared partial with rights - Forbidden DELETE the device\n4 - Device was Shared partial with rights - Forbidden EDIT SOME FIELDS on device\n5 - Device was Shared partial with rights - Forbidden EDIT ALL FIELDS on device\n6 - Device was Shared partial with rights - Allowed COMMANDS ONLY\n7 - Device was Shared partial with rights - Allowed VIEW ONLY',
  PRIMARY KEY (`TUser_OID`,`TDevice_OID`,`TUserRoom_Name`),
  KEY `TUser_OID_UNIQUE` (`TUser_OID`),
  KEY `TDevice_OID_UNIQUE` (`TDevice_OID`),
  KEY `fk_TUserRoom_Name_idx` (`TUserRoom_Name`,`TUser_OID`),
  CONSTRAINT `fk_TDevice_OID` FOREIGN KEY (`TDevice_OID`) REFERENCES `tdevice` (`OID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_TUserRoom` FOREIGN KEY (`TUserRoom_Name`, `TUser_OID`) REFERENCES `tuserroom` (`Name`, `TUser_OID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_Usser_OID` FOREIGN KEY (`TUser_OID`) REFERENCES `tuser` (`OID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tuserdevice`
--

LOCK TABLES `tuserdevice` WRITE;
/*!40000 ALTER TABLE `tuserdevice` DISABLE KEYS */;
INSERT INTO `tuserdevice` VALUES (1,193,'Desconhecido',1),(16,187,'Quarto',1),(16,188,'Desconhecido',1),(16,193,'Desconhecido',1);
/*!40000 ALTER TABLE `tuserdevice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tuserroom`
--

DROP TABLE IF EXISTS `tuserroom`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tuserroom` (
  `OID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(30) NOT NULL,
  `TUser_OID` int(10) unsigned NOT NULL,
  `RoomType` varchar(20) NOT NULL,
  PRIMARY KEY (`Name`,`TUser_OID`),
  UNIQUE KEY `OID_UNIQUE` (`OID`),
  KEY `fk_TUser_OID_idx` (`TUser_OID`),
  CONSTRAINT `fk_TUser_OID` FOREIGN KEY (`TUser_OID`) REFERENCES `tuser` (`OID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tuserroom`
--

LOCK TABLES `tuserroom` WRITE;
/*!40000 ALTER TABLE `tuserroom` DISABLE KEYS */;
INSERT INTO `tuserroom` VALUES (29,'CozinhAA',1,'Jardim'),(14,'Desconhecido',1,'Jardim'),(24,'Desconhecido',16,'Nenhum'),(45,'Minha Sala De Jantar',16,'Sala'),(39,'Quarto',16,'Jardim'),(42,'Quarto Willyan',16,'Quarto'),(38,'Sala2',16,'Jardim');
/*!40000 ALTER TABLE `tuserroom` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'hsdata_db'
--
/*!50003 DROP PROCEDURE IF EXISTS `SpCreatDevType1` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpCreatDevType1`(in _Number varchar(25), in _Name varchar(30), in _TDeviceVersion_OID int(10), in _Desactvated int(1), out _DevOID int(10), in _MQTTHost varchar(45), in _MQTTPort int(1), in _MQTTClientID varchar(45), in _MQTTPath varchar(30), in _MQTTUser varchar(30), in _MQTTUserPwd varchar(30), in _MQTTTimeOut int(1), in _MQTTQoS int(1), in _MQTTType varchar(10), out _result int(10))
BEGIN

	-- Verify if the device doesn't exist:
	if not exists (SELECT Number FROM tdevice WHERE Number = _Number) then
		insert ignore into tdevice (Number, Name, TDeviceVersion_OID, Desactvated, MQTTHost, MQTTPort, MQTTClientID, MQTTPath, MQTTUser, MQTTUserPwd, MQTTTimeOut, MQTTQoS, MQTTType) values (_Number, _Name, _TDeviceVersion_OID, _Desactvated, _MQTTHost, _MQTTPort, _MQTTClientID, _MQTTPath, _MQTTUser, _MQTTUserPwd, _MQTTTimeOut, _MQTTQoS, _MQTTType); -- , tmod1details.MQTTHost=_MQTTHost, tmod1details.MQTTPort=_MQTTPort, tmod1details.MQTTClientID=_MQTTClientID, tmod1details.MQTTPath=_MQTTPath, tmod1details.MQTTUser=_MQTTUser, tmod1details.MQTTUserPwd=_MQTTUserPwd, tmod1details.MQTTTimeOut=_MQTTTimeOut, tmod1details.MQTTQoS=_MQTTQoS, tmod1details.MQTTType=_MQTTType
        set _result = ROW_COUNT();
        if (_result=1) then
			select OID into _DevOID from tdevice where Number=_Number;
			insert ignore into tdevicemodule (TDevice_OID, Name, Position, Desactvated) values (_DevOID, "Saida 1", 1, 0), (_DevOID, "Saida 2", 2, 0), (_DevOID, "Fita Vermelha", 3, 1), (_DevOID, "Fita Verde", 4, 1), (_DevOID, "Fita Azul", 5, 1);
            set _result = ROW_COUNT(); -- The correct result is 2 at this point.
            -- INSERT ignore INTO `hsdata_db`.`tdevnetstatus` (`Status`, `TimeStamp`, `TDevice_OID`) VALUES ('-1', '-1', _DevOID);
			-- set _result = ROW_COUNT() + _result; -- The correct result is 3 at this point.
            -- INSERT ignore INTO `hsdata_db`.`tmod1details` (`TDevice_OID`, `StaName`, `StaPwd`, `ApName`, `ApPwd`, `StaIP`) VALUES (_DevOID, _StaName, _StaPwd, _ApName, _ApPwd, _StaIP);
            -- set _result = ROW_COUNT() + _result; -- The correct result is 4 at this point.
            if (_result=5) then
				CALL `hsdata_db`.`SpDevNetCreateStruct`(_Number, _result); -- Create DevNet Structure
				set _result = 1;
			else
				set _result = -30; -- Problems to add the two modules!
            end if;
		else
			set _result = -20; -- Any insert error!
        end if;
	else
		select OID into _DevOID from tdevice where Number=_Number;
		set _result = -10; -- Impossible to add. Device already exists!
    end if;
    -- select _result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SpCreateDevice` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpCreateDevice`(in _room varchar(30), in _type varchar(4), in _swvers varchar(4), in _hwvers varchar(4), in _UserEmail varchar(30), _Number varchar(25), in _Name varchar(30), in _MQTTHost varchar(45), in _MQTTPort int(1), in _MQTTClientID varchar(45), in _MQTTPath varchar(30), in _MQTTUser varchar(30), in _MQTTUserPwd varchar(30), in _MQTTTimeOut int(1), in _MQTTQoS int(1), in _MQTTType varchar(10), out _result int)
BEGIN

DECLARE devVersionOID int;
DECLARE userOID int;

	-- First verify if the user exist:
    SELECT OID into userOID FROM tuser WHERE Email = _UserEmail;
    set _result = FOUND_ROWS();
	if (_result=1) then
		
        
        -- First of all test if the version exist:
        SELECT OID into devVersionOID FROM tdeviceversion WHERE Type = _type and SwVersion = _swvers and HwVersion = _hwvers;
        set _result = FOUND_ROWS();
        if (_result=1) then
			-- Now we must creat the new device:
            CALL `hsdata_db`.`SpCreatDevType1`(_Number, _Name, devVersionOID, 0, @devOID, _MQTTHost, _MQTTPort, _MQTTClientID, _MQTTPath, _MQTTUser, _MQTTUserPwd, _MQTTTimeOut, _MQTTQoS, _MQTTType, @res); -- _StaName, _StaPwd, _ApName, _ApPwd, _StaIP, 
            if (@res=1 or @res=-10) then
				-- First check if the relationalship doesn't exist:
                select TUser_OID from tuserdevice where TUser_OID=userOID and TDevice_OID=@devOID;
                set _result = FOUND_ROWS();
                if (_result=1) then
					-- The relationalship already exist:
                    set _result = -50; -- The relationalship already exist
                else
					-- Now Creat an register at relationalship table 'TUserDevice':
					insert ignore into tuserdevice (TUser_OID, TDevice_OID, TUserRoom_Name, UserRights) VALUES (userOID, @devOID, _room, 1);
					set _result = ROW_COUNT();
					if (_result=1) then
						set _result = 1;
					else
						set _result = -40; -- The relationalship could not be created!
					end if;
                end if;

			else
				set _result = @res -100; -- The device could not be created!
            end if;
		else
			set _result = -20; -- version doesn't exist!
        end if;
	else
		set _result = -10; -- user doesn't exist!
    end if;
    select _Number;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SpDevCmdReqGetDBLog` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpDevCmdReqGetDBLog`(in _DevNumber varchar(25), out _result int)
BEGIN

SET @OID = 0;
    
    -- This is only to get the OID for in a second momenet delet it:
    SELECT tdevice.OID into @OID FROM tdevice
    INNER JOIN tdevcmdreqtodblog ON tdevcmdreqtodblog.DeviceOID = tdevice.OID
	where tdevice.Number=_DevNumber LIMIT 1;
    -- set _result = FOUND_ROWS();
    
    -- Select all cmds:
    SELECT tdevcmdreqtodblog.MobID, tdevcmdreqtodblog.Cmd FROM tdevcmdreqtodblog
	-- SELECT tdevcmdreqtodblog.OID into @OID FROM tdevcmdreqtodblog
    INNER JOIN tdevice ON tdevcmdreqtodblog.DeviceOID = tdevice.OID
	where tdevice.Number=_DevNumber LIMIT 10;
    set _result = FOUND_ROWS();
    
	if (_result=0) then
		set _result = -10;
    else
		-- set _result = _result;
        DELETE FROM tdevcmdreqtodblog WHERE tdevcmdreqtodblog.DeviceOID=@OID LIMIT 10;
        set _result = ROW_COUNT();
        
        if (_result=0) then
			set _result = -20;
        else
			set _result = 1;
        end if;
    end if;
    -- set _result =  @OID;
    -- SELECT _result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SpDevCmdReqPutDBLog` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpDevCmdReqPutDBLog`( in _email varchar(30), in _DevNumber varchar(25), in _MobID varchar(30), in _Args int, in _Cmd varchar(200), out _result int)
BEGIN
-- DECLARE insPos int;	
-- DECLARE sz int;
SET @OID = 0;
    
     -- Verify if there are numeber and email information correctly:
	SELECT tdevice.OID into @OID FROM tdevice
	INNER JOIN tuserdevice ON tuserdevice.TDevice_OID = tdevice.OID -- This line select all registers.
	INNER JOIN tuser ON tuser.OID = tuserdevice.TUser_OID -- This line select all registers.
	where tuser.Email=_email and tdevice.Number=_DevNumber; -- This line select one specif user devices.

    set _result = FOUND_ROWS();
    
    if (_result=1) then
		INSERT INTO `hsdata_db`.`tdevcmdreqtodblog` (`Cmd`, `Args`, `DeviceOID`, `MobID`) VALUES (_Cmd, _Args, @OID, _MobID);
		set _result = ROW_COUNT();
        if (_result=1) then
			set _result = 1;
        else
			set _result = -10; -- Insert Command Problems!
		end if;
	else
		set _result = -1;-- No 'tuser.Email=_email and tdevice.Number=_DevNumber' relationalship found!
	end if;
     
    SELECT _result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SpDevNetCreateStruct` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpDevNetCreateStruct`(in _DevNumber varchar(25), out _result int)
BEGIN

DECLARE _result0 int;
DECLARE _result1 int;
DECLARE _result2 int;
	
    
    -- Verify if the device realy doesn't exist:
    -- if not exists (SELECT Number FROM tdevice WHERE Number = _DevNumber) then
				
        -- insert IGNORE into tdevice ( Number, Pwd) values ( _DevNumber, _pwd);
		-- set _result0 = ROW_COUNT();
        insert IGNORE into tdevnetdevicecmdctrl ( TDevice_Number, InsertPosition, RemovePosition, Size) values ( _DevNumber, 0, 0, 0);
		set _result1 = ROW_COUNT();
        insert IGNORE into tdevnetdeviceresponsectrl ( TDevice_Number, InsertPosition, RemovePosition, Size) values ( _DevNumber, 0, 0, 0);
		set _result2 = ROW_COUNT();
        
        INSERT INTO tdevnetdevicecmd
			(TDevice_Number,Cmd,Position, MobileID)
		VALUES
			(_DevNumber,"-1",0, "-1"),
			(_DevNumber,"-1",1, "-1"),
			(_DevNumber,"-1",2, "-1"),
            (_DevNumber,"-1",3, "-1"),
            (_DevNumber,"-1",4, "-1");
        
        INSERT INTO tdevnetdeviceresponse
			(TDevice_Number,Response,Position, MobileID)
		VALUES
			(_DevNumber,"-1",0, "-1"),
			(_DevNumber,"-1",1, "-1"),
			(_DevNumber,"-1",2, "-1"),
            (_DevNumber,"-1",3, "-1"),
            (_DevNumber,"-1",4, "-1");
            
		if (/*_result0 = 1 and */_result1 = 1 and _result2 = 1) then
			set _result = 1;
		-- elseif (_result > 1) then
			-- set _result = -1;
		else 
			set _result = -2; -- Any insert problemans
		end if;
    -- else
		-- set _result = -1; -- device already exists.
    -- end if;
    
    SELECT _result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SpDevNetGetCmd` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpDevNetGetCmd`(in _DevNumber varchar(25),/* in _email varchar(30),*/ out _OutCmd varchar(100), out _MobileID varchar(100), out _CmdSize int, out _result int)
BEGIN
-- LEAVE sp_break_label;

-- DECLARE MazSize int;

DECLARE insPos int;	
DECLARE sz int;
DECLARE RemPos int;
DECLARE command VARCHAR(100);
DECLARE MobID varchar(20);
SET @MazSize = 5; -- Constant variable.

set _CmdSize = 0;
set _OutCmd = 0;
set _MobileID = 0;
    
	-- Verify if there are numeber and email information correctly:
	SELECT tdevice.OID FROM tdevice
	INNER JOIN tuserdevice ON tuserdevice.TDevice_OID = tdevice.OID -- This line select all registers.
	INNER JOIN tuser ON tuser.OID = tuserdevice.TUser_OID -- This line select all registers.
	where /*tuser.Email=_email and */tdevice.Number=_DevNumber; -- This line select one specif user devices.

    set _result = FOUND_ROWS();
	if (_result=1) then
    -- if exists (SELECT Number, pwd FROM tdevice WHERE Number = _DevNumber and pwd = _pwd) then
		-- Get some control data in data base:
        SELECT InsertPosition, Size, RemovePosition into insPos, sz, RemPos FROM tdevnetdevicecmdctrl WHERE TDevice_Number = _DevNumber;
        set _result = FOUND_ROWS();-- ROW_COUNT();
        -- Verify if has any result:
        if (_result = 1) then
			-- Check if the queue is not empty:
            if (sz = 0) then
				set _result = -20; -- nothing to remove!
			else
				-- Now get the command on the correct table:
				SELECT Cmd, MobileID into command, MobID FROM tdevnetdevicecmd WHERE TDevice_Number = _DevNumber and Position = RemPos;
				set _result = FOUND_ROWS();-- ROW_COUNT();
                -- Chek if it found any register:
                if (_result = 1) then
					-- Mark the removed elements with '-1':
					UPDATE tdevnetdevicecmd
					SET Cmd='-1', MobileID='-1'
					WHERE TDevice_Number=_DevNumber and Position=RemPos;
                    
					-- Now add the remove pointer and the actual size:
					set RemPos = RemPos + 1;
					set sz = sz - 1;
					-- Check if the remove point must be cleared:
					if (RemPos >= @MazSize) then
						set RemPos = 0;
					end if;
					-- Now updata the control data table:
					UPDATE tdevnetdevicecmdctrl
					SET InsertPosition=insPos, Size=sz, RemovePosition=RemPos 
					WHERE TDevice_Number=_DevNumber;
					set _result = ROW_COUNT();
					-- Verify if has any result:
					if (_result = 1) then
						select command, MobID; -- This select returns the command string to be used!
                        set _OutCmd = command;
                        set _MobileID = MobID;
                        set _CmdSize = sz;
                        set _result = 1; -- Reult: Every things went fine!
					else
						set _result = -11; -- error!
					end if;
				else
					set _result = -21; -- nothing to remove! The Queue is crazing!
                end if;
            end if;
		else
			set _result = -10; -- error!
        end if;
    else
		set _result = -1; -- Login incorrect(Number or Password worng)
    end if;
    
        -- If the response is not ok, so we select the result to avoid problens on the client side:
    -- if (_result<>1) then
	-- 	SELECT _result;
    -- end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SpDevNetGetResponse` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpDevNetGetResponse`(in _DevNumber varchar(25), in _email varchar(30), in _MobileID varchar(20), out _OutCmd varchar(100), out _result int)
BEGIN
-- LEAVE sp_break_label;

-- DECLARE MazSize int;

DECLARE insPos int;	
DECLARE sz int;
DECLARE RemPos int;
DECLARE resp VARCHAR(100);
SET @MazSize = 5; -- Constant variable.
    
    -- Verify if there are numeber and email information correctly:
	SELECT tdevice.OID FROM tdevice
	INNER JOIN tuserdevice ON tuserdevice.TDevice_OID = tdevice.OID -- This line select all registers.
	INNER JOIN tuser ON tuser.OID = tuserdevice.TUser_OID -- This line select all registers.
	where tuser.Email=_email and tdevice.Number=_DevNumber; -- This line select one specif user devices.

    set _result = FOUND_ROWS();
	if (_result=1) then
    -- if exists (SELECT Number, pwd FROM tdevice WHERE Number = _DevNumber and pwd = _pwd) then
		-- Get some control data in data base:
        SELECT InsertPosition, Size, RemovePosition into insPos, sz, RemPos FROM tdevnetdeviceresponsectrl WHERE TDevice_Number = _DevNumber;
        set _result = FOUND_ROWS();-- ROW_COUNT();
        -- Verify if has any result:
        if (_result = 1) then
			-- Check if the queue is not empty:
            if (sz = 0) then
				set _result = -20; -- nothing to remove!
			else
				-- Now get the resp on the correct table:
				SELECT Response into resp FROM tdevnetdeviceresponse WHERE TDevice_Number = _DevNumber and Position = RemPos and MobileID = _MobileID;
				set _result = FOUND_ROWS();-- ROW_COUNT();
                -- Chek if it found any register:
                if (_result = 1) then
					-- Mark the removed elements with '-1':
					UPDATE tdevnetdeviceresponse
					SET Response='-1'
					WHERE TDevice_Number=_DevNumber and Position=RemPos;
                    
					-- Now add the remove pointer and the actual size:
					set RemPos = RemPos + 1;
					set sz = sz - 1;
					-- Check if the remove point must be cleared:
					if (RemPos >= @MazSize) then
						set RemPos = 0;
					end if;
					-- Now updata the control data table:
					UPDATE tdevnetdeviceresponsectrl
					SET InsertPosition=insPos, Size=sz, RemovePosition=RemPos 
					WHERE TDevice_Number=_DevNumber;
					set _result = ROW_COUNT();
					-- Verify if has any result:
					if (_result = 1) then
						select resp; -- This select returns the resp string to be used!
                        set _OutCmd = resp;
                        set _result = 1; -- Reult: Every things went fine!
					else
						set _result = -11; -- error!
					end if;
				else
					set _result = -21; -- nothing to remove! The Response probaly is not to this mobile ID!
                end if;
            end if;
		else
			set _result = -10; -- error!
        end if;
    else
		set _result = -1; -- Login incorrect(Number or Password worng)
    end if;
    
    -- If the response is not ok, so we select the result to avoid problens on the client side:
    -- if (_result<>1) then
	-- 	SELECT _result;
    -- end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SpDevNetPutCmd` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpDevNetPutCmd`(in _DevNumber varchar(25), in _email varchar(30), in _cmd varchar(100), in _MobileID varchar(20), out _result int)
BEGIN
-- LEAVE sp_break_label;

-- DECLARE MazSize int;

DECLARE insPos int;	
DECLARE sz int;
DECLARE RemPos int;	
SET @MazSize = 5; -- Constant variable.
    
    -- Verify if there are numeber and email information correctly:
	SELECT tdevice.OID FROM tdevice
	INNER JOIN tuserdevice ON tuserdevice.TDevice_OID = tdevice.OID -- This line select all registers.
	INNER JOIN tuser ON tuser.OID = tuserdevice.TUser_OID -- This line select all registers.
	where tuser.Email=_email and tdevice.Number=_DevNumber; -- This line select one specif user devices.

    set _result = FOUND_ROWS();
	if (_result=1) then
    -- if exists (SELECT Number, pwd FROM tdevice WHERE Number = _DevNumber and pwd = _pwd) then
		-- Get some control data in data base:
        SELECT InsertPosition, Size, RemovePosition into insPos, sz, RemPos FROM tdevnetdevicecmdctrl WHERE TDevice_Number = _DevNumber;
        set _result = FOUND_ROWS();-- ROW_COUNT();
        -- Verify if has any result:
        if (_result = 1) then
			-- Check if the queue is full:
            if (sz >= @MazSize) then
				-- So get empty:
                set sz = 0;
                set insPos = 0;
                set RemPos = 0;
                -- Mark all elements with '-1':
                UPDATE tdevnetdevicecmd
				SET Cmd='-1', MobileID='-1'
				WHERE TDevice_Number=_DevNumber;
            end if;
            -- So Add then command to DB(updata on really):
            UPDATE tdevnetdevicecmd
			SET Cmd=_cmd, MobileID=_MobileID
			WHERE TDevice_Number=_DevNumber and Position=insPos;
            -- Now add the insert pointer and teh actual size:
            set insPos = insPos + 1;
            set sz = sz + 1;
            -- Check if the insert point must be cleared:
            if (insPos >= @MazSize) then
				set insPos = 0;
            end if;
            -- Now updata the control data table:
            UPDATE tdevnetdevicecmdctrl
			SET InsertPosition=insPos, Size=sz, RemovePosition=RemPos 
			WHERE TDevice_Number=_DevNumber;
            set _result = ROW_COUNT();
            -- Verify if has any result:
			if (_result <> 1) then
				set _result = -11; -- error!
            end if;
		else
			set _result = -10; -- error!
        end if;
    else
		set _result = -1; -- Login incorrect(Number or Password worng)
    end if;
    
    SELECT _result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SpDevNetPutResponse` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpDevNetPutResponse`(in _DevNumber varchar(25), /*in _email varchar(30), */in _resp varchar(100), in _MobileID varchar(20), out _result int)
BEGIN
-- LEAVE sp_break_label;

-- DECLARE MazSize int;

DECLARE insPos int;	
DECLARE sz int;
DECLARE RemPos int;	
SET @MazSize = 5; -- Constant variable.
    
    -- Verify if there are numeber and email information correctly:
	SELECT tdevice.OID FROM tdevice
	INNER JOIN tuserdevice ON tuserdevice.TDevice_OID = tdevice.OID -- This line select all registers.
	INNER JOIN tuser ON tuser.OID = tuserdevice.TUser_OID -- This line select all registers.
	where /*tuser.Email=_email and */tdevice.Number=_DevNumber; -- This line select one specif user devices.

    set _result = FOUND_ROWS();
	if (_result=1) then
    -- if exists (SELECT Number, pwd FROM tdevice WHERE Number = _DevNumber and pwd = _pwd) then
		-- Get some control data in data base:
        SELECT InsertPosition, Size, RemovePosition into insPos, sz, RemPos FROM tdevnetdeviceresponsectrl WHERE TDevice_Number = _DevNumber;
        set _result = FOUND_ROWS();-- ROW_COUNT();
        -- Verify if has any result:
        if (_result = 1) then
			-- Check if the queue is full:
            if (sz >= @MazSize) then
				-- So get empty:
                set sz = 0;
                set insPos = 0;
                set RemPos = 0;
                -- Mark all elements with '-1':
                UPDATE tdevnetdeviceresponse
				SET Response='-1', MobileID='-1'
				WHERE TDevice_Number=_DevNumber;
            end if;
            -- So Add then command to DB(updata on really):
            UPDATE tdevnetdeviceresponse
			SET Response=_resp, MobileID=_MobileID
			WHERE TDevice_Number=_DevNumber and Position=insPos;
            -- Now add the insert pointer and teh actual size:
            set insPos = insPos + 1;
            set sz = sz + 1;
            -- Check if the insert point must be cleared:
            if (insPos >= @MazSize) then
				set insPos = 0;
            end if;
            -- Now updata the control data table:
            UPDATE tdevnetdeviceresponsectrl
			SET InsertPosition=insPos, Size=sz, RemovePosition=RemPos 
			WHERE TDevice_Number=_DevNumber;
            set _result = ROW_COUNT();
            -- Verify if has any result:
			if (_result <> 1) then
				set _result = -11; -- error!
            end if;
		else
			set _result = -10; -- error!
        end if;
    else
		set _result = -1; -- Login incorrect(Number or Password worng)
    end if;
    
        -- If the response is not ok, so we select the result to avoid problens on the client side:
    if (_result<>1) then
		SELECT _result;
    end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SpDevToDBLog` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpDevToDBLog`(in _DevNumber varchar(25), in _MobID varchar(30), in _MsgOID int, in _Args varchar(200), out _result int)
BEGIN
-- DECLARE insPos int;	
-- DECLARE sz int;
SET @OID = 0;
    
    
	SELECT tdevice.OID into @OID FROM tdevice
	where tdevice.Number=_DevNumber;
    set _result = FOUND_ROWS();
    
    SELECT tdevtodblogmsg.OID FROM tdevtodblogmsg
	where tdevtodblogmsg.OID=_MsgOID;
	set _result = _result + FOUND_ROWS();
    
	if (_result=2) then
		insert ignore into tdevtodblog (TDevToDBLogMsgOID, MobID, Args, DeviceOID) values ( _MsgOID, _MobID, _Args,@OID);
        
        set _result = ROW_COUNT();
        if (_result=1) then
			set _result = 1; 
		else
			set _result = -10; 
        end if;
        
    else
		set _result = -1;
    end if;
    
    SELECT _result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SpEditUserPwd` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpEditUserPwd`(in _email varchar(30), in _newpwd varchar(30), in _oldpwd varchar(30), out _result int)
BEGIN

	if exists (SELECT Email FROM tuser WHERE Email = _email and Pwd=MD5(_oldpwd)) then
    
		UPDATE tuser
		SET Pwd=MD5(_newpwd )
		WHERE Email=_email;
		set _result = ROW_COUNT();
        
        if (_result=1) then
			set _result = 1;
            select _newpwd; -- Return(select) the new pwd!
		else
			set _result = -20; -- Any updata error!
        end if;
	else
		set _result = -10; -- Login information wrong(pwd or email)!
    end if;
    select _email;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SpShareDevice` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpShareDevice`(in _UserEmail varchar(30), _Number varchar(25), in _rights int(1), out _result int)
BEGIN

DECLARE devOID int;
DECLARE userOID int;

	-- First verify if the user exist:
    SELECT OID into userOID FROM tuser WHERE Email = _UserEmail;
    set _result = FOUND_ROWS();
    
    -- First verify if the device exist:
    SELECT OID into devOID FROM tdevice WHERE Number = _Number;
    set _result = _result + FOUND_ROWS();
    
	if (_result=2) then
    
		select TUser_OID from tuserdevice where TUser_OID=userOID and TDevice_OID=@devOID;
		set _result = FOUND_ROWS();
		if (_result=1) then
			-- The relationalship already exist:
			set _result = -50; -- The relationalship already exist
		else
			-- Now Creat an register at relationalship table 'TUserDevice':
			insert ignore into tuserdevice (TUser_OID, TDevice_OID, TUserRoom_Name, UserRights) VALUES (userOID, devOID, "Desconhecido", _rights);
			set _result = ROW_COUNT();
			if (_result=1) then
				set _result = 1;
			else
				set _result = -40; -- The relationalship could not be created!
			end if;
		end if;
        
	else
		set _result = -10; -- user doesn't exist!
    end if;
    select _Number;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SpUpDataDevice` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpUpDataDevice`(_email varchar(30), _roomName varchar(30), _Number varchar(25), in _Name varchar(30), in _desactvated int(1), in _StaName varchar(30),  in _StaPwd varchar(30), in _ApName varchar(30), in _ApPwd varchar(30), in _StaIP varchar(15), in _MQTTHost varchar(45), in _MQTTPort int(1), in _MQTTClientID varchar(45), in _MQTTPath varchar(30), in _MQTTUser varchar(30), in _MQTTUserPwd varchar(30), in _MQTTTimeOut int(1), in _MQTTQoS int(1), in _MQTTType varchar(10), out _result int)
BEGIN
-- TODO: Essa função tem um erro que precisa ser corrigido: Se a sala não existe entao um erro ocorre!!
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	  BEGIN
		ROLLBACK;
		set _result = -31;
        SELECT 'Error occured';
	  END;
    
		
    -- First updating the 'tuserdevice' check if the room exists:
    -- SELECT tuserroom.Name FROM tuserroom
	-- INNER JOIN tuser ON tuserroom.TUser_OID = tuser.OID
    -- INNER JOIN tuserdevice ON tuserdevice.TUserRoom_Name = tuserroom.Name
    -- INNER JOIN tdevice ON tuserdevice.TDevice_OID = tdevice.OID
	-- WHERE tuserroom.Name = _roomName;
    -- set @res2 = ROW_COUNT();
    -- if (@res2=1) then
		-- Update the UserDeviceRoom table:
		UPDATE IGNORE tuserdevice
		INNER JOIN tuser ON tuserdevice.TUser_OID = tuser.OID
		INNER JOIN tdevice ON tuserdevice.TDevice_OID = tdevice.OID
		SET tuserdevice.TUserRoom_Name=_roomName
		WHERE tuser.Email = _email and tdevice.Number = _Number;
		set @res2 = ROW_COUNT();
        
		IF (_result=-15) THEN
            ROLLBACK;
        ELSE
            COMMIT;
        END IF;
    -- end if;
    
    -- Update the tmod1details:
    -- UPDATE IGNORE tmod1details
	-- INNER JOIN tdevice ON tmod1details.TDevice_OID = tdevice.OID
	-- SET tmod1details.StaName=_StaName, tmod1details.StaPwd=_StaPwd, tmod1details.ApName=_ApName, tmod1details.ApPwd=_ApPwd, tmod1details.StaIP=_StaIP, tmod1details.MQTTHost=_MQTTHost, tmod1details.MQTTPort=_MQTTPort, tmod1details.MQTTClientID=_MQTTClientID, tmod1details.MQTTPath=_MQTTPath, tmod1details.MQTTUser=_MQTTUser, tmod1details.MQTTUserPwd=_MQTTUserPwd, tmod1details.MQTTTimeOut=_MQTTTimeOut, tmod1details.MQTTQoS=_MQTTQoS, tmod1details.MQTTType=_MQTTType
	-- WHERE tdevice. Number = _Number;
	-- set @res1 = ROW_COUNT();
    
    -- Update the device:
    UPDATE IGNORE tdevice
	SET Name=_Name, Desactvated=_desactvated, MQTTHost=_MQTTHost, MQTTPort=_MQTTPort, MQTTClientID=_MQTTClientID, MQTTPath=_MQTTPath, MQTTUser=_MQTTUser, MQTTUserPwd=_MQTTUserPwd, MQTTTimeOut=_MQTTTimeOut, MQTTQoS=_MQTTQoS, MQTTType=_MQTTType
	WHERE Number=_Number;
	set _result = ROW_COUNT();
    
	if (_result=1 or @res2=1) then -- if (_result=1 or @res1=1 or @res2=1) then
		set _result = 1;
	else
		set _result = -10; -- No device actualized!
    end if;
    select _Number;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SpUpDataModule` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpUpDataModule`(in _email varchar(30), in _number varchar(25),  in _position int(1), in _name varchar(30), in _desactvated TINYINT(1), in _favorite TINYINT(1), out _result int)
BEGIN
	
	UPDATE IGNORE tdevicemodule
	INNER JOIN tdevice ON tdevicemodule.TDevice_OID = tdevice.OID
	INNER JOIN tuserdevice ON tuserdevice.TDevice_OID = tdevice.OID
	INNER JOIN tuser ON tuserdevice.TUser_OID = tuser.OID
	SET tdevicemodule.Name=_name, tdevicemodule.Favorite=_favorite, tdevicemodule.Desactvated=_desactvated
	WHERE tdevice.Number = _number and tdevicemodule.Position=_position and tuser.Email=_email;
	set _result = ROW_COUNT();
        
    
	if (_result=1) then
		set _result = 1;
	else
		set _result = -10; -- No device actualized!
    end if;
    select _Number;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SpUpDataUserRoom` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpUpDataUserRoom`(in _email varchar(30), in _roomName varchar(30), in _oldRoomName varchar(30), in _RoomType varchar(20), out _result int)
BEGIN

    UPDATE tuserroom
	INNER JOIN tuser ON tuserroom.TUser_OID = tuser.OID
	SET tuserroom.Name=_roomName, tuserroom.RoomType = _RoomType
	WHERE tuserroom.Name = _oldRoomName and tuser.Email = _email;
	set _result = ROW_COUNT();
    
	
    
	if (_result=1) then
		set _result = 1;
	else
		set _result = -10; -- No device actualized!
    end if;
    select _roomName;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SpUserAdd` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpUserAdd`(in _email varchar(30), in _pwd char(32), out _result int)
BEGIN

	if not exists (SELECT Email FROM tuser WHERE Email = _email) then
		insert into tuser (Email, Pwd, SessionCode) values ( _email, MD5(_pwd), MD5(RAND()));
        set _result = ROW_COUNT();
        if (_result=1) then
			CALL `hsdata_db`.`SpUserRoomAdd`(_email, 'Desconhecido', 'Nenhum', @res);
			set _result = 1;
		else
			set _result = -20; -- Any insert error!
        end if;
	else
		set _result = -10; -- Impossible to add. User already exists!
    end if;
    -- select _email;
    SELECT SessionCode FROM tuser WHERE Email = _email;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SpUserIsLoggedIn` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpUserIsLoggedIn`(in _email varchar(30), in _sessionCode char(32), out _result int)
BEGIN

	if exists(SELECT SessionCode FROM tuser WHERE Email = _email and SessionCode=_sessionCode) then
		set _result = 1; -- User authenticated correctly!
		-- select _sessionCode;
        SELECT SessionCode FROM tuser WHERE Email = _email and SessionCode=_sessionCode;
	else
		set _result = -10; -- Wrong user Authentication!
        select _sessionCode;
    end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SpUserLogin` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpUserLogin`(in _email varchar(30), in _pwd char(32), out _result int)
BEGIN
    SELECT SessionCode into @_sessionCode FROM tuser WHERE Email = _email and Pwd=MD5(_pwd);
    set _result = FOUND_ROWS();
	if (_result = 1) then
		if (@_sessionCode = "-1") then
			set @_rand=MD5(RAND());
			UPDATE tuser
			SET SessionCode=@_rand 
			WHERE Email=_email;
			set _result = ROW_COUNT();
			select @_rand;
		else
			set _result = 1; -- User authenticated correctly!
			select @_sessionCode;
        end if;
	else
		set _result = -10; -- Wrong user Authentication!
        set @_sessionCode = "-1";
        select @_sessionCode;
    end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SpUserLogoutAll` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpUserLogoutAll`(in _email varchar(30), in _SessionCode char(32), out _result int)
BEGIN
	UPDATE tuser
	SET SessionCode="-1" 
	WHERE Email=_email and SessionCode=_SessionCode;
	set _result = ROW_COUNT();
	if (_result = 1) then
		set _result = 1;
	else
		set _result = -10; -- Wrong user Authentication!
    end if;
    select _email;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SpUserRoomAdd` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpUserRoomAdd`(in _email varchar(30), in _roomName varchar(30), in _RoomType varchar(20),out _result int)
BEGIN
	
	if exists (SELECT Email FROM tuser WHERE Email = _email) then
        
        select OID into @userOID from tuser where Email=_email;
        set _result = FOUND_ROWS();
        if (_result=1) then
			insert ignore into tuserroom (Name, TUser_OID, RoomType) values ( _roomName, @userOID, _RoomType);
            set _result = ROW_COUNT();
			if (_result=1) then
				set _result = 1;
			else
				set _result = -30; -- Any insert error!
			end if;
            
		else
			set _result = -20;
        end if;
        
	else
		set _result = -10; -- User doesn't exist
    end if;
    -- select _email;
    SELECT _roomName;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `StDeleteDevice` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `StDeleteDevice`(in _email varchar(30), in _number varchar(25), out _result int)
BEGIN

	SELECT tdevice.OID into @devOID FROM tdevice
	INNER JOIN tuserdevice ON tuserdevice.TDevice_OID = tdevice.OID -- This line select all registers.
	INNER JOIN tuser ON tuser.OID = tuserdevice.TUser_OID -- This line select all registers.
	where tuser.Email=_email and tdevice.Number=_number; -- This line select one specif user devices.

    set _result = FOUND_ROWS();
	if (_result=1) then
		DELETE FROM tdevice WHERE OID=@devOID;
        select _number;
		set _result = 1;
	else
		select _result;
		set _result = -1;
    end if;
    -- select _result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `StDeleteUserRoom` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `StDeleteUserRoom`(in _email varchar(30), in _name varchar(25), out _result int)
BEGIN

	SELECT tuser.OID into @userOID FROM tuser
	where tuser.Email=_email;
    set _result = FOUND_ROWS();
	if (_result=1) then
		-- Now verify if there is any relationaship with this user, in positive case shot/throw an error!
		SELECT tuserdevice.TUser_OID FROM tuserdevice
		where tuserdevice.TUser_OID=@userOID and tuserdevice.TUserRoom_Name=_name;
		set _result = FOUND_ROWS();
        if (_result=1) then
			set _result = -55;
        else    
			DELETE FROM tuserroom WHERE TUser_OID=@userOID and Name=_name;
			set _result = ROW_COUNT();
			if (_result=1) then
				set _result = 1;
			else
				set _result = -10; -- No device actualized!
			end if;
        end if;
	else
		select _result;
		set _result = -1;
    end if;
    select _name;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `StReturnDeviceList` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `StReturnDeviceList`(in _email varchar(30), out _result int)
BEGIN

	SELECT tdevice.*, tdeviceversion.*, tuserdevice.TUserRoom_Name, tuserdevice.UserRights/*, tmod1details.**/ FROM tdevice
    INNER JOIN tdeviceversion ON tdeviceversion.OID = tdevice.TDeviceVersion_OID
	INNER JOIN tuserdevice ON tuserdevice.TDevice_OID = tdevice.OID -- This line select all registers.
	INNER JOIN tuser ON tuser.OID = tuserdevice.TUser_OID -- This line select all registers.
    -- INNER JOIN tmod1details ON tmod1details.TDevice_OID = tdevice.OID -- This line select all registers.
	where tuser.Email=_email; -- This line select one specif user devices.

    set _result = FOUND_ROWS();
	if (_result<>0) then
		set _result = 1;
	else
		set _result = -1;
    end if;
    -- select _result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `StReturnDeviceListDetail` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `StReturnDeviceListDetail`(in _email varchar(30), out _result int)
BEGIN

	SELECT /*tdevice.*, tdeviceversion.*, */tmod1details.*, tdevice.Number FROM tdevice
    -- INNER JOIN tdeviceversion ON tdeviceversion.OID = tdevice.TDeviceVersion_OID
	INNER JOIN tuserdevice ON tuserdevice.TDevice_OID = tdevice.OID -- This line select all registers.
	INNER JOIN tuser ON tuser.OID = tuserdevice.TUser_OID -- This line select all registers.
    INNER JOIN tmod1details ON tmod1details.TDevice_OID = tdevice.OID -- This line select all registers.
	where tuser.Email=_email; -- This line select one specif user devices.

    set _result = FOUND_ROWS();
	if (_result<>0) then
		set _result = 1;
	else
		set _result = -1;
    end if;
    -- select _result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `StReturnModuleList` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `StReturnModuleList`(in _email varchar(30), out _result int)
BEGIN

	SELECT tdevicemodule.*, tdevice.Number FROM tdevicemodule
    INNER JOIN tdevice ON tdevice.OID = tdevicemodule.TDevice_OID
	INNER JOIN tuserdevice ON tuserdevice.TDevice_OID = tdevicemodule.TDevice_OID -- This line select all registers.
	INNER JOIN tuser ON tuser.OID = tuserdevice.TUser_OID -- This line select all registers.
	where tuser.Email=_email; -- This line select one specif user devices..

    set _result = FOUND_ROWS();
	if (_result<>0) then
		set _result = 1;
	else
		set _result = -1;
    end if;
    -- select _result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `StReturnUserRoomList` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `StReturnUserRoomList`(in _email varchar(30), out _result int)
BEGIN

	SELECT tuserroom.Name, tuserroom.RoomType FROM tuserroom
    INNER JOIN tuser ON tuser.OID = tuserroom.TUser_OID
	where tuser.Email=_email;

    set _result = FOUND_ROWS();
	if (_result<>0) then
		set _result = 1;
	else
		set _result = -1;
    end if;
    -- select _result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-10-24  1:52:52
