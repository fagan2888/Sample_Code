<?php
	session_start();
	$reservation_id = isset($_GET['reservation_id'])?$_GET['reservation_id']:'';
        $pdo = new PDO("mysql:dbname=Tools4Rent", "root", "root");
	$query0 = "SELECT first_name, middle_name, last_name FROM Customer as C WHERE C.username=(SELECT customer_username FROM Reservation as R WHERE R.reservation_id='$reservation_id')";
	$st = $pdo->query($query0);
	$temp = $st -> fetch();
	$first_name=$temp[0];
	$middle_name=$temp[1];
	$last_name=$temp[2];
	$customer_name = $first_name.' '.$middle_name.' '.$last_name;

	$query="SELECT SUM(T.purchase_price*0.15*DATEDIFF(R.end_date,R.start_date)), SUM(T.purchase_price*0.4)FROM Reservation AS R, Tool AS T, ReservationTool AS RT WHERE R.reservation_id='$reservation_id' AND RT.reservation_id=R.reservation_id AND RT.tool_id=T.tool_id GROUP BY R.reservation_id";
	$st = $pdo->query($query);
	$temp = $st -> fetch();
	$rentprice=$temp[0];
	$deposit=$temp[1];


	$sql1 = "SELECT Tool.tool_id, Tool.power_source, Tool.sub_option, Tool.sub_type FROM ReservationTool INNER JOIN Tool ON ReservationTool.tool_id = Tool.tool_id WHERE ReservationTool.reservation_id='$reservation_id'";
	$result1 = $pdo->query($sql1);
	$tools = $result1 -> fetchAll();
?>

<html lang="en">
<head>
<style>
* {
        margin: 0;
        padding: 0;
        border: 0;
        font-family: 'Lato', sans-serif;
        overflow: auto;
}
</style>
</head>
<body style='background-color:rgb(217, 238, 247);'>
  <div style="height:100px;background-color:rgb(47,47,47);">
    <p style='color: white; font-size: 30px; font-weight: bold; padding: 25px;'> Reservation Detail </p>
  </div>


  <div style='margin:30px 30px; '>
    <p style='font-size:20px'> <b> Reservation ID: </b> </p>
    <p style='font-size:18px'> <?php echo "$reservation_id"; ?> <br/> </p>
    <p style='font-size:20px; padding-top:10px'> <b> Customer Name: </b> </p>
    <p style='font-size:18px'> <?php echo "$customer_name"; ?> </p>
    <p style='font-size:20px; padding-top:10px'> <b> Total Deposit: </b> </p>
    <p style='font-size:18px'> <?php echo "$".sprintf("%.2f",$deposit); ?> </p>
    <p style='font-size:20px; padding-top:10px'> <b> Total Rental Price: </b> </p>
    <p style='font-size:18px'> <?php echo "$".sprintf("%.2f",$rentprice); ?> </p>
    <p style='font-size:20px; padding-top:10px'> <b> Tools: </b> </p>
 <?php
   foreach ($tools as $key => $temp){
	$short_descript = ucfirst($temp[1]) . " ". ucfirst($temp[2]) ." ".ucfirst($temp[3]);
	if (ucfirst($temp[1]) == 'Manual'){
		$short_descript = ucfirst($temp[2]) ." ".ucfirst($temp[3]);
	}
	$id = $temp[0];
	echo "<p style='font-size:18px;padding-left:40px;'> 
		<a class='tool_detail' href='tooldetail.php?tool_id=$id' target='_blank' onclick=\"window.open(this.href, 'targetWindow','width=400px,height=500px'); return false;\">
		$short_descript </a>
	     </p>";
   }
 ?>

</div>
</body>
</html>


