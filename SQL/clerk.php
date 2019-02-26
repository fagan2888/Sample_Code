<?php
session_start();
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
  <title> HomePage for Phase3 </title>
  <link rel="stylesheet" type="text/css" href="./main.css">
<?php
$pdo = new PDO("mysql:dbname=Tools4Rent", "root", "root");
$st = $pdo->query("select hire_date from Clerk where username = '$username'");
$temp = $st -> fetch();
$hiredate = $temp[0];
if (empty($hiredate)){
	echo "<style> #resetpassword {display:block;}; </style>";
}
?>

<script>
<?php
if ($reset)
	echo "alert('Successfully resetted password!');";
?>
</script>
</head>
<body>
  <header>
  <h3 class='T4R'> Tools-4-Rents! </h3>
    <ul>
	    <li class='smallfont'> <a href='pickup1.php'> Pick-Up </a></li>
	    <li class='smallfont'> <a href='dropoff1.php'> Drop-Off </a></li>
	    <li class='smallfont'> <a href='addtools.php' target='blank'> Add New Tool </a> </li>
	    <li class='smallfont'> Service Tool </li>
	    <li class='smallfont'> Service Status </li>
	    <li class='smallfont'> Sell Tool </li>
	    <li class='smallfont'> Sell Status </li>
	    <li class='smallfont'> <a onclick="document.getElementById('report').style.display='block';"> Report </a> </li>
    </ul>
	    <a href='./logout.php' class='Wel' style='font-size:1.5vw;'> Logout </a>
		
</header>

  <div class="MainMenuCus">
  <p> Main Menu </p>
  <table>
	  <tr><td> <a href='pickup1.php'>Pick-Up </a></td></tr>
	  <tr><td> <a href='dropoff1.php'>Drop-Off </a></td></tr>
	  <tr><td> <a href='addtools.php' target='blank'> Add New Tool </a></td></tr>
	  <tr><td> Service Tool </td></tr>
	  <tr><td> Service Status </td></tr>
	  <tr><td> Sell Tool </td></tr>
	  <tr><td> Sell Status </td></tr>
	  <tr><td> <a onclick="document.getElementById('report').style.display='block';"> Report </a> </td></tr>
	  <tr><td>  <a href='./logout.php' > Logout </a></td></tr> 
  </table>
  </div>

  <div id="report" class="modal">
	  <div class="MainMenuCus modal-content animate" style="width:80%; overflow:true; margin-left:5%;margin-top:5%;padding-bottom:20px">
		<span onclick="document.getElementById('report').style.display='none'" class="close" title="Close Modal">&times;</span>  
		<p> Select a Report </p>
		  <table>
		     <tr><td> <a href='clerk_report.php' target='blank'> Clerk Report </a></td></tr>
		     <tr><td> <a href='customer_report.php' target='blank'> Customer Report </a></td></tr>
		     <tr><td> <a href='toolinvent.php' target='blank'> Tool Inventory Report </a> </td></tr>
		  </table>
	  </div>
  </div>

  <div id="resetpassword" class="modal">
	<form action='./resetpassword.php' class="modal-content animate" method='post'>
		<span onclick="location.href='./logout.php';" class="close" title="Close Modal">&times;</span>
		<p style='padding:16px;font-size:2.1vw'> <b>Reset Password </b></p>
		<p style='padding:0 0 10px 21px;font-size:1.5vw'> Clerk First Login, need reset password</p>
		<div class="container">
			<label><b>New Password</b></label>
			<input type="password" placeholder="Enter Password" name="password" required>
		</div>
		<button name="submit" type="submit" style='margin:0 0 20px 20px;'>Confirm</button>	
	</form>
  </div>

<footer>
	<?php 
	echo ("<p style=\"padding-bottom:10px;padding-right:30px;color:white; float: right; size:1vw\"> <em> Welcome to <b> Tools-4-Rents </b>, Clerk $clerk_fullname! <em> </p>");
	?>
</footer>

</body>
</html>
