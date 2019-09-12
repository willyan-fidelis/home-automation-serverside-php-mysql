<?php
require_once('../class/BTF_DtExg.php');

//URL instance(exemple):
//http://localhost/hsn_db/php/hsdata/SpUpDataModule.php/?email=teste@gmail&session=ab1e50d6b7c55eb310def1b27022706d&numb=20161220.001.16668185&pos=1&nm=Luz5&fav=0&des=0

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
	$sp_result = $DataExchange->ExecuteSPWithDataSet(true, "SpUpDataModule", array("Number"), array("s", "s", "i", "s", "i", "i", "i"), array("Email", "Number", "Position", "Name", "Desactive", "Favorite", "Result"), array($data["email"], $data["numb"], $data["pos"], $data["nm"], $data["des"], $data["fav"], 0), array("Result"));
}
else
{
	echo json_encode(array("Parameters"=>array("Result"=>"-100")));
	echo "Fail!";
}
//------------------------------------------------------
?>