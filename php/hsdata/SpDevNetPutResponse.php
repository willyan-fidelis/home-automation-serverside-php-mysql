<?php
require_once('../class/BTF_DtExg.php');

//URL instance(exemple):
//http://localhost/hsn_db/php/hsdata/SpDevNetPutResponse.php/?number=ChipID:12345&resp=cmd-1212&mobileid=MobileID=1990

//Get arrived data here:
//$data = $_POST;
$data = $_GET;

//Create a data base conection:
$DataExchange = new BackToFrontEndDtExg("localhost", "root", "myroot", "hsdata_db"); //$DBServerName, $DBUserName, $DBUserPwd, $DBName
//Call the data base stored procedure(check if is logged-in):
//$sp_result = $DataExchange->ExecuteSPWithDataSet(false, "SpUserIsLoggedIn", array("Email"), array("s", "s", "i"), array("InParm", "session", "Result"), array($data["email"], $data["session"], 0), array("Result"));

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
	$sp_result = $DataExchange->ExecuteSPWithDataSet(true, "SpDevNetPutResponse", array("Response"), array("s", "s", "s", "i"), array("Number", "Resp", "MobileID", "Result"), array($data["number"], $data["resp"], $data["mobileid"], 0), array("Result"));
}
else
{
	echo json_encode(array("Parameters"=>array("Result"=>"-100")));
	echo "Fail!";
}
//------------------------------------------------------
/*
$subject= "Olá!"; // Assunto.
$to= "willyan_fidelis@hotmail.com"; // Para.
$body= "Esse é o meu demo para ver se a função mail utilizando sendmail do PHP no XAMPP versão 1.7.3 funciona"; // corpo do texto.
if (mail($to,$subject,$body, "From: willyan.sergio.fidelis@gmail.com"))
echo "e-mail enviado com sucesso!";
else
echo "e-mail não enviado!"; 
*/
?>