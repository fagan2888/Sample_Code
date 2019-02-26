<?php
	// Don't Forget to exit after header!! otherwise will continue process!
	session_start();
	$res = isset($_GET['reset'])?$_GET['reset']:'';
	if ($res){
		header("Location: index.php?reserve_tool=2");
		exit();
	}else{
		try{
			$pdo = new PDO("mysql:dbname=Tools4Rent", "root", "root");
		}catch(PDOException $e){
			print $e->getMessage();
		}	
		$startdate = date("Y-m-d", $_SESSION['startdate']);
		$enddate = date("Y-m-d", $_SESSION['enddate']);
		$username = $_SESSION['login_user'];
		$query = "INSERT INTO Reservation(start_date, end_date, customer_username) VALUES(?,?,?)";
		$st = $pdo->prepare($query);
		$st->execute(array($startdate, $enddate, $username));
		$res_id = $pdo->lastInsertId();

		$array = $_SESSION['rental_tool'];
		$query = "INSERT INTO ReservationTool(reservation_id, tool_id) VALUES(?,?)";
		$st = $pdo->prepare($query);
		foreach ($array as $key => $value){
			$st->execute(array($res_id, $value));
		}

		header("Location: index.php?reserve_sum=1&res_id=".$res_id);
		exit();
	}
?>
