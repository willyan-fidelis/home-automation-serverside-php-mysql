<?php
require_once('../class/BTF_DtExg.php');

//URL instance(exemple):
//http://localhost/hsn_db/php/hsdata/SpCreateDevice.php/?type=1.0&sw_ver=1.1&hw_ver=1.2&email=teste@gmail&number=ChipID:888&name=MeuPrimeiroDevice&session=95e1da2eaee0f330beeead69388a1947&staname=staname&stapwd=stapwd&apname=apname&appwd=appwd&staip=192.168.150.5&addType=1&MQTTHost=broker.mqttdashboard.com&MQTTPort=1883&MQTTClientID=0&MQTTPath=none&MQTTUser=none&MQTTUserPwd=none&MQTTTimeOut=5&MQTTQoS=1&MQTTType=ws

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
	if($data["addType"] == 1) //Check what type must be added
	{
		//Call the data base stored procedure:
		$sp_result = $DataExchange->ExecuteSPWithDataSet(true, "SpCreateDevice", array("Number"), array("s", "s", "s", "s", "s", "s", "s", "s", "i", "s", "s", "s", "s", "i", "i", "s", "i"), array("Room", "VersionType", "SwVersion", "HwVersion", "Email", "Number", "Name", "_MQTTHost", "_MQTTPort", "_MQTTClientID", "_MQTTPath", "_MQTTUser", "_MQTTUserPwd", "_MQTTTimeOut", "_MQTTQoS", "_MQTTType", "Result"), array("Desconhecido",$data["type"], $data["sw_ver"], $data["hw_ver"], $data["email"], $data["number"], $data["name"], $data["MQTTHost"], $data["MQTTPort"], $data["MQTTClientID"], $data["MQTTPath"], $data["MQTTUser"], $data["MQTTUserPwd"], $data["MQTTTimeOut"], $data["MQTTQoS"], $data["MQTTType"], 0), array("Result"));
	}
	else
	{
		echo json_encode(array("Parameters"=>array("Result"=>"-200")));
	}
}
else
{
	echo json_encode(array("Parameters"=>array("Result"=>"-100")));
	echo "Fail!";
}
//------------------------------------------------------
?>