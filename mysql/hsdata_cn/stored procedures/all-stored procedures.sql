DELIMITER $$
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
END$$
DELIMITER ;

DELIMITER $$
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
END$$
DELIMITER ;

DELIMITER $$
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
END$$
DELIMITER ;

DELIMITER $$
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
END$$
DELIMITER ;

DELIMITER $$
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
END$$
DELIMITER ;

DELIMITER $$
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
END$$
DELIMITER ;

DELIMITER $$
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
END$$
DELIMITER ;

DELIMITER $$
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
END$$
DELIMITER ;

DELIMITER $$
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
END$$
DELIMITER ;

DELIMITER $$
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
END$$
DELIMITER ;

DELIMITER $$
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
END$$
DELIMITER ;

DELIMITER $$
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
END$$
DELIMITER ;

DELIMITER $$
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
END$$
DELIMITER ;

DELIMITER $$
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
END$$
DELIMITER ;

DELIMITER $$
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
END$$
DELIMITER ;

DELIMITER $$
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
END$$
DELIMITER ;

DELIMITER $$
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
END$$
DELIMITER ;

DELIMITER $$
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
END$$
DELIMITER ;

DELIMITER $$
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
END$$
DELIMITER ;

DELIMITER $$
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
END$$
DELIMITER ;

DELIMITER $$
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
END$$
DELIMITER ;

DELIMITER $$
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
    
END$$
DELIMITER ;

DELIMITER $$
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
END$$
DELIMITER ;

DELIMITER $$
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
END$$
DELIMITER ;

DELIMITER $$
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
END$$
DELIMITER ;

DELIMITER $$
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
END$$
DELIMITER ;
