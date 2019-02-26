<?php
	// Don't Forget to exit after header!! otherwise will continue process!
	session_start();
	$search_tool = 1;
	$error       = '';

	$type      = htmlspecialchars($_POST['type']);
	$kw        = htmlspecialchars($_POST['keywords']);

	$query_id = "select tool_id from Tool where 1=1";

	try{
		$pdo = new PDO("mysql:dbname=Tools4Rent", "root", "root");
	}catch(PDOException $e){
		print $e->getMessage();
	}

	if ($type != 'all'){
		$query_id = $query_id." AND type='$type' ";
	}
	if (isset($kw)){
		$query_id = $query_id." AND ( manufacturer LIKE '%$kw%' OR material LIKE '%$kw%' OR length LIKE '%$kw%' OR width LIKE '%$kw%' OR sub_option LIKE '%$kw%' ) ";
	}
	$st = $pdo->query($query_id);
	$array = $st->fetchAll(PDO::FETCH_COLUMN);

	$_SESSION['clerk_rental_tool'] = array();

	foreach ($array as $key => $value){
		$overlap = 0;
		$res = $pdo->query("SELECT DISTINCT reservation_id from ReservationTool INNER JOIN Tool on ReservationTool.tool_id = Tool.tool_id WHERE Tool.tool_id=$value");
		$res_id = $res->fetchAll(PDO::FETCH_COLUMN);
		$colcount = count($res_id);
		foreach ($res_id as $value2){
			$res_time = $pdo->query("Select start_date, end_date from Reservation WHERE reservation_id=$value2");
			$res_time_st = $res_time->fetch(); // Only one row return
			$res_starttime = strtotime($res_time_st[0]);
			$res_endtime = strtotime($res_time_st[1]);
			$current_time = strtotime(date('Y-m-d'));
			if  (($res_starttime > $current_time) or ($res_endtime < $current_time)){
				continue;	
			}else{
				$overlap = 1;
			}
		}
		if ($overlap == 1){
			unset($array[$key]);
			array_push($_SESSION['clerk_rental_tool'], $value);
		}
	}

	$_SESSION['clerk_avail_tool'] = $array;
	//print_r ($_SESSION['clerk_avail_tool']);
	//print_r ($_SESSION['clerk_rental_tool']);

	header("Location: toolinvent.php");
	exit();
?>
