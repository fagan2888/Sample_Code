<?php
	session_start();
	$pdo = new PDO("mysql:dbname=Tools4Rent", "root", "root");
	$password  = htmlspecialchars($_POST['password']);
	$username = $_SESSION['login_user'];
	$data = date('Y-m-d');
	$st = $pdo->prepare("UPDATE Clerk SET password=?, hire_date=? WHERE username=?");
	#print_r(array("$password", "$data","$username"));
	$st->execute(array("$password", "$data","$username"));

	header("Location: clerk.php?reset=1");
	exit();	
?>
