CREATE DATABASE `hsdata_db` /*!40100 DEFAULT CHARACTER SET utf8 */;
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

CREATE TABLE `tdeviceversion` (
  `OID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Type` varchar(4) NOT NULL,
  `SwVersion` varchar(4) NOT NULL,
  `HwVersion` varchar(4) NOT NULL,
  PRIMARY KEY (`OID`),
  UNIQUE KEY `OID_UNIQUE` (`OID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

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

CREATE TABLE `tdevtodblogmsg` (
  `OID` int(1) unsigned NOT NULL AUTO_INCREMENT,
  `Msg` varchar(200) NOT NULL,
  PRIMARY KEY (`OID`),
  UNIQUE KEY `OID_UNIQUE` (`OID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='TDevToDBLogMsg - (Table) Device To Data Base Log Messages';

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
