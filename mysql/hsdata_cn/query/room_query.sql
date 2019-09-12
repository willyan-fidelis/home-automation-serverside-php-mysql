CALL `hsdata_db`.`SpUserRoomAdd`('teste@gmail', 'Cozinha', 'room', @res);
select @res;

CALL `hsdata_db`.`SpUpDataUserRoom`('teste@gmail', 'Cozinha', 'Quarto10', 'room', @res);
select @res;

CALL `hsdata_db`.`StDeleteUserRoom`('teste@gmail', 'Cozinha', @res);
select @res;

CALL `hsdata_db`.`StReturnUserRoomList`('teste@gmail', @res);
select @res;
