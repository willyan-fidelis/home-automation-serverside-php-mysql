<?php
	require_once('/FuncFindDataWithSplitter.php');

    $fullString = "abc???xxx*|*aa()?{}aaaa*|*abc???abcdygfdygc*|*21125///+-*|*";
	$fullString = "5???xxx*|*6???aa()?{}aaaa*|*7???abcdygfdygc*|*8???21125///+-*|*";
	//$fullString = "hhh*|*jjjj*|*kkkk*|*llllll*|*ppppp*|*sss*|*wwww*|*";//21125///+-
	//$fullString = "ddsdsd*|*";
	$DivPattern = "*|*";
	$FirstInfoPattern = "???";

	
		
		while (strlen($fullString) != 0) {		
			//Find the 'MobID' field:
			list($foundPos, $_MobID) = FuncFindDataWithSplitter($FirstInfoPattern, $fullString);
			if($_MobID == "")
			{
				$fullString  = "";
			}
			else
			{
				//Refresh the 'fullString' string:
				print "MobID: " . $_MobID . "|";
				$fullString = substr($fullString, $foundPos + strlen($FirstInfoPattern), strlen($fullString));
				
				//Find the 'Command' field:
				list($foundPos, $cmdString) = FuncFindDataWithSplitter($DivPattern, $fullString);
				print "Cmd: " . $cmdString . "|";
				
				if($cmdString == "")
				{
					$fullString  = "";
				}
				else
				{
					$fullString = substr($fullString, $foundPos + strlen($DivPattern), strlen($fullString));
					//print $fullString . "|";
				}
			}
			
		}
	
	
?>