<!-- pick up php: -->
<?php
session_start();
$reservation_id  = htmlspecialchars($_POST['reservation_id']);
$pdo = new PDO("mysql:dbname=Tools4Rent", "root", "root");
$query0 = "SELECT first_name, middle_name, last_name FROM Customer INNER JOIN Reservation ON Customer.username = Reservation.customer_username WHERE Reservation.reservation_id='$reservation_id' AND Reservation.pickup_clerk IS NOT NULL and Reservation.dropoff_clerk IS NULL";
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

$sql1 = "SELECT Tool.tool_id, Tool.power_source, Tool.sub_option, Tool.sub_type, Tool.purchase_price FROM ReservationTool INNER JOIN Tool ON ReservationTool.tool_id = Tool.tool_id WHERE ReservationTool.reservation_id='$reservation_id'";
$result1 = $pdo->query($sql1);
$tools = $result1 -> fetchAll();

$tt = "SELECT DATEDIFF(end_date, start_date) FROM Reservation WHERE reservation_id='$reservation_id'";
$stt = $pdo->query($tt);
$temp = $stt -> fetch();
$days_between = $temp[0];

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
	<title>Dropoff Page2</title>
	<link rel="stylesheet" type="text/css" href="./main.css">	
</head>

<script>
<?php
   if (empty($first_name)) {
   	echo "alert('Reservation ID not found or not picked or already dropeed');";
   	echo "window.location.replace(\"dropoff1.php\");";
   }
?>
</script>

<body>
  <header>
    <h3 class='T4R'> Tools-4-Rents! </h3>
    <a href='./logout.php' class='Wel' style='font-size:1.5vw;'> Logout </a>
    </header>

<div class="MainMenuCus" style="padding-bottom:10px">
  <p> Dropoff Reservation </p>
  <div class="line_contain" style='padding-bottom:0'><p> <b> Reservation Detail: </b></p> </div>
  <div class="line_contain" style='padding-bottom:0;margin-left:30px'><p> Reservation ID: <?php echo $reservation_id ?></p> </div>
  <div class="line_contain" style='padding-bottom:0;margin-left:30px'><p> Customer Name: <?php echo $customer_name ?></p>  </div>
  <div class="line_contain" style='padding-bottom:0;margin-left:30px'><p> Total Deposit: <?php echo sprintf('%0.2f', $deposit) ?> </p> </div>
  <div class="line_contain" style='padding-bottom:0;margin-left:30px'><p> Total Rental Price: <?php echo sprintf('%0.2f', $rentprice) ?> </p>  </div>
  <div class="line_contain" style='padding-bottom:20px;margin-left:30px'><p> Total Due: <?php echo sprintf('%0.2f', $rentprice - $deposit) ?> </p>  </div> 
 </div>
</div>

<div class="MainMenuCus" style="padding-bottom:10px;margin-top:-1.5%">
<p> Tools </p>
  <div class="line_contain" style='text-align:center'>
        <span class='inline_pos width_2'> <p> Tool ID </p> </span>
        <span class='inline_pos width_2'> <p> Tool Name </p> </span>
        <span class='inline_pos width_2'> <p> Rental Price </p> </span>
        <span class='inline_pos width_2'> <p> Deposit Price </p> </span>
  </div>

   <?php
	$total_rental = 0;
	$total_deposit = 0;
        foreach ($tools as $key => $temp){
                $short_descript = ucfirst($temp[1]) . " ". ucfirst($temp[2]) ." ".ucfirst($temp[3]);
                if (ucfirst($temp[1]) == 'Manual'){
                        $short_descript = ucfirst($temp[2]) ." ".ucfirst($temp[3]);
                }
                $id = $temp[0];
                $price = $temp[4];
		$total_rental  += (0.15*$price)*$days_between;
		$total_deposit += 0.4*$price;
                $rental = sprintf("%.2f", 0.15*$price*$days_between);
                $deposit = sprintf("%.2f", 0.4*$price);
                echo "
                        <div class='line_contain' style='text-align:center; padding-bottom:0px'>
                                <span class='inline_pos width_2'> <p> $id </p> </span>
                                <span class='inline_pos width_2'> <p>
                                <a class='tool_detail' href='tooldetail.php?tool_id=$id' target='_blank' onclick=\"window.open(this.href, 'targetWindow','width=400px,height=500px'); return false;\"> $short_descript </a></p> </span>
                                <span class='inline_pos width_2'> <p> $rental </p> </span>
                                <span class='inline_pos width_2'> <p> $deposit </p> </span>
                        </div>
                ";
        }

   ?>
  <div class="line_contain" style='text-align:center'>
        <span class='inline_pos width_2'> <p> <b> Total </b></p> </span>
        <span class='inline_pos width_2'> <p>  </p> </span>
        <span class='inline_pos width_2'> <p> <b> <?php echo sprintf("%0.2f",$total_rental); ?> </b></p> </span>
        <span class='inline_pos width_2'> <p> <b> <?php echo sprintf("%0.2f",$total_deposit); ?> </b></p> </span>
  </div>

<div class="line_contain" style='margin-left:30px;padding-bottom:30px;'>
<button name="confirmPickUp" type="submit" style="height:40px;display:inline-block"> <a href=<?php echo "dropoff3.php?reservation_id=$reservation_id" ?>> Confirm Dropoff </a></button>
</div>
</div>
<footer>
        <?php
        echo ("<p style=\"padding-bottom:10px;padding-right:30px;color:white; float: right; size:1vw\"> <em> Welcome to <b> Tools-4-Rents </b>, Clerk $clerk_fullname! <em> </p>");
        ?>
</footer>
</body>
</html>
