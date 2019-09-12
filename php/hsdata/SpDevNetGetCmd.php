<?php
require_once('../class/BTF_DtExg.php');

//URL instance(exemple):
//http://localhost/hsn_db/php/hsdata/SpDevNetGetCmd.php/?number=ChipID:12345

//Get arrived data here:
//$data = $_POST;
$data = $_GET;

//Create a data base conection:
$DataExchange = new BackToFrontEndDtExg("localhost", "root", "myroot", "hsdata_db"); //$DBServerName, $DBUserName, $DBUserPwd, $DBName
//Call the data base stored procedure(check if is logged-in):
//$sp_result = $DataExchange->ExecuteSPWithDataSet(false, "SpUserAuthenticated", array("Email"), array("s", "s", "i"), array("InParm", "pwd", "Result"), array($data["email"], $data["pwd"], 0), array("Result"));

//------------------------------------------------------
//Get the 'Parameters' that have the 'Result' tag:
//$sp_result=$sp_result["Parameters"];
//The 'echo' and the 'var_dump' is only for debug:
//echo $sp_result["Result"];
//var_dump($sp_result["Result"]);
//Now evaluate the result:
if (true)//($sp_result["Result"] == 1)
{
	//Call the data base stored procedure:
	$sp_result = $DataExchange->ExecuteSPWithDataSet(false, "SpDevNetGetCmd", array("Cmd"), array("s", "s", "s", "i", "i"), array("Number", "OutCmd", "OutMobiliID", "cmdsize", "Result"), array($data["number"],"", "", 0, 0), array("OutCmd", "OutMobiliID", "cmdsize", "Result"));
	//Prepare to send the information to the ESP8266:
	$sp_result=$sp_result["Parameters"];
	//echo "/size/!" . $sp_result["cmdsize"] . "/" . $sp_result["OutMobiliID"] . $sp_result["OutCmd"];	
	
	
	$esp_data = array("sz"=>$sp_result["cmdsize"], "mobID"=>$sp_result["OutMobiliID"]);
	$esp_data = json_encode($esp_data);
	echo 'xxx/?{"ctrl":' .  $esp_data . ',"data":' . $sp_result["OutCmd"] . '}';
	//echo "/size/!" . "{" .$sp_result["cmdsize"] . $sp_result["OutMobiliID"] . $sp_result["OutCmd"];	
}
else
{
	echo json_encode(array("Parameters"=>array("Result"=>"-100")));
	echo "Fail!";
}
//------------------------------------------------------
?>