<?php
require_once('../class/BTF_DtExg.php');

//URL instance(exemple):
//http://localhost/hsn_db/php/hsdata/SpUpDataUserRoom.php/?email=teste@gmail&session=95e1da2eaee0f330beeead69388a1947&room_name=Jardim&room_old_name=Jardim&RoomType=a

//Get arrived data here:
//$data = $_POST;
$data = $_GET;

//Create a data base conection:
$DataExchange = new BackToFrontEndDtExg("localhost", "root", "myroot", "hsdata_db"); //$DBServerName, $DBUserName, $DBUserPwd, $DBName
//Call the data base stored procedure(check if is logged-in):
$sp_result = $DataExchange->ExecuteSPWithDataSet(false, "SpUserIsLoggedIn", array("Email"), array("s", "s", "i"), array("InParm", "session", "Result"), array($data["email"], $data["session"], 0), array("Result"));

//------------------------------------------------------
//Get the 'Parameters' that have the 'Result' tag:
$sp_result=$sp_result["Parameters"];
//The 'echo' and the 'var_dump' is only for debug:
//echo $sp_result["Result"];
//var_dump($sp_result["Result"]);
//Now evaluate the result:
if ($sp_result["Result"] == 1)
{
	//Call the data base stored procedure:
	$sp_result = $DataExchange->ExecuteSPWithDataSet(true, "SpUpDataUserRoom", array("Email"), array("s", "s", "s", "s", "i"), array("Email", "Room", "OldRoom", "RoomType", "Result"), array($data["email"], $data["room_name"], $data["room_old_name"], $data["RoomType"], 0), array("Result"));
}
else
{
	echo json_encode(array("Parameters"=>array("Result"=>"-100")));
	echo "Fail!";
}
//------------------------------------------------------
?>