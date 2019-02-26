<?php
	session_start();
	$success=false;
	if(session_destroy()){
		header("Location: index.php");
		exit();
	}
	
?>
