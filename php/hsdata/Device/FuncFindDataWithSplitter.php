<?php
    //$fullString = "abc*|*aa()?{}aaaa*|*dygfdygc*|*21125///+-*|*???abc???";
	//$fullString = "hhh*|*jjjj*|*kkkk*|*llllll*|*ppppp*|*sss*|*wwww*|*";//21125///+-
	//$fullString = "ddsdsd*|*";
	//$DivPattern = "*|*";
	//$LastInfoPattern = "???";
	
	function FuncFindDataWithSplitter($Pattern, $String) {
		//while (strlen($String) != 0) {
			//Find the 'Pattern' position mark:
			$Pos = strpos($String, $Pattern);
			//print $Pos . "|";
			
			//Find the first data:
			$dataString = substr($String, 0, $Pos);
			//print $dataString . "|";
			return array($Pos, $dataString);
		//}
	}

	
	
?>