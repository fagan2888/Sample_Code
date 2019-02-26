<?php
	// Don't Forget to exit after header!! otherwise will continue process!
	session_start();
	$click_tool = isset($_GET['click_tool'])?$_GET['click_tool']:'';
	$avail_tool = $_SESSION['rental_tool'][$click_tool];
	unset($_SESSION['rental_tool'][$click_tool]);
	array_push($_SESSION['avail_tool'], $avail_tool);
	header("Location: index.php?reserve_tool=2");
	exit();
?>
