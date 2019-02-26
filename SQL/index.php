<?php
session_start();
$login_error = isset($_GET['login_error'])?$_GET['login_error']:"";
$login_sucess = isset($_SESSION['login_sucess'])?$_SESSION['login_sucess']:'';
$register_error = isset($_GET['register_error'])?$_GET['register_error']:"";
$search_tool   = isset($_GET['search_tool'])?$_GET['search_tool']:"";
$reserve_tool = isset($_GET['reserve_tool'])?$_GET['reserve_tool']:"";
$res_sum  = isset($_GET['reserve_sum'])?$_GET['reserve_sum']:"";
$res_id = isset($_GET['res_id'])?$_GET['res_id']:"";

if (isset($_SESSION['login_user'])){
	$username=isset($_SESSION['login_user'])?$_SESSION['login_user']:"";
	$pdo = new PDO("mysql:dbname=Tools4Rent", "root", "root");
	$st = $pdo->query("select first_name, middle_name, last_name from Customer where username='$username'");
	$temp = $st -> fetch();
	$customer_id = $temp[0];
	if (empty($customer_id)){
		header("Location: ./logout.php");
		exit();
	}
	$clerk_fullname=ucfirst($temp[0]).' '.ucfirst($temp[1]).' '.ucfirst($temp[2]);
}
?>

<!DOCTYPE html>
<html lang="en">
<head>    
  <title> HomePage for Phase3 </title>
  <link rel="stylesheet" type="text/css" href="./main.css">
  <link rel="stylesheet" href="plugin_scripts/jquery-ui.css">
  <style>
input[type=number], input[type=email] {
    width: 100%;
    padding: 12px 20px;
    margin: 8px 0;
    display: inline-block;
    border: 1px solid #ccc;
    box-sizing: border-box;
}
  </style>
  <script src="plugin_scripts/jquery-1.12.4.js"></script>
  <script src="plugin_scripts/jquery-ui.js"></script>
  <script>
  $(function(){$(".datepicker").datepicker();});
  </script>
  <!-- If Login in with error, directly show login in form -->
<?php
  if ($login_error){
    echo "<style> #logintask {display:block;} </style>";
  };
  if ($register_error){
	echo "<style> #registertask {display:block;} </style>";
  };
  if ($search_tool){
	echo "<style> #checktooltask {display:block;}; </style>";
  };  
  if ($reserve_tool){
  	echo "<style> #reservationtask {display:block;}; </style>";
  };
  if ($res_sum){
	echo "<style> #ressum {display:block;}; </style>";
  };
?>
</head>
<body>
  <header>
    <h3 class='T4R'> Tools-4-Rents! </h3>
    <ul>
	    <li> <a onclick="document.getElementById('viewprofile').style.display='block';"> View Profile </a></li>
	    <li> <a onclick="document.getElementById('checktooltask').style.display='block';"> Check Tool Availability </a> </li>
	    <li> <a onclick="document.getElementById('reservationtask').style.display='block';"> Make Reservation </a></li>
	    <li> Purchase Tool </li>
    </ul>
    
    <!-- Only Submit Button and success show Logout Button, otherwise Login Button -->
    <?php
    	if ($login_sucess){
		echo ("<a href='./logout.php' class='Wel'> Logout </a>");
	}else{
		echo ("<a onclick=\"document.getElementById('logintask').style.display='block';\" class='Wel'> Login </a>");}
     ?>
  </header>

  <div class="MainMenuCus">
  <p> Main Menu </p>
  <table>
	  <tr><td><a onclick="document.getElementById('viewprofile').style.display='block';"> View Profile </a></td></tr>
	  <tr><td> <a onclick="document.getElementById('checktooltask').style.display='block';"> Check Tool Availability </a> </td></tr>
	  <tr><td> <a onclick="document.getElementById('reservationtask').style.display='block';"> Make Reservation </a> </td></tr>
	  <tr><td> Purchase Tool </td></tr>
	  <tr><td>  
	<?php 
	if ($login_sucess){
	    	echo ("<a href='./logout.php' class='Wel'> Logout </a>");
	    }else{
	        echo ("<a onclick=\"document.getElementById('logintask').style.display='block';\" class='Wel'> Login </a>");}
	?>
	  </td></tr> 
  </table>
  </div>


  <div id="logintask" class="modal">
  <form class="modal-content animate" action="./login.php" method="post">
		  <span onclick="document.getElementById('logintask').style.display='none'" class="close" title="Close Modal">&times;</span>
		  <p class='fontpadding'> <b>Login Form </b></p>
		  <div class="container">
			  <label><b>Username</b></label>
			  <label style="display:inline;float:right;"><a class='register' onclick="document.getElementById('logintask').style.display='none'; document.getElementById('registertask').style.display='block'"> Register Now </a></label>
			  <input type="text" placeholder="Enter Username" name="username" required>
			  <label><b>Password</b></label>
			  <input type="password" placeholder="Enter Password" name="password" required>
			  <input type="radio" name="group" value='Clerk'> <label> Clerk </label>
			  <input type="radio" name="group" value='Customer' checked="checked"> <label> Customer </label>
			  <br/>  
			
			<!--Show Error Message Here -->
			<span style="color:red; font-size:1.3vw; padding-top:4px; display:block;"><?php 
			if ($login_error){
				echo $login_error;
			}
			?></span> 
			<button name="submit" type="submit">Sign In</button>
			<button type="button" class='rightfloat' onclick="document.getElementById('logintask').style.display='none';">Cancel</button>
		  </div>
	  </form>
  </div>

  <div id="registertask" class="modal">
  <form class="modal-content animate" action="./register.php" method="post" style="width:60%; overflow:true;">
  	<span onclick="document.getElementById('registertask').style.display='none'" class="close" title="Close Modal">&times;</span>
	 <p style="padding-top:20px;margin-left:2%;font-size:1.5vw;"> <b> Customer Registration Form </b> </p>
	 <div class="container">
	 	<input type="text" placeholder="First Name" name="firstname" style="width:32%;margin-left:2%;" required>
		<input type="text" placeholder="Middle Name" name="middlename" style="width:32%;">
		<input type="text" placeholder="Last Name" name="lastname" style="width:32%;" required>
		<input type="text" placeholder="Home Phone (214-6624202x0000)" name="homephone" style="width:32%;margin-left:2%;" >
		<input type="text" placeholder="Work Phone (214-6624202x0000)" name="workphone" style="width:32%;">
		<input type="text" placeholder="Cell Phone (214-6624202x0000)" name="cellphone" style="width:32%;">
		<label style="margin-left:1%"> <b>Primary Phone </b></label>
		<input type="radio" name="phone" value='homephone' style="margin:15px 0" checked='checked'> <label style="margin:auto 5px"> Home Phone </label>
		<input type="radio" name="phone" value='workphone'> <label style="margin:auto 5px"> Work Phone </label>
		<input type="radio" name="phone" value='cellphone'> <label style="margin:auto 5px"> Cell Phone </label>
		<p style="display:block"> </p>
		<input type="email" placeholder="Email Address" name="email" style="margin-left:2%;width:97%;" required>
		<input type="password" placeholder="Password" name="password" style="margin-left:2%;width:48%;"  required>
		<input type="password" placeholder="Re-type Password" name="repassword" style="margin-left:1%;width:47.5%;" required>
		<input type="text" placeholder="Street Address" name="street" style="margin-left:2%;width:97%;" required>
		<input type="text" placeholder="City" name="city" style="width:32%;margin-left:2%;" required>
		<select class="select_style" style="width:32%; height:52px" name='state' required> <script src="dropdown/states.js"> </script> </select>
		<input type="number" placeholder="Zip Code" name="zip" style="width:32%" required>	
	</div>
	<p style="padding-top:20px;margin-left:2%;font-size:1.5vw;"> <b> Credit Card </b> </p>
	<div class="container">
		<input type="text" placeholder="Name on Credit Card" name="ccname" style="margin-left:2%;width:48%;" required>
		<input type="number" placeholder="Credit Card #" name="ccnumber" style="margin-left:1%;width:47.5%;" required>
		<select class="select_style" style="margin-left:2%;width:32%; height:52px; padding-left:12px" name='exp_month' required> <script src="dropdown/month.js"> </script> </select>
		<select class="select_style" style="width:32%; height:52px;padding-left:12px" name='exp_year' required> <script src="dropdown/year.js" > </script> </select>
		<input type="number" placeholder="CVC" name="cvc" style="width:32%" required>

		<p style="display:block"> </p>
		<span style="color:red; font-size:1.3vw; padding-top:4px; display:block;"><?php 
	    		if ($register_error){
				echo "$register_error";
			}
		?></span>
		<p style="display:block"> </p> 
		<button name="submit" type="submit" style="margin-left:1%;border-radius: 10px;width:auto"> Register </button>
		<button type="button" class='rightfloat' onclick="document.getElementById('registertask').style.display='none';" style="border-radius: 10px;width:auto">Cancel</button>
	</div>
  </form>
  </div>

  <div id="checktooltask" class="modal">
  <form class="modal-content animate" action="checktool.php" method="post" style="width:80%; overflow:true; margin: 5% auto 15% 5%;">
  <span onclick="document.getElementById('checktooltask').style.display='none'" class="close" title="Close Modal">&times;</span>
  <p style="padding-top:20px;margin-left:2%;font-size:2vw;margin-bottom:2%"> <b> Check Tool Availability </b> </p>
  <div class="container">
   <p style="margin-left:2%; width:30%;display:inline-block"> <b> Start Date: </b></p>
   <p style="width:30%;display:inline-block"> <b> End Date: </b></p>
   <p style="width:30%;display:inline-block"> <b> Customer Search: </b></p>
   <input type="text" placeholder="Start Date" class="datepicker" name="startdate" style="width:28%;height:40px;margin-left:2%;">
   <input type="text" placeholder="End Date" class="datepicker" name="enddate" style="width:28%;height:40px;margin-left:2%;">
   <input type="text" placeholder="Keywords" name="keywords" style="width:25%;height:40px;margin-left:2%;">
   <button name="submit" type="submit" style="border-radius: 0px;border:0;font-size:14px;margin-left:-3%;height:40px;display:inline-block"> Search </button> 
   <div style="display:block; padding-top:10px">  </div>
   <p style="margin-left:30px; width:475px;display:inline-block"> <b> Type: </b></p>
   <p style="width:180px;display:inline-block"> <b> Power Source: </b></p> 
   <p style="width:150px;display:inline-block"> <b> Sub-Type: </b></p>
   <div style="display:block; padding-top:10px">  </div>
   <input class='type' type="radio" name="type" value='all' style="margin-left:30px;" required> <label style="margin:auto 5px"> All </label>
   <input class='type' type="radio" name="type" value='Hand'> <label style="margin:auto 5px"> Hand Tool </label>
   <input class='type' type="radio" name="type" value='Garden'> <label style="margin:auto 5px"> Gardon Tool </label>
   <input class='type' type="radio" name="type" value='Ladder'> <label style="margin:auto 5px"> Ladder </label>
   <input class='type' type="radio" name="type" value='Power'> <label style="margin:auto 5px"> Power Tool </label>
   <select class='powersource' name='powersource' style="width:150px; height:35px;margin-left:30px" required> </select>
   <select class='subtype' name='subtype' style="width:150px; height:35px;margin-left:30px" required>  </select>
  </div>
  </form>
  <!-- Return Information -->
<?php
if ($search_tool){
  if ($search_tool == 1){
	 echo "
	<div class='modal-content animate'  style='width:80%; overflow:true; margin-left: 5%; margin-top: -14.8%'>
	<span style='color:red; font-size:2vw; padding:30px 15px; display:block;'>
	ERROR: {$_GET['search_error']} </span>
	</div>";
  }else{	  
  echo "<div class='modal-content animate'  style='width:80%; overflow:true; margin-left: 5%; margin-top: -14.8%'>"; 
  $array = $_SESSION['avail_tool'];
  echo "<p style='padding-top:20px;margin-left:2%;font-size:2vw;margin-bottom:2%'> <b> Available Tools For Rent </b> </p> ";
  echo "<div class='container'>";
  echo "<p style='margin-left:2%; width:13%;display:inline-block'> <b> Tool ID </b></p>";
  echo "<p style='width:35%;display:inline-block'> <b> Description </b></p>";
  echo "<p style='width:20%;display:inline-block'> <b> Rental Price </b></p>";
  echo "<p style='width:25%;display:inline-block'> <b> Deposit Price </b></p>";
  echo "</div>";
  $pdo = new PDO("mysql:dbname=Tools4Rent", "root", "root");
  foreach ($array as $key => $value){
	  //include "looptool.php";
	  $st = $pdo->query("select power_source, sub_option, sub_type, purchase_price from Tool where tool_id = $value");
	  $temp = $st -> fetch();
	  $short_descript = ucfirst($temp[0]) . " ". ucfirst($temp[1]) ." ".ucfirst($temp[2]);
	  if (ucfirst($temp[0]) == 'Manual')
		  $short_descript = ucfirst($temp[1]) ." ".ucfirst($temp[2]);
	  $rental_price = sprintf("%.2f",0.15 * $temp[3]);
	  $deposit_price = sprintf("%.2f", 0.4 * $temp[3]);
	  echo "<div class='container' style='padding:10px 16px;'>";
	  echo "<p style='margin-left:2%; width:13%;display:inline-block'>  $value </p>";
	  echo "<p style='width:35%;display:inline-block'> <a class='tool_detail' 
		  href='tooldetail.php?tool_id=$value' 
		  onclick=\"window.open(this.href, 'targetWindow','width=400px,height=500px'); return false;\"> $short_descript </a> </p>";
	  echo "<p style='width:20%;display:inline-block'> $rental_price </p>";
	  echo "<p style='width:25%;display:inline-block'> $deposit_price  </p>";
	  echo "</div>";
  }
  echo "<div class='container' style='padding:10px 16px;'> </div>";
  echo "</div>";
  }
}
?>
  </div>
<!-- Above is Check Tool Part -->

<div id="reservationtask" class="modal">
  <form class="modal-content animate" action="reservation.php" method="post" style="width:80%; overflow:true; margin: 5% auto 15% 5%;">
  <span onclick="document.getElementById('reservationtask').style.display='none'" class="close" title="Close Modal">&times;</span>
  <p style="padding-top:20px;margin-left:2%;font-size:2vw;margin-bottom:2%"> <b> Make Reservation </b> </p>
  <div class="container">
    <p style="margin-left:2%; width:30%;display:inline-block"> <b> Start Date: </b></p>
    <p style="width:30%;display:inline-block"> <b> End Date: </b></p>
    <p style="width:30%;display:inline-block"> <b> Customer Search: </b></p>
    <input required type="text" placeholder="Start Date" class="datepicker" name="startdate" style="width:28%;height:40px;margin-left:2%;">
    <input required type="text" placeholder="End Date" class="datepicker" name="enddate" style="width:28%;height:40px;margin-left:2%;">
     <input type="text" placeholder="Keywords" name="keywords" style="width:25%;height:40px;margin-left:2%;">
    <button name="submit" type="submit" style="border-radius: 0px;border:0;font-size:14px;margin-left:-3%;height:40px;display:inline-block"> Search </button>
    <div style="display:block; padding-top:10px">  </div>
    <p style="margin-left:30px; width:475px;display:inline-block"> <b> Type: </b></p>
    <p style="width:180px;display:inline-block"> <b> Power Source: </b></p>
    <p style="width:150px;display:inline-block"> <b> Sub-Type: </b></p>
    <div style="display:block; padding-top:10px">  </div>
    <input required class='type' type="radio" name="type" value='all' style="margin-left:30px;" > <label style="margin:auto 5px"> All </label>
    <input class='type' type="radio" name="type" value='Hand'> <label style="margin:auto 5px"> Hand Tool </label>
    <input class='type' type="radio" name="type" value='Garden'> <label style="margin:auto 5px"> Gardon Tool </label>
   <input class='type' type="radio" name="type" value='Ladder'> <label style="margin:auto 5px"> Ladder </label>
    <input class='type' type="radio" name="type" value='Power'> <label style="margin:auto 5px"> Power Tool </label>
    <select required class='powersource' name='powersource' style="width:150px; height:35px;margin-left:30px"> </select>
    <select required class='subtype' name='subtype' style="width:150px; height:35px;margin-left:30px">  </select>
  </div>
  </form>
<!-- Return Information -->
<?php
if ($reserve_tool){
	if ($reserve_tool == 1){
		echo "
			<div class='modal-content animate'  style='width:80%; overflow:true; margin-left: 5%; margin-top: -14.8%'>
			<span style='color:red; font-size:2vw; padding:30px 15px; display:block;'>
			ERROR: {$_GET['reserve_error']} </span>
			</div>";
	}else{
		echo "<div class='modal-content animate'  style='width:80%; overflow:true; margin-left: 5%; margin-top: -14.8%'>";
		$array = $_SESSION['avail_tool'];
		echo "<p style='padding-top:20px;margin-left:2%;font-size:2vw;margin-bottom:2%'> <b> Available Tools For Rent </b> </p> ";
		echo "<div class='container'>";
		echo "<p style='margin-left:2%; width:13%;display:inline-block'> <b> Tool ID </b></p>";
		echo "<p style='width:35%;display:inline-block'> <b> Description </b></p>";
		echo "<p style='width:20%;display:inline-block'> <b> Rental Price </b></p>";
		echo "<p style='width:20%;display:inline-block'> <b> Deposit Price </b></p>";
		echo "<p style='width:10%;display:inline-block'> <b> Add </b></p>";
		echo "</div>";
		$pdo = new PDO("mysql:dbname=Tools4Rent", "root", "root");
		foreach ($array as $key => $value){
			//include "looptool.php";
			$st = $pdo->query("select power_source, sub_option, sub_type, purchase_price from Tool where tool_id = $value");
			$temp = $st -> fetch();
			$short_descript = ucfirst($temp[0]) . " ". ucfirst($temp[1]) ." ".ucfirst($temp[2]);
			if (ucfirst($temp[0]) == 'Manual')
				$short_descript = ucfirst($temp[1]) ." ".ucfirst($temp[2]);
			$rental_price = sprintf("%.2f",0.15 * $temp[3]);
			$deposit_price = sprintf("%.2f",0.4 * $temp[3]);
			echo "<div class='container' style='padding:10px 16px;'>";
			echo "<p style='margin-left:2%; width:13%;display:inline-block'>  $value </p>";
			echo "<p style='width:35%;display:inline-block'> <a class='tool_detail'
				 href='tooldetail.php?tool_id=$value'
				 onclick=\"window.open(this.href, 'targetWindow','width=400px,height=500px'); return false;\"> $short_descript </a> </p>";
			echo "<p style='width:20%;display:inline-block'> $rental_price </p>";
			echo "<p style='width:20%;display:inline-block'> $deposit_price  </p>";
			echo "<input style='width:5%;display:inline-block' type='checkbox'  onclick=\"window.location='add.php?click_tool=$key';\" > ";
			echo "</div>";
		}
		echo "<div class='container' style='padding:10px 16px;'> </div>";
		echo "</div>";
	}
	echo "<div class='modal-content animate'  style='width:80%; overflow:true; margin-left: 5%; margin-top: -14.8%'>";
	$array = $_SESSION['rental_tool'];
	echo "<p style='padding-top:20px;margin-left:2%;font-size:2vw;margin-bottom:2%'> <b> Tools Added for Reservation </b> </p> ";
	echo "<div class='container'>";
	echo "<p style='margin-left:2%; width:13%;display:inline-block'> <b> Tool ID </b></p>";
	echo "<p style='width:35%;display:inline-block'> <b> Description </b></p>";
	echo "<p style='width:20%;display:inline-block'> <b> Rental Price </b></p>";
	echo "<p style='width:20%;display:inline-block'> <b> Deposit Price </b></p>";
	echo "<p style='width:10%;display:inline-block'> <b> Remove </b></p>";
	echo "</div>";
	$pdo = new PDO("mysql:dbname=Tools4Rent", "root", "root");
	foreach ($array as $key => $value){
		//include "looptool.php";
		$st = $pdo->query("select power_source, sub_option, sub_type, purchase_price from Tool where tool_id = $value");
		$temp = $st -> fetch();
		$short_descript = ucfirst($temp[0]) . " ". ucfirst($temp[1]) ." ".ucfirst($temp[2]);
		if (ucfirst($temp[0]) == 'Manual')
			$short_descript = ucfirst($temp[1]) ." ".ucfirst($temp[2]);
		$rental_price = sprintf("%.2f",0.15 * $temp[3]);
		$deposit_price = sprintf("%.2f", 0.4 * $temp[3]);
		echo "<div class='container' style='padding:10px 16px;'>";
		echo "<p style='margin-left:2%; width:13%;display:inline-block'>  $value </p>";
		echo "<p style='width:35%;display:inline-block'> <a class='tool_detail'
			href='tooldetail.php?tool_id=$value'
			onclick=\"window.open(this.href, 'targetWindow','width=400px,height=500px'); return false;\"> $short_descript </a> </p>";
		echo "<p style='width:20%;display:inline-block'> $rental_price </p>";
		echo "<p style='width:20%;display:inline-block'> $deposit_price  </p>";
		echo "<input style='width:5%;display:inline-block' type='checkbox'  onclick=\"window.location='remove.php?click_tool=$key';\" > ";
		echo "</div>";
	}
	echo "<div class='container' style='padding:10px 16px;'> </div>";
	if (count($array) <= 10)
		echo "<button type='button' style='float:left;margin:0 0 10px 10px;' onclick=\"window.location='res_sum.php';\"> Calculate All </button>";
	echo "</div>";
	
}
?>
</div>

<!-- Above is Make Reservation -->
<!-- Following is Reservation Summary -->
<div id="ressum" class="modal">
  <?php
    $array = $_SESSION['rental_tool'];
    try{
	$pdo = new PDO("mysql:dbname=Tools4Rent", "root", "root");
    }catch(PDOException $e){
        print $e->getMessage();
    }	
    $total_deposit = 0;
    $total_rental  = 0;
    $numdays = floor(($_SESSION['enddate'] - $_SESSION['startdate']) / (60 * 60 * 24)); 
    foreach ($array as $key => $value){
	//include "looptool.php";    
	$st = $pdo->query("select power_source, sub_option, sub_type, purchase_price from Tool where tool_id = $value");
        $temp = $st -> fetch();
        $rental_price = (0.15 * $temp[3])*$numdays;
        $deposit_price = 0.4 * $temp[3];
        $total_deposit += $deposit_price;
        $total_rental  += $rental_price;
    }
  ?>

<div class="modal-content animate" style="width:80%; overflow:true; margin: 5% auto 15% 5%;">
  <span onclick="document.getElementById('ressum').style.display='none'" class="close" title="Close Modal">&times;</span>
  <p style="padding-top:20px;margin-left:2%;font-size:2vw;margin-bottom:2%"> <b> Reservation Summary </b> </p>
<?php
  if ($res_id){
   echo "<p style='margin-left:3%;margin-bottom:10px;'> Reservation ID:";
   echo " $res_id </p>";
  }
?>

  <p style="margin-left:3%;margin-bottom:10px;"> Reservation Date:
  <?php $startdate = date("m/d/Y", $_SESSION['startdate']); 
        $enddate = date("m/d/Y", $_SESSION['enddate']);
	echo "$startdate - $enddate"?>
  </p>
  <p style="margin-left:3%;margin-bottom:10px;"> Number of Dates: 
  <?php $nd = floor(($_SESSION['enddate'] - $_SESSION['startdate']) / (60 * 60 * 24)); echo "$nd"; ?> 
  </p>
  <p style="margin-left:3%;margin-bottom:10px;"> Total Deposit Value:
  <?php echo sprintf("%.2f",$total_deposit); ?> </p>
  <p style="margin-left:3%;margin-bottom:10px;"> Total Rental Value:
  <?php echo sprintf("%.2f",$total_rental); ?> </p>
</div>
<?php
echo "<div class='modal-content animate'  style='width:80%; overflow:true; margin-left: 5%; margin-top: -14.8%'>";
$array = $_SESSION['rental_tool'];
echo "<p style='padding-top:20px;margin-left:2%;font-size:2vw;margin-bottom:2%'> <b> Tools </b> </p> ";
echo "<div class='container'>";
echo "<p style='margin-left:2%; width:13%;display:inline-block'> <b> Tool ID </b></p>";
echo "<p style='width:35%;display:inline-block'> <b> Description </b></p>";
echo "<p style='width:20%;display:inline-block'> <b> Rental Price </b></p>";
echo "<p style='width:20%;display:inline-block'> <b> Deposit Price </b></p>";
echo "</div>";
try{
	$pdo = new PDO("mysql:dbname=Tools4Rent", "root", "root");
}catch(PDOException $e){
	print $e->getMessage();
}
foreach ($array as $key => $value){
	//include "looptool.php";
	$st = $pdo->query("select power_source, sub_option, sub_type, purchase_price from Tool where tool_id = $value");
	$temp = $st -> fetch();
	$short_descript = ucfirst($temp[0]) . " ". ucfirst($temp[1]) ." ".ucfirst($temp[2]);
	if (ucfirst($temp[0]) == 'Manual')
		$short_descript = ucfirst($temp[1]) ." ".ucfirst($temp[2]);
	$rental_price = 0.15 * $temp[3] *$numdays;
	$deposit_price = 0.4 * $temp[3];
	echo "<div class='container' style='padding:10px 16px;'>";
	echo "<p style='margin-left:2%; width:13%;display:inline-block'>  $value </p>";
	echo "<p style='width:35%;display:inline-block'> <a class='tool_detail'
		href='tooldetail.php?tool_id=$value'
		onclick=\"window.open(this.href, 'targetWindow','width=400px,height=500px'); return false;\"> $short_descript </a> </p>";
	echo "<p style='width:20%;display:inline-block'> ". sprintf("%.2f",$rental_price)." </p>";
	echo "<p style='width:20%;display:inline-block'>".sprintf("%.2f", $deposit_price)." </p>";
	echo "</div>";
}
echo "<div class='container' style='padding:10px 16px;'>";
echo "<p style='margin-left:2%; width:13%;display:inline-block'> <b>Totals </b> </p>";
echo "<p style='width:35%;display:inline-block'> </p>";
echo "<p style='width:20%;display:inline-block'>". sprintf("%.2f",$total_rental) ."</p>";
echo "<p style='width:20%;display:inline-block'>". sprintf("%.2f",$total_deposit) ."</p>";
echo "</div>";
echo "<div class='container' style='padding:10px 16px;'> </div>";
if(!$res_id){
echo "<button type='button' style='float:left;margin:0 0 10px 10px;' onclick=\"window.location='res_conf.php';\"> Submit </button>";
echo "<button type='button' style='float:left;margin:0 0 10px 10px;' onclick=\"window.location='res_conf.php?reset=1';\"> Reset </button>";
}
echo "</div>"
?>
</div>

  <!-- View Profile Task -->
  <div id="viewprofile" class="modal">
      <div class="modal-content animate" style="width:80%; overflow:true; margin: 5% auto 15% 5%;">
          <span onclick="document.getElementById('viewprofile').style.display='none'" class="close" title="Close Modal">&times;</span>
          <?php
          if (!isset($_SESSION['login_user'])){
              echo "<p style=\"color:red;padding-top:20px;margin-left:2%;font-size:2vw;margin-bottom:2%\"> Please Login before View profile </p>";
          }else{
              echo "<p style=\"padding-top:20px;margin-left:2%;font-size:2vw;margin-bottom:2%\"> Customer Info </p>";
              try{
                  $pdo = new PDO("mysql:dbname=Tools4Rent", "root", "root");
              }catch(PDOException $e){
                  print $e->getMessage();
              }
	      $username = $_SESSION['login_user'];
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
	      if ($res[4]){
	      	echo "<p style='margin-left:3%;margin-bottom:10px;'> Home Phone: $homep </p>";
	      }
	      if ($res[6]){
	      	echo "<p style='margin-left:3%;margin-bottom:10px;'> Work Phone: $workp </p>";
	      }
	      if ($res[8]){
	      	echo "<p style='margin-left:3%;margin-bottom:10px;'> Cell Phone: $cellp </p>";
	      }	
	      echo "<p style='margin-left:3%;margin-bottom:10px;'> Address: $addr </p>";
	      echo "<div class='container' style='padding:10px 16px;'> </div>";
	  }
          ?>
      </div>
      
      <?php
        if ( isset($_SESSION['login_user']) ){
		echo "<div class='modal-content animate'  style='width:80%; overflow:true; margin-left: 5%; margin-top: -14.8%'>"; //Begin of Reservation part
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
		$username = $_SESSION['login_user'];
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
			echo "<p style='font-size:1.1vw;width:10%;display:inline-block;text-align:right;vertical-align:top;'> ". sprintf("%.2f",$total_dep) ."</p>";
			echo "<p style='font-size:1.1vw;width:10%;display:inline-block;text-align:right;vertical-align:top;'>". sprintf("%.2f", $total_ren) ."</p>";
			echo "</div>";
		}
		
		echo "<div class='container'> </div>";		
		echo "</div>"; // End of Reservation part
	
	}

      ?>

  </div>


<footer>
	<?php if ($login_sucess){
		echo ("<p style=\"padding-bottom:10px;padding-right:30px;color:white; float: right; size:1vw\"> <em> Welcome to <b> Tools-4-Rents </b>, Customer $clerk_fullname ! <em> </p>");
	}
	?>
</footer>
<script src='dropdown/reservation_ps_type.js'> </script>
</body>
</html>
