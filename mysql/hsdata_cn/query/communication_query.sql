-- Get Response:
CALL `hsdata_db`.`SpDevNetGetResponse`("ChipID:12345", "abc@gmail", "MobileID=1990", @OutCmd, @result);
-- select @result
select @OutCmd;

-- Put response:
CALL `hsdata_db`.`SpDevNetPutResponse`("ChipID:12345", "resp=zzz", "MobileID=1990", @result);
select @result;

-- Get Command:
CALL `hsdata_db`.`SpDevNetGetCmd`("ChipID:12345",@cmd, @mobileID, @size, @_result);
-- select @_result;

-- Put Command:
CALL `hsdata_db`.`SpDevNetPutCmd`("20161220.001.16668185", "teste@gmail", "cmd=555", "MobileID=1985", @_result);
select @_result;
