-- User Add
CALL `hsdata_db`.`SpUserAdd`("admin@admin", "123", @result);
select @result;

-- User edit Password:
CALL `hsdata_db`.`SpEditUserPwd`("teste@gmail", "123", "555", @result);
select @result;

-- User login:
CALL `hsdata_db`.`SpUserLogin`("teste@gmail", "123", @res);
select @res;

-- User logout:
CALL `hsdata_db`.`SpUserLogoutAll`("teste@gmail", "b023a117256b6c0149a675de6dadc6a4", @res);
select @res;

-- User is logged in?:
CALL `hsdata_db`.`SpUserIsLoggedIn`("teste@gmail", "202cb962ac59075b964b07152d234b70", @res);
select @res;
