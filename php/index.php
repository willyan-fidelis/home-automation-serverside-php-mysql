<html lang="pt-br">
	<head>
		<meta charset="utf-8">
		<title>AJAX, JSON E PHP</title>
        	<script src="//code.jquery.com/jquery-1.11.2.min.js"></script>
			<script src= "http://ajax.googleapis.com/ajax/libs/angularjs/1.3.14/angular.min.js"></script>
        	
			<script src="ajax.js"></script>
	</head>
	<body>
	
		<p>Please open the console/debug to see data!</p>
		
		<?php
			echo "Hello Word!";
		?>
	
	<script>
	var app = angular.module('myApp', []);
	app.controller('myCtrl', function($scope) {
		//$scope.myList={ nome: "2", sobreNome: "Silva", cidade: "eee" };
		
	});
	</script>



	</body>
</html