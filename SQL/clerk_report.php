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
    <title> Clerk Report </title>
    <link rel="stylesheet" type="text/css" href="./main.css">
</head>
<body>
  <header>
  <h3 class='T4R'> Tools-4-Rents! </h3>
  <a href='./logout.php' class='Wel' style='font-size:1.5vw;'> Logout </a>
  </header>
  
  <div class="MainMenuCus" style="padding-bottom:10px"> 
  <p> Clerk Report </p>   
  <div class="line_contain">
        <p>The list of clerks where their total pickups and dropoffs are shown for the past month.</p>
  </div>
  </div>

  <div class="MainMenuCus" style="padding-bottom:10px;margin-top:-1.5%">
 
  <?php
	$pdo = new PDO("mysql:dbname=Tools4Rent", "root", "root");
        $query = "SELECT PickUpReport.clerk_id, PickUpReport.first_name, PickUpReport.middle_name, PickUpReport.last_name, PickUpReport.email,
                           PickUpReport.hire_date, PickUpReport.numOfPickUps, DropOffReport.numOfDropOffs, 
                           (PickUpReport.numOfPickUps + DropOffReport.numOfDropOffs) AS combinedTotal
                    FROM
                           (SELECT Clerk.*, COUNT(MonthReserve1.pickup_clerk) AS numOfPickUps
                            FROM `Clerk` LEFT OUTER JOIN
                                (SELECT * FROM  `Reservation`
                                WHERE YEAR(Reservation.start_date) = YEAR(CURRENT_DATE)
                                      AND MONTH(Reservation.start_date) = MONTH(CURRENT_DATE))
                                AS MonthReserve1
                            ON Clerk.username = MonthReserve1.pickup_clerk
                            GROUP BY Clerk.clerk_id) 
                            AS PickUpReport
                            NATURAL JOIN
                            (SELECT Clerk.clerk_id, COUNT(MonthReserve2.dropoff_clerk) AS numOfDropOffs
                            FROM `Clerk` LEFT OUTER JOIN
                                (SELECT * FROM  `Reservation`
                                 WHERE YEAR(Reservation.end_date) = YEAR(CURRENT_DATE)
                                       AND MONTH(Reservation.end_date) = MONTH(CURRENT_DATE))
                                 AS MonthReserve2
                            ON Clerk.username = MonthReserve2.dropoff_clerk
                            GROUP BY Clerk.clerk_id) 
                            AS DropOffReport
                    ORDER BY combinedTotal DESC";

    $st = $pdo->query($query);
    $result = $st->fetchAll();
	echo "<div class='line_contain' style='padding-left:0;text-align:center'>";
	echo "<span class='inline_pos width_05'> <p> ID </p> </span>";
	echo "<span class='inline_pos width_1'> <p> First N </p> </span>";	
	echo "<span class='inline_pos width_1'> <p> Middle N </p> </span>";
	echo "<span class='inline_pos width_1'> <p> Last N </p> </span>";
	echo "<span class='inline_pos width_3'> <p> Email </p> </span>";
	echo "<span class='inline_pos width_1'> <p> HireDate </p> </span>";
	echo "<span class='inline_pos width_05'> <p> Pick </p> </span>";
	echo "<span class='inline_pos width_05'> <p> Drop </p> </span>";
	echo "<span class='inline_pos width_05'> <p> T. </p> </span>";
	echo "</div>";

    foreach ($result as $key => $row){
		$date=date("m/d/Y",strtotime($row["hire_date"]));
		echo "<div class='line_contain' style='padding-left:0;;text-align:center'>";
		echo "<span class='inline_pos width_05'> <p> $row[0] </p> </span>";
		echo "<span class='inline_pos width_1'> <p> $row[1] </p> </span>";	
		echo "<span class='inline_pos width_1'> <p> $row[2] </p> </span>";
		echo "<span class='inline_pos width_1'> <p> $row[3] </p> </span>";
		echo "<span class='inline_pos width_3'> <p> $row[4] </p> </span>";
		echo "<span class='inline_pos width_1'> <p> $row[5] </p> </span>";
		echo "<span class='inline_pos width_05'> <p> $row[6] </p> </span>";
		echo "<span class='inline_pos width_05'> <p> $row[7] </p> </span>";
		echo "<span class='inline_pos width_05'> <p> $row[8] </p> </span>";
		echo "</div>";
    }
    ?>

<button type="button" style='font-size:1.5vw;padding:10px 10px;margin:30px auto 10px 20px;' > 
<a href='clerk.php'> Return </a> </button>
<button type="button" style='font-size:1.5vw;padding:10px 10px;margin:30px auto 10px 10px;'> 
<a href='clerk_report.php'> Reload </a></button>
</div>

<footer>
        <?php
        echo ("<p style=\"padding-bottom:10px;padding-right:30px;color:white; float: right; size:1vw\"> <em> Welcome to <b> Tools-4-Rents </b>, Clerk $clerk_fullname! <em> </p>");
        ?>
</footer>
</body>
</html>
