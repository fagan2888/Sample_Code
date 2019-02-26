<?php
	// Don't Forget to exit after header!! otherwise will continue process!
	session_start();
	$click_tool = isset($_GET['click_tool'])?$_GET['click_tool']:'';
	$rental_tool = $_SESSION['avail_tool'][$click_tool];
	unset($_SESSION['avail_tool'][$click_tool]);
	array_push($_SESSION['rental_tool'], $rental_tool);
	if (count($_SESSION['rental_tool']) > 10){
		$error = "Cannot Rent more than 10 items at once";
		header("Location: index.php?reserve_tool=1&reserve_error=".$error);
		exit();
	}else{
		header("Location: index.php?reserve_tool=2");
		exit();
	}
?>
