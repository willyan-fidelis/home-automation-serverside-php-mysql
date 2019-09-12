<?php
require_once('../../class/BTF_DtExg.php');

//URL instance(exemple):
//http://localhost/hsn_db/php/hsdata/Device/SpDevCmdReqPutDBLog.php/?number=20161220.001.16668185&email=teste@gmail&session=ab1e50d6b7c55eb310def1b27022706d&cmd={%22cmd.id%22:%22turn%22,%22cmd.m0%22:3,%22cmd.m1%22:3}&mobileid=1990&args=5

//Get arrived data here:
//$data = $_POST;
$data = $_GET;

//Create a data base conection:
$DataExchange = new BackToFrontEndDtExg("localhost", "root", "", "hsdata_db"); //$DBServerName, $DBUserName, $DBUserPwd, $DBName
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
	$sp_result = $DataExchange->ExecuteSPWithDataSet(true, "SpDevCmdReqPutDBLog", array("Result"), array("s", "s", "s", "i", "s", "i"), array("Email", "Number", "MobileID", "Args", "Cmd", "Result"), array($data["email"], $data["number"], $data["mobileid"], $data["args"], $data["cmd"], 0), array("Result"));
}
else
{
	echo json_encode(array("Parameters"=>array("Result"=>"-100")));
	echo "Fail!";
}
//------------------------------------------------------
?>