<?php
	session_start();
	$login_error='';
	$_SESSION['login_sucess']=false;
	if (isset($_POST['submit'])) {
	if (empty($_POST['username']) || empty($_POST['password'])) {
		$_SESSION['login_error'] = "No Username or Password";
	}else{
		$username = htmlspecialchars($_POST['username']);
		$password = htmlspecialchars($_POST['password']);
		$group    = htmlspecialchars($_POST['group']);
		try{
			$pdo = new PDO("mysql:dbname=Tools4Rent", "root", "root");
		}catch(PDOException $e){
			print $e->getMessage();
		}
		$st = $pdo->query("select * from $group where password='$password' AND username='$username'");
		$rows = $st->fetchColumn();
		if ($rows) {
			$_SESSION['login_user']=$username; // Initializing Session
			$_SESSION['login_sucess']=true;
			if ($group == "Clerk"){
				header("Location: clerk.php");
			exit();
			}else{
				header("Location: index.php");
			exit();
			}
		}else{
			$login_error = "Username or Password is invalid";
		}
	}
	}
	header("Location: index.php?login_error=".$login_error);
	exit();
?>
