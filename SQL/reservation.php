<?php
	// Don't Forget to exit after header!! otherwise will continue process!
	session_start();
	$reserve_tool = 1;
	$error       = '';

	$username = isset($_SESSION['login_user'])?$_SESSION['login_user']:"";
	if(!$username){
		$error = "Please Login before making Reservation";
		header("Location: index.php?reserve_tool=".$reserve_tool."&reserve_error=".$error);
		exit();
	}


	$type      = htmlspecialchars($_POST['type']);
	$ps        = htmlspecialchars($_POST['powersource']);
	$subtype   = htmlspecialchars($_POST['subtype']);
	$kw        = htmlspecialchars($_POST['keywords']);
	$starttime = strtotime(htmlspecialchars($_POST['startdate']));
	$endtime   = strtotime(htmlspecialchars($_POST['enddate']));
	$startdate = date("Y-m-d", $starttime);
	$enddate = date("Y-m-d", $endtime);
	$_SESSION['startdate'] = $starttime;
	$_SESSION['enddate'] = $endtime;

	$query_id = "select tool_id from Tool where 1=1";

	if ($_POST['startdate'] and $_POST['enddate']){
		if ($endtime <= $starttime){
			$error = "Reservation End Date should be later than Start Date";
			header("Location: index.php?reserve_tool=".$reserve_tool."&reserve_error=".$error);
			exit();	
		}

		if (($starttime+(60*60*24)) < time() ){
			$error = "Reservation Start Date should be later than Today";
			header("Location: index.php?reserve_tool=".$reserve_tool."&reserve_error=".$error);
			exit();
		}

	}else{
		$error = "Please Specify Reservation Start Date and End Date";
		header("Location: index.php?reserve_tool=".$reserve_tool."&reserve_error=".$error);
		exit();
	};


	try{
		$pdo = new PDO("mysql:dbname=Tools4Rent", "root", "root");
	}catch(PDOException $e){
		print $e->getMessage();
	}
	if ($subtype != 'all'){
		$query_id = $query_id." AND sub_type='$subtype' ";
	}
	if ($type != 'all'){
		$query_id = $query_id." AND type='$type' ";
	}
	if ($ps != 'all'){
		$query_id = $query_id." AND power_source='$ps' ";
	}
	if (isset($kw)){
		$query_id = $query_id." AND ( manufacturer LIKE '%$kw%' OR material LIKE '%$kw%' OR length LIKE '%$kw%' OR width LIKE '%$kw%' OR sub_option LIKE '%$kw%' ) ";
	}
	$st = $pdo->query($query_id);
	$array = $st->fetchAll(PDO::FETCH_COLUMN);

	if ($_POST['startdate'] and $_POST['enddate']){	
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
				if  (($starttime > $res_endtime) or ($endtime < $res_starttime)){
					continue;	
				}else{
					$overlap = 1;
				}
			}
			if ($overlap == 1){
				unset($array[$key]);
			}
				
		}
	}


	$reserve_tool=2;
	$_SESSION['avail_tool'] = $array;
	$_SESSION['rental_tool'] = array();
	header("Location: index.php?reserve_tool=".$reserve_tool);
	exit();
?>
