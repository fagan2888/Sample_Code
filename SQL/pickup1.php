<?php
session_start();
$username = $_SESSION['login_user'];
$pdo = new PDO("mysql:dbname=Tools4Rent", "root", "root");
$st = $pdo->query("select first_name, middle_name, last_name from Clerk where username='$username'");
$temp = $st -> fetch();
$clerk_id = $temp[0];
if (empty($clerk_id)){
        header('Location: ./logout.php');
        exit();
}
$clerk_fullname=ucfirst($temp[0]).' '.ucfirst($temp[1]).' '.ucfirst($temp[2]);
?>

<!DOCTYPE html>
<html lang="en">
<head> 
  <title>Landing page for Pickup</title>
  <link rel="stylesheet" type="text/css" href="./main.css"> 
</head>

<body>
  <header>
    <h3 class='T4R'> Tools-4-Rents! </h3>
    <a href='./logout.php' class='Wel' style='font-size:1.5vw;'> Logout </a>
    </header>

<div class="MainMenuCus" style="padding-bottom:10px">
    <p>Pickup Reservation</p>
    <div class="line_contain" style='text-align:center'>
     	<span class='inline_pos width_15'> <p> Reservation ID </p> </span>
	<span class='inline_pos width_3'> <p> Customer </p> </span>
	<span class='inline_pos width_15'> <p> Customer ID </p> </span>
	<span class='inline_pos width_15'> <p> Start Date </p> </span>
	<span class='inline_pos width_15'> <p> End Date </p> </span>
    </div>
    <?php
	$pdo = new PDO("mysql:dbname=Tools4Rent", "root", "root");
	$sql1 = "SELECT reservation_id, customer_username, customer_id, start_date, end_date FROM Reservation LEFT OUTER JOIN (SELECT username, customer_id FROM Customer) AS Tmptable ON Tmptable.username=Reservation.customer_username WHERE Reservation.pickup_clerk IS NULL";
	$st = $pdo->query($sql1);
	$result = $st->fetchAll();
	foreach ($result as $key => $row1){
		$res_path = "res_detail.php?reservation_id=" .$row1['reservation_id'];
		$startdate=date_create($row1["start_date"]);
		$enddate=date_create($row1["end_date"]);	
                echo "
			<div class='line_contain' style='text-align:center;padding-bottom:5px'>
			<span class='inline_pos width_15'> <p> <a class='tool_detail' href=$res_path onclick=\"window.open(this.href, 'targetWindow','width=800px,height=600px'); return false;\">". $row1["reservation_id"] . "</a></p></span>
			<span class='inline_pos width_3'> <p> ". $row1["customer_username"] ."</p> </span>
			<span class='inline_pos width_15'> <p> ". $row1["customer_id"] ."</p> </span>
			<span class='inline_pos width_15'> <p> ". date_format($startdate, "m/d/Y") ."</p> </span>
			<span class='inline_pos width_15'> <p> ". date_format($enddate, "m/d/Y") ."</p> </span>
			</div>
		";
	}
    ?>
	<form  action="pickup2.php" method="post">
		<div class="line_contain" style='text-align:left;margin-left:50px;padding-bottom:30px'>	
		<input type="text" placeholder="Enter Reservation ID" name="reservation_id" style='width:300px;font-size:11px;height:40px;'>
		<button name="submit" type="submit" style="border-radius: 0px;border:0;margin-left:-50px;font-size:11px;height:40px;display:inline-block">Pick Up</button> 
		<button type="button" style="margin-right:50px;height:40px;display:inline-block;float:right"> <a href='clerk.php'> Return </a> </button>
		</div>
	</form>
</div>
<footer>
        <?php
        echo ("<p style=\"padding-bottom:10px;padding-right:30px;color:white; float: right; size:1vw\"> <em> Welcome to <b> Tools-4-Rents </b>, Clerk $clerk_fullname! <em> </p>");
        ?>
</footer>

</body>
</html>

