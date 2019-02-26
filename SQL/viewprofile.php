<html lang="en">
<head>
<style>
* {
        margin: 0;
        padding: 0;
        border: 0;
        font-family: 'Lato', sans-serif;
        overflow: scroll;
}
</style>
<link rel="stylesheet" type="text/css" href="./main.css">
</head>
<body style='background-color:rgb(47, 47, 47);'>
<div class='container' style='padding:10px 16px;'> </div>
<p style="padding:10px 36px;color:white;font-size:3vw;font-weight:bold;display:block"> View Profile </p>

<div id="viewprofile" class="modal" style='display:block;padding:0px;'>
<?php
	session_start();
	$username = isset($_GET['user'])?$_GET['user']:'';
	echo "<div class='modal-content'  style='width:90%; overflow:true; margin: 10% auto 1% auto;'>"; //Begin of Customer Info
	echo "<p style=\"padding-top:20px;margin-left:2%;font-size:2vw;margin-bottom:2%\"> Customer Info </p>";
	try{
		$pdo = new PDO("mysql:dbname=Tools4Rent", "root", "root");
	}catch(PDOException $e){
		print $e->getMessage();
	}
	$st = $pdo->query("select email, first_name, middle_name, last_name, home_area_code, home_phone_number,work_area_code,work_phone_number,cell_area_code,cell_phone_number,street,city,state,zip_code, home_phone_extension, work_phone_extension, cell_phone_extension from Customer where username='$username'");
	$res = $st->fetch();
      	$email = $res[0];
      	$fullname = $res[1].' '.$res[2].' '.$res[3];
      	$homep  = '('.$res[4].')'.substr($res[5],0,3).'-'.substr($res[5],3,4);
      	$workp  = '('.$res[6].')'.substr($res[7],0,3).'-'.substr($res[7],3,4);
      	$cellp  = '('.$res[8].')'.substr($res[9],0,3).'-'.substr($res[9],3,4);
      	$homep = empty($res[14])?$homep:$homep.' x'.$res[14];
      	$workp = empty($res[15])?$workp:$workp.' x'.$res[15];
      	$cellp = empty($res[16])?$cellp:$cellp.' x'.$res[16];

      	$addr   = $res[10].', '.$res[11].', '.$res[12].' '.$res[13];
      	echo "<p style='margin-left:3%;margin-bottom:10px;'> E-mail: $email </p>";
      	echo "<p style='margin-left:3%;margin-bottom:10px;'> Full Name: $fullname </p>";
      	if ($res[4])
		echo "<p style='margin-left:3%;margin-bottom:10px;'> Home Phone: $homep </p>";
      	if ($res[6])
		echo "<p style='margin-left:3%;margin-bottom:10px;'> Work Phone: $workp </p>";
      	if ($res[8])
		echo "<p style='margin-left:3%;margin-bottom:10px;'> Cell Phone: $cellp </p>";
      	echo "<p style='margin-left:3%;margin-bottom:10px;'> Address: $addr </p>";
      	echo "<div class='container' style='padding:10px 16px;'> </div>";
	echo "</div>";
?>

<?php
	echo "<div class='modal-content '  style='width:90%; overflow:true; margin: 0% auto;'>"; //Begin of Reservation part
	echo "<p style=\"padding-top:20px;margin-left:2%;font-size:2vw;margin-bottom:2%\"> Reservation </p>";
	echo "<div class='container'>";
	echo "<p style='font-size:1.1vw;margin-left:2%; text-align:right;width:4%;display:inline-block;border-top:-10px;vertical-align:top;'> <b> ResID </b></p>";
	echo "<p style='font-size:1.1vw;width:25%;text-align:center;display:inline-block;vertical-align:top;'> <b>Tools</b> </p>";
	echo "<p style='font-size:1.1vw;width:10%;display:inline-block;'> <b>Start Date</b> </p>";
	echo "<p style='font-size:1.1vw;width:10%;display:inline-block;'> <b>End Date</b> </p>";
	echo "<p style='font-size:1.1vw;width:10%;display:inline-block;'> <b>Pick-up </b> </p>";
	echo "<p style='font-size:1.1vw;width:10%;display:inline-block'> <b>Drop-off </b> </p>";
	echo "<p style='font-size:1.1vw;width:4%;display:inline-block;text-align:center'> <b>Res.D</b> </p>";
	echo "<p style='font-size:1.1vw;width:10%;display:inline-block;text-align:right'> <b>T. Dep</b> </p>";
	echo "<p style='font-size:1.1vw;width:10%;display:inline-block;text-align:right'> <b>T. Ren</b> </p>";
	echo "</div>";
	try{
		$pdo = new PDO("mysql:dbname=Tools4Rent", "root", "root");
	}catch(PDOException $e){
		print $e->getMessage();
	}
	$res = $pdo->query("SELECT reservation_id, start_date, end_date, pickup_clerk, dropoff_clerk from Reservation WHERE customer_username = '$username'");
	while($row = $res->fetch()) {
		echo "<div class='container' style='padding:5px 16px'>";
		echo "<p style='font-size:1.1vw;margin-left:2%; text-align:right;width:4%;display:inline-block;border-top:-10px;vertical-align:top;'> <b> $row[0] </b></p>";
		$res_id = $row[0];
		$res_tools = $pdo->query("SELECT DISTINCT Tool.power_source, Tool.sub_option, Tool.sub_type, Tool.purchase_price, Tool.tool_id from ReservationTool INNER JOIN Tool ON ReservationTool.tool_id = Tool.tool_id WHERE ReservationTool.reservation_id='$res_id'");
		
		$pickup_name ='';
		$dropoff_name='';
		$pickup_username = $row[3];
		$pickup  = $pdo->query("SELECT DISTINCT Clerk.first_name, Clerk.last_name From Reservation INNER JOIN Clerk on Reservation.pickup_clerk = Clerk.username WHERE Reservation.pickup_clerk='$pickup_username';");
		$picktemp = $pickup->fetch();
		$pickup_name = $picktemp[0];//.' '.$picktemp[1];

		$dropoff_username = $row[4];
		$dropoff  = $pdo->query("SELECT DISTINCT Clerk.first_name, Clerk.last_name From Reservation INNER JOIN Clerk on Reservation.dropoff_clerk = Clerk.username WHERE Reservation.dropoff_clerk='$dropoff_username';");
		$dropofftemp = $dropoff->fetch();
		$dropoff_name = $dropofftemp[0];//.' '.$dropofftemp[1];

		$tt = "SELECT DATEDIFF(end_date, start_date) FROM Reservation WHERE reservation_id='$res_id'";
		$stt = $pdo->query($tt);
		$temp = $stt -> fetch();
		$days_between = $temp[0];
		
		echo "<p style='font-size:1.1vw;width:25%;text-align:center;display:inline-block;vertical-align:top;'>";
		$total_ren = 0;
		$total_dep = 0;
		while($temp = $res_tools ->fetch()) {
			$short_descript = ucfirst($temp[0]) . " ". ucfirst($temp[1]) ." ".ucfirst($temp[2]);
			if (ucfirst($temp[0]) == 'Manual')
				$short_descript = ucfirst($temp[1]) ." ".ucfirst($temp[2]);
			$rental_price = (0.15 * $temp[3])*$days_between;
			$deposit_price = 0.4 * $temp[3];
			$total_ren += $rental_price;
			$total_dep += $deposit_price;
			$toolid   = $temp[4];
				echo "<a class='tool_detail' href='tooldetail.php?tool_id=$toolid' onclick=\"window.open(this.href, 'targetWindow','width=400px,height=500px'); return false;\"> $short_descript </a> <br/>";
		}
		echo "</p>";
		echo "<p style='font-size:1.1vw;width:10%;display:inline-block;vertical-align:top;'> $row[1] </p>";
		echo "<p style='font-size:1.1vw;width:10%;display:inline-block;vertical-align:top;'> $row[2] </p>";
		echo "<p style='font-size:1.1vw;width:10%;display:inline-block;vertical-align:top;'> $pickup_name </p>";
		echo "<p style='font-size:1.1vw;width:10%;display:inline-block;vertical-align:top;'> $dropoff_name </p>";
		echo "<p style='font-size:1.1vw;width:4%;display:inline-block;vertical-align:top;'> $days_between </p>";
		echo "<p style='font-size:1.1vw;width:10%;display:inline-block;text-align:right;vertical-align:top;'>" . sprintf("%.2f",$total_dep) ." </p>";
		echo "<p style='font-size:1.1vw;width:10%;display:inline-block;text-align:right;vertical-align:top;'>" . sprintf("%.2f", $total_ren) ."</p>";
		echo "</div>";
	}
		
	echo "<div class='container'> </div>";		
	echo "</div>"; // End of Reservation part
?>
</div>
</body>
</html>
