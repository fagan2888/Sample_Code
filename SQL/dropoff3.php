<?php
session_start();
$reservation_id = isset($_GET['reservation_id'])?$_GET['reservation_id']:"";
$pdo = new PDO("mysql:dbname=Tools4Rent", "root", "root");
// Update

$query0 = "SELECT customer_id FROM Customer INNER JOIN Reservation ON Customer.username = Reservation.customer_username WHERE Reservation.reservation_id='$reservation_id' AND Reservation.dropoff_clerk IS NULL";
$st = $pdo->query($query0);
$temp = $st -> fetch();
$customer_id=$temp[0];

$query0 = "SELECT first_name, middle_name, last_name, card_number, start_date, end_date FROM Customer INNER JOIN Reservation ON Customer.username = Reservation.customer_username WHERE Reservation.reservation_id='$reservation_id' AND Reservation.dropoff_clerk IS NULL";
$st = $pdo->query($query0);
$temp = $st -> fetch();
$first_name=$temp[0];
$middle_name=$temp[1];
$last_name=$temp[2];
$customer_name = $first_name.' '.$middle_name.' '.$last_name;
$creditcard=$temp[3];
$startdate=date('m/d/Y',strtotime($temp[4]));
$enddate=date('m/d/Y',strtotime($temp[5]));
$clerk_username = $_SESSION['login_user'];
$query0 = "SELECT clerk_id, first_name, middle_name, last_name FROM Clerk WHERE username='$clerk_username'";
$st = $pdo->query($query0);
$temp = $st -> fetch();
$clerk_id=$temp[0];
$clerk_name = $temp[1].' '.$temp[2].' '.$temp[3];

$query ="UPDATE Reservation SET dropoff_clerk = '$clerk_username' WHERE reservation_id=$reservation_id";
$st = $pdo->prepare($query);
$st->execute();

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
	<title>Dropoff Confirmation</title>
	<link rel="stylesheet" type="text/css" href="./main.css">	
	<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
	<script>
		$(document).ready( () => {
			window.print();			
		});
	</script>
</head>


<body>
  <header>
    <h3 class='T4R'> Tools-4-Rents! </h3>
    <a href='./logout.php' class='Wel' style='font-size:1.5vw;'> Logout </a>
  </header>

<div class="MainMenuCus" style="padding-bottom:10px">
  <p> Dropoff Reservation </p>
  <div class="line_contain" style='padding-bottom:0'><p> <b> Dropoff Confirmation </b></p> </div>
  <div class="line_contain" style='padding-bottom:0;margin-left:30px'><p>  Dropoff Clerk: <?php echo $clerk_name;?></p> </div>
  <div class="line_contain" style='padding-bottom:0;margin-left:30px'><p> Customer Name: <?php echo $customer_name;?></p> </div>
  <div class="line_contain" style='padding-bottom:0;margin-left:30px'><p> Credit Card:  <?php echo $creditcard;?></p>  </div>
  <div class="line_contain" style='padding-bottom:0;margin-left:30px'><p> Start Date: <?php echo $startdate;?></p>  </div>
  <div class="line_contain" style='padding-bottom:20px;margin-left:30px'><p> End Date <?php echo $enddate;?></p>  </div>
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

  <div class='line_contain' style='text-align:center; padding-bottom:0px'> </div>
</div>

  <div class="MainMenuCus" style="padding-bottom:10px;margin-top:-1.5%">
<p> Signatures </p>

<div class="line_contain"  style='margin-left:30px;'>
<span class='inline_pos width_4' style='border-bottom:1px solid black'> <p> x </p></span>
<span class='inline_pos width_1'> </span>
<span class='inline_pos width_3' style='border-bottom:1px solid black'> <p> Date: </p></span>
</div>
<div class="line_contain" style='margin-top:-10px;margin-left:30px;'>
<span class='inline_pos width_4' > <p> Dropoff Clerk: <?php echo $clerk_name; ?> </p> </span>
</div>

<div class="line_contain" style='margin-left:30px;'>
<span class='inline_pos width_4' style='border-bottom:1px solid black'> <p> x </p></span>
<span class='inline_pos width_1'> </span>
<span class='inline_pos width_3' style='border-bottom:1px solid black'> <p> Date: </p></span>
</div>

<div class="line_contain" style='margin-top:-10px;margin-left:30px;'>
<span class='inline_pos width_4' > <p> Customer: <?php echo $customer_name; ?> </p> </span>
</div>

<button onclick="window.print()" style="margin-left:2%;height:40px;display:inline-block">Print Contract</button>
<button style="margin-left:2%;height:40px;display:inline-block"> <a href='dropoff1.php'> Return </a> </button>
</div>
<footer>
        <?php
        echo ("<p style=\"padding-bottom:10px;padding-right:30px;color:white; float: right; size:1vw\"> <em> Welcome to <b> Tools-4-Rents </b>, Clerk $clerk_fullname! <em> </p>");
        ?>
</footer>
</body>
</html>
