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
    <title> Customer Report </title>
    <link rel="stylesheet" type="text/css" href="./main.css">
</head>
<body>
  <header>
  <h3 class='T4R'> Tools-4-Rents! </h3>
  <a href='./logout.php' class='Wel' style='font-size:1.5vw;'> Logout </a>
  </header>
  
  <div class="MainMenuCus" style="padding-bottom:10px"> 
  <p> Customer Report </p>   
  <div class="line_contain">
        <p>The list of customers and reservations with tools for the last month.</p>
  </div>
  </div>

  <div class="MainMenuCus" style="padding-bottom:10px;margin-top:-1.5%">
  <?php
	$pdo = new PDO("mysql:dbname=Tools4Rent", "root", "root");
        $query ="
SELECT NumReserByCust.customer_username, NumReserByCust.customer_id, NumReserByCust.first_name, NumReserByCust.middle_name,                
NumReserByCust.last_name, NumReserByCust.email, NumReserByCust.primary_area_code, 
NumReserByCust.primary_phone_number, NumReserByCust.NumReservePerCustomer, NumToolsByCustomer.NumOfToolsPerCustomer
 FROM
(SELECT Reservation.customer_username, Customer.customer_id, Customer.first_name, Customer.middle_name, Customer.last_name,
 Customer.email, Customer.primary_area_code, Customer.primary_phone_number, COUNT(Reservation.reservation_id) AS NumReservePerCustomer
 FROM `Reservation` JOIN `Customer` ON Reservation.customer_username = Customer.username WHERE YEAR(Reservation.start_date)
 = YEAR(CURRENT_DATE - INTERVAL 1 MONTH) AND MONTH(Reservation.start_date) = MONTH(CURRENT_DATE - INTERVAL 1 MONTH)
 GROUP BY Reservation.customer_username ) AS NumReserByCust
JOIN 
(SELECT Reservation.customer_username, SUM(ReservationItemNum.NumOfToolsPerReserve) as NumOfToolsPerCustomer
 FROM
(
SELECT Reservation.reservation_id,COUNT(tool_id) as NumOfToolsPerReserve
 FROM `Reservation`
LEFT OUTER JOIN `ReservationTool`
ON Reservation.reservation_id = ReservationTool.reservation_id
WHERE YEAR(Reservation.start_date) = YEAR(CURRENT_DATE - INTERVAL 1 MONTH)
AND MONTH(Reservation.start_date) = MONTH(CURRENT_DATE - INTERVAL 1 MONTH)
GROUP BY Reservation.reservation_id 
)
AS ReservationItemNum
JOIN `Reservation`
ON ReservationItemNum.reservation_id = Reservation.reservation_id
GROUP BY Reservation.customer_username
)
AS NumToolsByCustomer 
ON NumReserByCust.customer_username = NumToolsByCustomer.customer_username 
ORDER BY NumToolsByCustomer.NumOfToolsPerCustomer DESC, NumReserByCust.last_name;
";

    $st = $pdo->query($query);
    $result = $st->fetchAll();
	echo "<div class='line_contain' style='margin-left:-20px;padding-top:30px;padding-left:0;text-align:center'>";
	echo "<span class='inline_pos width_05' > <p> ID </p> </span>";
	echo "<span class='inline_pos width_05' > <p> Profile </p> </span>";	
	echo "<span class='inline_pos width_1' > <p> First N </p> </span>";
	echo "<span class='inline_pos width_1' > <p> Middle N </p> </span>";
	echo "<span class='inline_pos width_1' > <p> Last N </p> </span>";
	echo "<span class='inline_pos width_2' > <p> Email </p> </span>";
	echo "<span class='inline_pos width_15' > <p> Phone </p> </span>";
	echo "<span class='inline_pos width_1' > <p> T.Rese </p> </span>";
	echo "<span class='inline_pos width_1' > <p>T.Rent </p> </span>";
	echo "</div>";

    foreach ($result as $key => $row){
		$profile_path = "viewprofile.php?user=" .$row['customer_username'];
		echo "<div class='line_contain' style='margin-left:-20px;padding-left:0;;text-align:center'>";
		echo "<span class='inline_pos width_05'> <p> $row[1] </p> </span>";
		echo "<span class='inline_pos width_05'> <p><a class='tool_detail' href=$profile_path onclick=\"window.open(this.href, 'targetWindow','width=800px,height=600px'); return false;\"> Profile </a></p> </span>";	
		echo "<span class='inline_pos width_1'> <p> $row[2] </p> </span>";
		echo "<span class='inline_pos width_1'> <p> $row[3] </p> </span>";
		echo "<span class='inline_pos width_1'> <p> $row[4] </p> </span>";
		echo "<span class='inline_pos width_2'> <p> $row[5] </p> </span>";
		$phone = $row[6].$row[7];
		echo "<span class='inline_pos width_15'> <p> $phone </p> </span>";
		echo "<span class='inline_pos width_1'> <p> $row[8] </p> </span>";
		echo "<span class='inline_pos width_1'> <p> $row[9] </p> </span>";
		echo "</div>";
    }
    ?>

<button type="button" style='font-size:1.5vw;padding:10px 10px;margin:30px auto 10px 20px;' > 
<a href='clerk.php'> Return </a> </button>
<button type="button" style='font-size:1.5vw;padding:10px 10px;margin:30px auto 10px 10px;'> 
<a href='customer_report.php'> Reload </a></button>
</div>

<footer>
        <?php
        echo ("<p style=\"padding-bottom:10px;padding-right:30px;color:white; float: right; size:1vw\"> <em> Welcome to <b> Tools-4-Rents </b>, Clerk $clerk_fullname! <em> </p>");
        ?>
</footer>
</body>
</html>
