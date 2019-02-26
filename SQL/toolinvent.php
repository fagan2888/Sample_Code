<?php
session_start();
$clerk_avail_tool = isset($_SESSION['clerk_avail_tool'])?$_SESSION['clerk_avail_tool']:"";
$clerk_rental_tool = isset($_SESSION['clerk_rental_tool'])?$_SESSION['clerk_rental_tool']:"";

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
  <title> HomePage for Phase3 </title>
  <link rel="stylesheet" type="text/css" href="./main.css">	
<?php
  if (isset($_SESSION['clerk_avail_tool']) or isset($_SESSION['clerk_rental_tool']))
	echo "<style> #returntool {display:block;} </style>";
  else
	echo "<style> #returntool {display:none;} </style>";
?>
</head>


<body>
  <header>
  <h3 class='T4R'> Tools-4-Rents! </h3>
  <a href='./logout.php' class='Wel' style='font-size:1.5vw;'> Logout </a>
  </header>

  <div class="MainMenuCus" style="padding-bottom:10px">
  <form action='./clerk_checktool.php' method='post'>
  <p> Tool Inventory Report </p>
  <div class="container" >
  <p style="margin-left:30px; padding-left:0;width:475px;display:inline-block;font-size:18px"> Type: </p>
  <p style="width:230px;display:inline-block;font-size:18px"> Customer Search: </p>
   <span style='display:block;margin-top:-2%'> </span>
   <input required class='type' type="radio" name="type" value='all' style="margin-left:30px;" > <label style="margin:0 5px" required> All Tools </label>
   <input class='type' type="radio" name="type" value='Hand'> <label style="margin:0 5px"> Hand Tool </label>
   <input class='type' type="radio" name="type" value='Garden'> <label style="margin:0 5px"> Gardon Tool </label>
   <input class='type' type="radio" name="type" value='Ladder'> <label style="margin:0 5px"> Ladder </label>
   <input class='type' type="radio" name="type" value='Power'> <label style="margin:0 5px"> Power Tool </label>
    <input type="text" placeholder="Keywords" name="keywords" style="width:250px;height:40px;margin-left:3.5%;padding-right:50px;">
    <button name="submit" type="submit" style="font-size:14px;border-radius: 0px;height:40px;margin-left:-50px"> Search </button>
  </div>
  </form>
  </div>
  
  <div id='returntool' class="MainMenuCus returned_div" style='margin-top:-1.5%'>
  <p style='padding-top:20px;margin-left:1%;font-size:2vw'> <b> Tools Inventory </b> </p>  
  <div class='container' style='margin-top:-1%'>
  <p style='width:5%;display:inline-block;font-size:1.5vw;text-align:center'> Tool</p>
  <p style='width:5%;display:inline-block;font-size:1.5vw;text-align:center'> Status </p>
  <p style='width:8%;display:inline-block;font-size:1.5vw;text-align:center'> Date </p>
  <p style='width:15%;display:inline-block;font-size:1.5vw;text-align:center'> Description </p>
  <p style='width:7%;display:inline-block;font-size:1.5vw;text-align:center'> Rental </p>
  <p style='width:8%;display:inline-block;font-size:1.5vw;text-align:center'> Total Cost</p>
  <p style='width:6%;display:inline-block;font-size:1.5vw;text-align:right'> Profit </p>
  </div>

  <?php
   $pdo = new PDO("mysql:dbname=Tools4Rent", "root", "root");
   foreach ($clerk_avail_tool as $key => $value){
	   $res = $pdo->query("
	    SELECT  Tool.power_source, Tool.sub_option, Tool.sub_type, Tool.purchase_price, 0.15*Tool.purchase_price AS rental_price, SUM(datediff(Reservation.end_date, Reservation.start_date)) AS reservation_days, SUM(datediff(Reservation.end_date, Reservation.start_date)) * 0.15*Tool.purchase_price AS rental_profit, SUM(datediff(Reservation.end_date, Reservation.start_date)) * 0.15*Tool.purchase_price - Tool.purchase_price AS total_profit 
	    FROM (ReservationTool INNER JOIN Tool on ReservationTool.tool_id = Tool.tool_id) INNER JOIN Reservation ON ReservationTool.reservation_id = Reservation.reservation_id 
	    WHERE Tool.tool_id=$value and Reservation.pickup_clerk IS NOT NULL
	    GROUP BY Tool.power_source, Tool.sub_option, Tool.sub_type, Tool.purchase_price	    
	   ");	   
	   $temp = $res -> fetch();
	   if ($temp){
	   $short_descript = ucfirst($temp[0]) . " ". ucfirst($temp[1]) ." ".ucfirst($temp[2]);
	   if (ucfirst($temp[0]) == 'Manual')
		   $short_descript = ucfirst($temp[1]) ." ".ucfirst($temp[2]);
	   $total_cost = number_format($temp[3],2,'.','');
	   $rental_price = $temp[4];
	   $total_res_days = $temp[5];
	   $total_rental_profit = sprintf("%.2f",$temp[6]);
	   $total_profit = sprintf("%.2f",$temp[7]);
	   }else{
		   $res = $pdo->query("SELECT  power_source, sub_option, sub_type, purchase_price FROM Tool WHERE tool_id=$value");
		   $temp = $res -> fetch();
		   $short_descript = ucfirst($temp[0]) . " ". ucfirst($temp[1]) ." ".ucfirst($temp[2]);
		   if (ucfirst($temp[0]) == 'Manual')
			   $short_descript = ucfirst($temp[1]) ." ".ucfirst($temp[2]);
		   $total_cost=round($temp[3],2);
		   $total_rental_profit=0;
		   $total_profit = -$total_cost;
	   }
	   echo "<div class='container' style='margin-top:-4%'>";
  	   echo "<p style='width:5%;display:inline-block;font-size:1.3vw;text-align:center'> $value </p>";
  	   echo "<p style='width:5%;display:inline-block;font-size:1.3vw;text-align:center'> available </p>";
  	   echo "<p style='width:8%;display:inline-block;font-size:1.3vw;text-align:center'>  </p>";
           echo "<p style='width:16%;display:inline-block;font-size:1.3vw;text-align:center'>
                   <a class='tool_detail'
                   href='tooldetail.php?tool_id=$value'
                   onclick=\"window.open(this.href, 'targetWindow','width=400px,height=500px'); return false;\">
                   $short_descript
                   </a></p>";   
	   echo "<p style='width:7%;display:inline-block;font-size:1.3vw;text-align:center'> $total_rental_profit </p>";
  	   echo "<p style='width:8%;display:inline-block;font-size:1.3vw;text-align:center'> $total_cost </p>";
  	   echo "<p style='width:7%;display:inline-block;font-size:1.3vw;text-align:right'> $total_profit </p>";
  	   echo "</div>";
   }
   
   foreach ($clerk_rental_tool as $key => $value){
	   $res = $pdo->query("
	    SELECT  Tool.power_source, Tool.sub_option, Tool.sub_type, Tool.purchase_price, 0.15*Tool.purchase_price AS rental_price, SUM(datediff(Reservation.end_date, Reservation.start_date)) AS reservation_days, SUM(datediff(Reservation.end_date, Reservation.start_date)) * 0.15*Tool.purchase_price AS rental_profit, SUM(datediff(Reservation.end_date, Reservation.start_date)) * 0.15*Tool.purchase_price - Tool.purchase_price AS total_profit 
	    FROM (ReservationTool INNER JOIN Tool on ReservationTool.tool_id = Tool.tool_id) INNER JOIN Reservation ON ReservationTool.reservation_id = Reservation.reservation_id 
	    WHERE Tool.tool_id=$value 
	    GROUP BY Tool.power_source, Tool.sub_option, Tool.sub_type, Tool.purchase_price	    
	   ");	   
	   $temp = $res -> fetch();
	   $short_descript = ucfirst($temp[0]) . " ". ucfirst($temp[1]) ." ".ucfirst($temp[2]);
	   if (ucfirst($temp[0]) == 'Manual')
		   $short_descript = ucfirst($temp[1]) ." ".ucfirst($temp[2]);
	   $total_cost = number_format($temp[3],2,'.','');
	   $rental_price = $temp[4];
	   $total_res_days = $temp[5];
	   $total_rental_profit = sprintf("%.2f",$temp[6]);
	   $total_profit = sprintf("%.2f",$temp[7]);
	   
	   $endd = $pdo->query("
		   SELECT  Reservation.start_date, Reservation.end_date
		   FROM (ReservationTool INNER JOIN Tool on ReservationTool.tool_id = Tool.tool_id) INNER JOIN Reservation ON ReservationTool.reservation_id = Reservation.reservation_id
		   WHERE Tool.tool_id=$value and ( Reservation.start_date <= CURRENT_DATE+1 and Reservation.end_date >= CURRENT_DATE-1)");
	   $temp = $endd -> fetch();
	   
	   echo "<div class='container' style='margin-top:-4%'>";
  	   echo "<p style='width:5%;display:inline-block;font-size:1.3vw;text-align:center'> $value </p>";
  	   echo "<p style='width:5%;display:inline-block;font-size:1.3vw;text-align:center'> rented </p>";
  	   echo "<p style='width:8%;display:inline-block;font-size:1.3vw;text-align:center'> $temp[1] </p>";
	   echo "<p style='width:16%;display:inline-block;font-size:1.3vw;text-align:center'> 
		   <a class='tool_detail' 
		   href='tooldetail.php?tool_id=$value'
		   onclick=\"window.open(this.href, 'targetWindow','width=400px,height=500px'); return false;\">
		   $short_descript 
		   </a></p>";
  	   echo "<p style='width:7%;display:inline-block;font-size:1.3vw;text-align:center'> $total_rental_profit </p>";
  	   echo "<p style='width:8%;display:inline-block;font-size:1.3vw;text-align:center'> $total_cost </p>";
  	   echo "<p style='width:7%;display:inline-block;font-size:1.3vw;text-align:right'> $total_profit </p>";
  	   echo "</div>";
   }
  ?>
  
<button type="button" style='font-size:1.5vw;padding:10px 10px;margin:30px auto 10px 20px;' >
<a href='clerk.php'> Return </a> </button>
<button type="button" style='font-size:1.5vw;padding:10px 10px;margin:30px auto 10px 10px;'>
<a href='toolinvent.php'> Reload </a></button>
</div>

<footer>
        <?php
        echo ("<p style=\"padding-bottom:10px;padding-right:30px;color:white; float: right; size:1vw\"> <em> Welcome to <b> Tools-4-Rents </b>, Clerk $clerk_fullname! <em> </p>");
        ?>
</footer>
</body>
</html>
