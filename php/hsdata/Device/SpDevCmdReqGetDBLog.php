<?php
require_once('../../class/BTF_DtExg.php');

//URL instance(exemple):
//http://localhost/hsn_db/php/hsdata/Device/SpDevCmdReqGetDBLog.php/?DevNumber=20161220.001.16668185

//Get arrived data here:
//$data = $_POST;
$data = $_GET;

//Create a data base conection:
$DataExchange = new BackToFrontEndDtExg("localhost", "root", "", "hsdata_db"); //$DBServerName, $DBUserName, $DBUserPwd, $DBName
//Call the data base stored procedure(check if is logged-in):
//$sp_result = $DataExchange->ExecuteSPWithDataSet(false, "SpUserIsLoggedIn", array("Email"), array("s", "s", "i"), array("InParm", "session", "Result"), array($data["email"], $data["session"], 0), array("Result"));

//------------------------------------------------------
//Get the 'Parameters' that have the 'Result' tag:
//$sp_result=$sp_result["Parameters"];
//The 'echo' and the 'var_dump' is only for debug:
//echo $sp_result["Result"];
//var_dump($sp_result["Result"]);
//Now evaluate the result:
if (true) //if ($sp_result["Result"] == 1)
{
	//Call the data base stored procedure:
	$sp_result = $DataExchange->ExecuteSPWithDataSet(false, "SpDevCmdReqGetDBLog", array("MobID", "Cmd"), array("s", "i"), array("DevNumber", "Result"), array($data["DevNumber"], 0), array("Result"));
	//Prepare to send the information to the ESP8266:
	$ResultList=$sp_result["Results"];
	$ResultList=json_encode($ResultList);
	$sp_result=$sp_result["Parameters"];
	
	//$esp_data = array("sz"=>$sp_result["cmdsize"], "mobID"=>$sp_result["OutMobiliID"]);
	//$esp_data = json_encode($esp_data);
	echo 'xxx/?{"Result":' .  $sp_result["Result"] . ',"CmdList":' . $ResultList . '}?/';
}
else
{
	echo json_encode(array("Parameters"=>array("Result"=>"-100")));
	echo "Fail!";
}
//------------------------------------------------------
?>