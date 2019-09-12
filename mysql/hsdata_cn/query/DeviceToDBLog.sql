-- Device Querys: ------------------------------------------------------------------------
set @res = 0;
CALL `hsdata_db`.`SpDevToDBLog`('20161220.001.16668185', "none", 2, 'no args', @res);
select @res;


set @res = 0;
CALL `hsdata_db`.`SpDevCmdReqGetDBLog`('20161220.001.16668185', @res);
select @res;

-- Mobile To Device Querys: --------------------------------------------------------------
set @res = 0;-- `SpDevCmdReqPutDBLog`( in _email varchar(30), in _DevNumber varchar(25), in _MobID varchar(30), in _Args int, in _Cmd varchar(200), out _result int)
CALL `hsdata_db`.`SpDevCmdReqPutDBLog`("teste@gmail",'20161220.001.16668185', "MobID8", 2, "{%22cmd.id%22:%22turn%22,%22cmd.m0%22:3,%22cmd.m1%22:3}", @res);
select @res;
-- INSERT INTO `hsdata_db`.`tdevcmdreqtodblog` (`Cmd`, `Args`, `DeviceOID`, `MobID`) VALUES ('{%22cmd.id%22:%22turn%22,%22cmd.m0%22:3,%22cmd.m1%22:3}', '1', '172', 85);
