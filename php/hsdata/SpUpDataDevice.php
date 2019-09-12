<?php
require_once('../class/BTF_DtExg.php');

//URL instance(exemple):
//http://localhost/hsn_db/php/hsdata/SpUpDataDevice.php/?email=teste@gmail&session=73971094557b6cfb78e80dea96b34581&room=Desconhecido&number=20161220.001.16668185&name=MeuPrimeiroDevice&desact=0&staname=staname&stapwd=stapwd&apname=apname&appwd=appwd&staip=staip&devType=1&MQTTHost=broker.mqttdashboard.com&MQTTPort=1883&MQTTSSL=0&MQTTPath=none&MQTTUser=none&MQTTUserPwd=none&MQTTClearS=5&MQTTQoS=1&MQTTType=ws

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
	if($data["devType"] == 1) //Check what type must be added
	{
		//Call the data base stored procedure:
		$sp_result = $DataExchange->ExecuteSPWithDataSet(true, "SpUpDataDevice", array("Result"), array("s", "s", "s", "s", "i", "s", "s", "s", "s", "s", "i"), array("Email", "Room", "Number", "Name", "Desactvated", "StaName", "StaPwd", "ApName", "ApPwd",  "StaIP", "Result"), array($data["email"], $data["room"], $data["number"], $data["name"], $data["desact"], $data["staname"], $data["stapwd"], $data["apname"], $data["appwd"], $data["staip"], 0), array("Result"));

	}
}
else
{
	echo json_encode(array("Parameters"=>array("Result"=>"-100")));
	echo "Fail!";
}
//------------------------------------------------------
?>