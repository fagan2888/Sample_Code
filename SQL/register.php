<?php
	// Don't Forget to exit after header!! otherwise will continue process!
	session_start();
	$error = '';
	$first_name   = htmlspecialchars($_POST['firstname']);
	$middle_name = htmlspecialchars($_POST['middlename']);
	$last_name    = htmlspecialchars($_POST['lastname']);
	$homephone   = htmlspecialchars($_POST['homephone']);
	$workphone   = htmlspecialchars($_POST['workphone']);
	$cellphone   = htmlspecialchars($_POST['cellphone']);
	
	if ($homephone){
		if ((substr($homephone,3,1) != "-") or 
			((strlen($homephone) != 11) and 
			(strlen($homephone) != 16))) {
                	$error = 'Home Phone Number Format wrong. (214-6624202x0000)';
                	header("Location: index.php?register_error=".$error);
                	exit();			
		}
		$home_area_code = substr($homephone, 0, 3);
		$home_phone_number = substr($homephone, 4, 7);
		if (strlen($homephone) == 16){
			if (substr($homephone,11,1) != "x") {
				$error = 'Home Phone Number Format wrong. (214-6624202x0000)';
				header("Location: index.php?register_error=".$error);
				exit();
			}
			$home_phone_extension = substr($homephone, 12, 4);
		}	
	}

	if ($workphone){
                if ((substr($workphone,3,1) != "-") or
                        ((strlen($workphone) != 11) and
                        (strlen($workphone) != 16))) {
                        $error = 'Work Phone Number Format wrong. (214-6624202x0000)';
                        header("Location: index.php?register_error=".$error);
                        exit();
                }
		$work_area_code = substr($workphone, 0, 3);
		$work_phone_number = substr($workphone, 4, 7);
		if (strlen($workphone) == 16){
			if (substr($workphone,11,1) != "x") {
                                $error = 'Work Phone Number Format wrong. (214-6624202x0000)';
                                header("Location: index.php?register_error=".$error);
                                exit();
                        }
			$work_phone_extension = substr($workphone, 12, 4);
		}
	}

	if ($cellphone){
                if ((substr($cellphone,3,1) != "-") or
                        ((strlen($cellphone) != 11) and
                        (strlen($cellphone) != 16))) {
                        $error = 'Cell Phone Number Format wrong. (214-6624202x0000)';
                        header("Location: index.php?register_error=".$error);
                        exit();
                }
		$cell_area_code = substr($cellphone, 0, 3);
		$cell_phone_number = substr($cellphone, 4, 7);
		if (strlen($cellphone) == 16){
			if (substr($cellphone,11,1) != "x") {
                                $error = 'Cell Phone Number Format wrong. (214-6624202x0000)';
                                header("Location: index.php?register_error=".$error);
                                exit();
                        }
			$cell_phone_extension = substr($cellphone, 12, 4);
		}
	}

	$pgroup      = htmlspecialchars($_POST['phone']);
	if ($pgroup == 'homephone'){
		$primary_area_code = $home_area_code;
		$primary_phone_number = $home_phone_number;
		$primary_phone_extension = $home_phone_extension;
	}else if ($pgroup == 'cellphone'){
		$primary_area_code = $cell_area_code;
		$primary_phone_number = $cell_phone_number;
		$primary_phone_extension = $cell_phone_extension;
	}else if ($pgroup == 'workphone'){
		$primary_area_code = $work_area_code;
		$primary_phone_number = $work_phone_number;
		$primary_phone_extension = $work_phone_extension;
	}else{
		$error = 'Please Select a Primary Number';
		header("Location: index.php?register_error=".$error);
		exit();
	}

	if (empty($primary_area_code) or empty($primary_phone_number)){
		$error = 'Must Input Primary Phone Number';
		header("Location: index.php?register_error=".$error);
		exit();
	}
	$name_on_card = htmlspecialchars($_POST['ccname']);
	$card_number  = htmlspecialchars($_POST['ccnumber']);
	$cvv          = htmlspecialchars($_POST['cvc']);
	$exp_month    = htmlspecialchars($_POST['exp_month']);
	$exp_year     = htmlspecialchars($_POST['exp_year']);

	$email      = htmlspecialchars($_POST['email']);
	$username   = $email;
	$password   = htmlspecialchars($_POST['password']);
	$repassword = htmlspecialchars($_POST['repassword']);
	
	if ($password != $repassword){
		$error = 'Password are not same';
		header("Location: index.php?register_error=".$error);
		exit();
	}
	
	$street    = htmlspecialchars($_POST['street']);
	$city      = htmlspecialchars($_POST['city']);
	$zip_code  = htmlspecialchars($_POST['zip']);
	$state     = htmlspecialchars($_POST['state']);

	$pdo = new PDO("mysql:dbname=Tools4Rent", "root", "root");
	$st = $pdo->query("select * from Customer where username='$email'");
	$rows = $st->fetchColumn();
	if ($rows) {
		$error = 'Email already existed.';
		header("Location: index.php?register_error=".$error);
		exit();
	}
	$st = $pdo->prepare("INSERT INTO Customer(work_area_code,work_phone_number,work_phone_extension, home_area_code, home_phone_number, home_phone_extension, cell_area_code, cell_phone_number, cell_phone_extension, primary_area_code, primary_phone_number, primary_phone_extension, name_on_card, card_number,cvv, exp_month, exp_year, street, city, state, zip_code, username, first_name, middle_name, last_name, email, password) VALUES(?,?,?, ?,?,?, ?,?,?, ?,?,?, ?,?,?,?,?, ?,?,?,?, ?, ?,?,?, ?,?)");
	$st->execute(array($work_area_code,$work_phone_number,$work_phone_extension, $home_area_code, $home_phone_number, $home_phone_extension, $cell_area_code, $cell_phone_number, $cell_phone_extension, $primary_area_code, $primary_phone_number, $primary_phone_extension, "$name_on_card", $card_number, $cvv, $exp_month, $exp_year, "$street", "$city", "$state", $zip_code, "$username", "$first_name", $middle_name, "$last_name", "$email", "$password"));

	$error='Registration Success!';
	header("Location: index.php?register_error=".$error);
	exit();
?>
