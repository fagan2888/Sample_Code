<!-- pick up php: -->
<?php
session_start();
$reservation_id  = htmlspecialchars($_POST['reservation_id']);
$pdo = new PDO("mysql:dbname=Tools4Rent", "root", "root");
$query0 = "SELECT first_name, middle_name, last_name FROM Customer INNER JOIN Reservation ON Customer.username = Reservation.customer_username WHERE Reservation.reservation_id='$reservation_id' AND Reservation.pickup_clerk IS NULL";
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

$tt = "SELECT DATEDIFF(end_date, start_date) FROM Reservation WHERE reservation_id='$reservation_id'";
$stt = $pdo->query($tt);
$temp = $stt -> fetch();
$days_between = $temp[0];

$username = $_SESSION['login_user'];
$reset   = isset($_GET['reset'])?$_GET['reset']:"";
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
	<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
</head>
<script>
$(document).ready( () => {
	$('.new').on('click', ()=>{
		var newv=$('input[name=new]:checked').val();
		if (newv == 'new'){
			$(':input').attr('required',true);		
		}else if (newv == 'existing'){
			$(':input').removeAttr('required');
		}else
			alert('No Value'+newv);
	});
});
</script>

<script>
<?php
   if (empty($first_name)) {
   	echo "alert('Reservation ID not found or already picked');";
   	echo "window.location.replace(\"pickup1.php\");";
   }
?>
</script>

<body>
  <header>
    <h3 class='T4R'> Tools-4-Rents! </h3>
    <a href='./logout.php' class='Wel' style='font-size:1.5vw;'> Logout </a>
    </header>

<div class="MainMenuCus" style="padding-bottom:10px">
  <p> Pickup Reservation </p>
  <div class="line_contain" style='padding-bottom:0'><p> Reservation ID: <?php echo $reservation_id ?></p> </div>
  <div class="line_contain" style='padding-bottom:0'><p> Customer Name: <?php echo $customer_name ?></p>  </div>
  <div class="line_contain" style='padding-bottom:0'><p> Total Deposit: <?php echo sprintf('%0.2f', $deposit) ?> </p> </div>
  <div class="line_contain" style='padding-bottom:20px'><p> Total Rental Price: <?php echo sprintf('%0.2f', $rentprice) ?> </p>  </div>
  </div>
</div>

<div class="MainMenuCus" style="padding-bottom:10px;margin-top:-1.5%">
  <form <?php echo "action=\"rentalContract.php?reservation_id=$reservation_id\""; ?> method="post" >
  <p> Credit Card Update </p>
  <div class="line_contain">
  <input class='new' type="radio" name="new" value='existing' style="margin-left:3%;" checked="checked"> <label style="margin:auto 5px"> Existing </label>
  <input class='new' type="radio" name="new" value='new' style="margin-left:3%;"> <label style="margin:auto 5px"> New </label> 
  </div>
  <div class="line_contain" style='padding-bottom:0'> <p> Enter Updated Credit Card Information </p> </div>
  <div class="line_contain" style='margin-left:30px;color:red'> <p> ** THIS WILL OVERWRITE THE PRIOR CUSTOMERS CREDIT CARD INFORMATION ** </p> </div>
  <div class="line_contain" style='margin-left:10%;'>
	  <span class='inline_pos width_3'>
	  <input type="text" placeholder="Name on Credit Card" name="ccname" style="height:40px;" >
	  </span>
	  <span class='inline_pos width_3'>
	  <input type="number" placeholder="Credit Card #" name="ccnumber" style="height:40px; ">
  	  </span>
  </div>
  <div class="line_contain" style='margin-left:10%;'>
	  <span class='inline_pos width_2'>
	  <input type="number" placeholder="CVV" name="cvv" style="height:40px;">
	  </span>
	  <span class='inline_pos width_2'>
	  <select class="select_style" name="emonth" style="font-size:14px;width:100%; height:40px; padding-left:12px"> <script src="dropdown/month.js"> </script> </select>
	  </span>
	  <span class='inline_pos width_2'>
	  <select class="select_style" name="eyear" style="font-size:14px;width:100%; height:40px; padding-left:12px"> <script src="dropdown/year.js"> </script> </select>
	  </span>
  </div>
  <div class="line_contain" style='margin-left:3%;padding-bottom:60px'>
  <button name="confirmPickUp" type="submit" style="height:40px;display:inline-block"> Confirm Pick Up </button>
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
