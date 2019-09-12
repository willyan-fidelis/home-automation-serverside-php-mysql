<?php
require_once('../../class/BTF_DtExg.php');
require_once('/FuncFindDataWithSplitter.php');

//URL instance(exemple):
//http://localhost/hsn_db/php/hsdata/Device/SpDevToDBLog.php/?DevNumber=20161220.001.16668185&MsgOID=3&_Args=NoArgs&MobID=1990

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
{	if ($data["MsgOID"] != 1)
	{
		//Call the data base stored procedure:
		$sp_result = $DataExchange->ExecuteSPWithDataSet(true, "SpDevToDBLog", array("Cmd"), array("s", "s", "i", "s", "i"), array("DevNumber", "MobID", "MsgOID", "_Args", "Result"), array($data["DevNumber"], $data["MobID"], $data["MsgOID"], $data["_Args"], 0), array("Result"));
	}
	else //Else case: The MsgOID is one(1), so it is a device response request. We must split all responses and save it on data base:
	{
		//$fullString = "abc*|*aa()?{}aaaa*|*dygfdygc*|*21125///+-*|*";
		//$fullString = "hhh*|*jjjj*|*kkkk*|*llllll*|*ppppp*|*sss*|*wwww*|*";//21125///+-
		$fullString = $data["_Args"];
		//$fullString = "777???" . $data["_Args"];
		$DivPattern = "*|*";
		$MobIDPattern = "???";
		
		
		
			
			while (strlen($fullString) != 0) {
				//Find the 'MobID' field:
				list($foundPos, $_MobID) = FuncFindDataWithSplitter($MobIDPattern, $fullString);
				if($_MobID == null or $_MobID == "")
				{
					//Refresh the 'fullString' string:
					$fullString  = "";
					//Error:
					echo json_encode(array("Parameters"=>array("Result"=>"-200")));
				}
				else
				{
					//Refresh the 'fullString' string:
					$fullString = substr($fullString, $foundPos + strlen($MobIDPattern), strlen($fullString));
					//print "mobile ID arrived: " . $_MobID . "|";
					
					//Find the 'Command' field:
					list($foundPos, $cmdString) = FuncFindDataWithSplitter($DivPattern, $fullString);
					if($cmdString == "")
					{
						//Refresh the 'fullString' string:
						$fullString  = "";
						//Error:
						echo json_encode(array("Parameters"=>array("Result"=>"-200")));
					}
					else
					{
						$fullString = substr($fullString, $foundPos + strlen($DivPattern), strlen($fullString));
						//Call the data base stored procedure:
						//$sp_result = $DataExchange->ExecuteSPWithDataSet(true, "SpDevToDBLog", array("Cmd"), array("s", "i", "s", "i"), array("DevNumber", "MsgOID", "_Args", "Result"), array($data["DevNumber"], $data["MsgOID"], $cmdString, 0), array("Result"));
						$sp_result = $DataExchange->ExecuteSPWithDataSet(true, "SpDevToDBLog", array("Cmd"), array("s", "s", "i", "s", "i"), array("DevNumber", "MobID", "MsgOID", "_Args", "Result"), array($data["DevNumber"], $_MobID, $data["MsgOID"], $cmdString, 0), array("Result"));
					}
				}
			}
		
	}
}
else
{
	echo json_encode(array("Parameters"=>array("Result"=>"-100")));
	echo "Fail!";
}
//------------------------------------------------------
?>