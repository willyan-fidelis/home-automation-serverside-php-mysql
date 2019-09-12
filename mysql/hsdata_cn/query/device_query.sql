-- Create one device:
CALL `hsdata_db`.`SpCreateDevice`('Desconhecido',"1.0", "1.1", "1.2", "teste@gmail", "20161220.001.16668185", "Minha Primeira Placa", @res);--  "staname1", "stapwd1", "apname1", "appwd1","192.168.0.111", 
select @res;

-- Delete one divece from a list, if the relationalship user x device exists:
CALL `hsdata_db`.`StDeleteDevice`("teste@gmail", "20161220.001.16668185", @res);
select @res;

-- Alter one device:
CALL `hsdata_db`.`SpUpDataDevice`("teste@gmail", "Desconhecido", "20161220.001.16668185", "Minha Primeira Placa", 0, "staname2", "stapwd2", "apname2", "appwd2", "192.168.0.99", @res);
select @res;

-- Get Device List:
CALL `hsdata_db`.`StReturnDeviceList`("teste@gmail", @res);
-- select @res;

-- Get module list:
CALL `hsdata_db`.`StReturnModuleList`("teste@gmail", @res);
-- select @res;

-- Get module list Details:
CALL `hsdata_db`.`StReturnDeviceListDetail`("teste@gmail", @res);
-- select @res;

CALL `hsdata_db`.`SpUpDataModule`("teste@gmail", "20161220.001.16668185", 1,"Luz 1", 0, 0, @res);
select @res;

CALL `hsdata_db`.`SpShareDevice`("abc@gmail","teste@gmail", "20161220.001.16668185", 2, @result);
select @result;

CALL `hsdata_db`.`SpUnShareDevice`("abc@gmail","teste@gmail", "20161220.001.16668185", @result);
select @result;

CALL `hsdata_db`.`SpUnShareDevice`("-1","teste@gmail", "20161220.001.16668185", @result);
select @result,@res1,@res2,@res3;