<?php
session_start();
$last_tool   = isset($_GET['last_tool'])?$_GET['last_tool']:"";
?>

<!DOCTYPE html>
<html lang="en">
<head>    
  <title> Add tools </title>
  <link rel="stylesheet" type="text/css" href="./main.css">	
  <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
  <script src='dropdown/addtool_ps_type.js'></script>
  <script>
<?php
  if (isset($_GET['last_tool'])) {
	  if ($last_tool)
		echo "alert('Successfully Add Tool with Tool ID '+$last_tool);";
	  else
		echo "alert('Add Tool Fail; Please Check Input');";

  }
?>
  </script>

</head>


<body>
  <header>
  <h3 class='T4R'> Tools-4-Rents! </h3>
  <a href='./logout.php' class='Wel' style='font-size:1.5vw;'> Logout </a>
  </header>

<form action="./addtools_db.php" method="post">
<div class="MainMenuCus" style="padding-bottom:10px">
  <p> Add Tools </p>
  <div class="line_contain">
	   <span class='inline_pos width_6'>
		   <p style='display:inline'> Type: </p>
		   <input required class='type' type="radio" name="type" value='Hand'> <label style="margin:0 1px"> Hand Tool </label>
		   <input class='type' type="radio" name="type" value='Garden'> <label style="margin:0 5px"> Gardon Tool </label>
		   <input class='type' type="radio" name="type" value='Ladder'> <label style="margin:0 5px"> Ladder </label>
		   <input class='type' type="radio" name="type" value='Power'> <label style="margin:0 5px"> Power Tool </label>
	   </span>
	   <span class='inline_pos width_3 right_align'>
		   <p> Powersource: </p>
		   <select required class='powersource' name='powersource' style='height:35px'> </select>
	   </span>
   </div>

   <div class="line_contain" >
   	<span class='inline_pos width_6'>
	<p> Subtype: </p>
	<select required class='subtype' name='subtype' style="height:35px"> </select>
	</span>
	<span class='inline_pos width_3 right_align'>
	<p> Subopt: </p>
	<select required class='subopt' name='subopt' style="height:35px;"> </select>
	</span>
  </div>
</div>

<div class="MainMenuCus" style="padding-bottom:10px;margin-top:-1.5%"> 
  <p> Tool Properties: </p>

  <div class="line_contain" >
   	<span class='inline_pos width_3 right_align'>
	<p> Purchase Price: </p>
	<input required class='user' type="number" min=0 step=0.01 placeholder="$100.00" name="purchase"> 
	</span>
	<span class='inline_pos width_3 right_align'>
	<p> Manufacturer: </p>
	<input required class='user' type="text" placeholder="Enter tool Manufacturer" name="manufacturer"> 
	</span>
  </div>

  <div class="line_contain" >
   	<span class='inline_pos width_3 right_align'>
	<p> Material: </p>
	<input class='user' type="text" placeholder="Material" name="material"> 
	</span>
	<span class='inline_pos width_3 right_align'>
	<p> Weight: </p>
	<input required class='user' type="number" min=0 step=0.01 placeholder="Lbs" name="weight">
	</span>
  </div>

  <div class="line_contain" >
	<span class='inline_pos width_3 right_align'>
	<p> Width: </p>
	<input required class='user' type="number" min=0 placeholder="Width" name="width_num"> 
	</span>
	<span class='inline_pos width_3 right_align'>
	<p> Fraction: </p>
	<select name='width_f' required> <script src='dropdown/fractions.js'> </script> </select>
	</span>
	<span class='inline_pos width_3 right_align'>
	<p> Unit: </p>
	<select name='width_u' required> <script src='dropdown/unit.js'> </script> </select>
	</span>
  </div>

  <div class="line_contain" >
	<span class='inline_pos width_3 right_align'>
	<p> Height: </p>
	<input required class='user' type="number" min=0 placeholder="Height" name="height_num"> 
	</span>
	<span class='inline_pos width_3 right_align'>
	<p> Fraction: </p>
	<select required name='height_f'> <script src='dropdown/fractions.js'> </script> </select>
	</span>
	<span class='inline_pos width_3 right_align'>
	<p> Unit: </p>
	<select required name='height_u'> <script src='dropdown/unit.js'> </script> </select>
	</span>
  </div>
</div>

  <div id='Power' class="MainMenuCus returned_div" style='margin-top:-1.5%;padding-bottom:20px'>
  <p>  Power Tools Only: </p>  

  <div class='NonCordless'>
  <div class="line_contain" >
	<span class='inline_pos width_3 right_align'>
	<p> A/C Volt-Rating: </p>
	<select required name='acvoltrating'> <script src='dropdown/voltrating.js'> </script> </select>
	</span>
  </div>
  </div>

  <div class='Cordless'>
	  <div class="line_contain" >
		<span class='inline_pos width_3 right_align'>
                <p> D/C Volt Rating: </p>
                <input required class='user' type="number" min=0 step=0.1 placeholder="7.2-80.0 Volts" name="dcvoltrating">
                </span>

		<span class='inline_pos width_3 right_align'> 
		<p> Battery-Type: </p>
		<select required name='batterytype'> 
		<script src='dropdown/batterytype.js'> </script> 
		</select>
		</span>

		<span class='inline_pos width_3 right_align'>
		<p> Quantity: </p>
		<input required class='user' type="number" min=0 placeholder="Quantities" name="battery_quantities">
		</span>
	  </div> 
  </div>

  <div class="line_contain">
        <span class='inline_pos width_3 right_align'>
        <p> AMP-Rating: </p>
        <input required class='user' type="number" min=0 step=0.1 placeholder="AMP-Rating" name="amprating">
	</span>
	<span class='inline_pos width_3 right_align'>
	<p> Unit: </p>
	<select required name='ampunit'> <script src='dropdown/ampunit.js'> </script> </select>
	</span>
  </div>

  <div class="line_contain" >
        <span class='inline_pos width_3 right_align'>
        <p> Min-rpm-rating: </p>
	<input required class='user' type="number" min=0 step=100 placeholder="Min Rpm Rating" name="minrpm">
	</span>
        <span class='inline_pos width_3 right_align'>
	<p> Max-rpm-rating: </p>
	<input class='user' type="number" min=0 step=100 placeholder="Max Rpm Rating" name="maxrpm">
	</span>
  </div>
  
  <div class="line_contain acce1" >
	<span class='inline_pos width_3 right_align'>
	<p> Accessory: </p>
	<input class='user' type="number" min=0 placeholder="Quantities" name="acce_quantities1">
	</span>
        <span class='inline_pos width_3 right_align'>
	<p> Descriptions: </p>
	<input class='user' type="text" placeholder="Descriptions" name="acce_descriptions1">
	</span>
	<span class='inline_pos width_3 left_align'>
	<button id="addacce2" type="button" style='padding:0 10px;margin:0 20px;height:35px;'> Add Accessories </button>	
	</span>
  </div> 
  
  <div class="line_contain acce2" >
	<span class='inline_pos width_3 right_align'>
	<p> Accessory: </p>
	<input class='user' type="number" min=0 placeholder="Quantities" name="acce_quantities2">
	</span>
        <span class='inline_pos width_3 right_align'>
	<p> Descriptions: </p>
	<input class='user' type="text" placeholder="Descriptions" name="acce_descriptions2">
	</span>
	<span class='inline_pos width_3 left_align'>
	<button id="addacce3" type="button" style='padding:0 10px;margin:0 20px;height:35px;'> Add Accessories </button>	
	</span>
  </div> 

  <div class="line_contain acce3" >
	<span class='inline_pos width_3 right_align'>
	<p> Accessory: </p>
	<input class='user' type="number" min=0 placeholder="Quantities" name="acce_quantities3">
	</span>
        <span class='inline_pos width_3 right_align'>
	<p> Descriptions: </p>
	<input class='user' type="text" placeholder="Descriptions" name="acce_descriptions3">
	</span>
	<span class='inline_pos width_3 left_align'>
	<button id="addacce4" type="button" style='padding:0 10px;margin:0 20px;height:35px;'> Add Accessories </button>	
	</span>

  </div> 

  <div class="line_contain acce4" >
	<span class='inline_pos width_3 right_align'>
	<p> Accessory: </p>
	<input class='user' type="number" min=0 placeholder="Quantities" name="acce_quantities4">
	</span>
        <span class='inline_pos width_3 right_align'>
	<p> Descriptions: </p>
	<input class='user' type="text" placeholder="Descriptions" name="acce_descriptions4">
	</span>
  </div> 


  


  <div class='Drill'>
	<div class='line_contain'>
		<span class='inline_pos width_3 right_align'>
		<p> Drill: </p>
		</span>
	
		<span class='inline_pos width_3 right_align'>
		<p> Min-torque: </p>
		<input required class='user' type="number" min=0 step=100 placeholder="Min Torque Rating" name="mintorque">
		</span>
		
		<span class='inline_pos width_3 right_align'>
		<p> Max-torque: </p>
		<input class='user' type="number" min=0 step=100 placeholder="Max Torque Rating" name="maxtorque">
		</span>
	</div>
	
	<div class='line_contain'>
		<span class='inline_pos width_3'> <p> </p></span>
		<span class='inline_pos width_3 right_align'>
		<p> Adjustable: </p>
		<select required name='adjustable'>
		<option value="" selected disabled> Adjustable-clutch? </option>
		<script src="dropdown/boolean.js"> </script>		
		</select> 
		</span>
	</div>
  </div>

  <div class='Saw'>
	<div class="line_contain" >
		<span class='inline_pos width_3 right_align'> <p> Saw: </p></span>
		<span class='inline_pos width_3 right_align'>
		<p> Blade Size: </p>
		<input required class='user' type="number" min=0 placeholder="Blade Size" name="bladesize">
		</span>
		<span class='inline_pos width_3 right_align'>
		<p> Size Fraction: </p>
		<select required name='bladesize_f'> 
		<script src='dropdown/fractions.js'> </script>
		</select>
		</span>
	 </div>
  </div>

  <div class='Sander'>
	<div class="line_contain" >
		<span class='inline_pos width_3 right_align'> <p> Sander: </p></span>
		<span class='inline_pos width_3 right_align'>
		<p> Dust-bag: </p>
		<select required name='dustbag'> 
		<option value="" selected disabled> Dust-Bag? </option>
                <script src="dropdown/boolean.js"> </script>
		</select>
		</span>
	 </div>
  </div>

  <div class='AirCompressor'>
	<div class="line_contain" >
		<span class='inline_pos width_3 right_align'> <p> Air-Compressor: </p></span>
		<span class='inline_pos width_3 right_align'>
		<p> Tank Size: </p>
		<input required class='user' type="number" min=0 placeholder="Tank Size" name="tanksize">
		</span>
		<span class='inline_pos width_3 right_align'>
		<p> Pressure: </p>
		<input class='user' type="number" min=0 step=0.1 placeholder="Pressure-Rating" name="pressurerating">
		</span>
	 </div>
  </div>

  <div class='Mixer'>
	<div class="line_contain" >
		<span class='inline_pos width_3 right_align'> <p> Mixer: </p></span>
		<span class='inline_pos width_3 right_align'>
		<p> Motor-Rating: </p>
		<input required class='user' type="number" min=0 placeholder="Motor Rating" name="motorrating">
		</span>
	        <span class='inline_pos width_3 right_align'>
                <p> Rating Fraction: </p>
                <select required name='motorrating_f'>
                <script src='dropdown/fractions.js'> </script>
                </select>
                </span> 
	</div>

	<div class="line_contain" >
		<span class='inline_pos width_3 right_align'> <p> </p></span>
		<span class='inline_pos width_3 right_align'>
		<p> Drum Size: </p>
		<input required class='user' type="number" min=0 step=0.1 placeholder="Drum Size" name="drumsize">
		</span>
	</div>
  </div>

  <div class='Generator'>
	<div class="line_contain" >
		<span class='inline_pos width_3 right_align'> <p> Generator: </p></span>
		<span class='inline_pos width_3 right_align'>
		<p> Power-Rating: </p>
		<input required class='user' type="number" min=0 step=0.1 placeholder="Power Rating" name="powerrating">
		</span>
	</div>
  </div>

  <button name="submit" type="submit" style='margin-left:3%'>Submit</button>
  </div>

  <div id='Hand' class="MainMenuCus returned_div" style='margin-top:-1.5%;padding-bottom:20px'>
  <p> Hands Tools Only:  </p>
  <div class='Screwdriver'>
	  <div class="line_contain" >
		<span class='inline_pos width_3 right_align'>
		<p> Screw-Driver: </p>
		</span>
		<span class='inline_pos width_3 right_align'>
		<p> Screw-Size: </p>
		<input required class='user' type="number" placeholder="#2 Screw-Size (Inch)" min=1 
		name="screwsize">
		</span>
	  </div>
  </div>

  <div class='Socket' style='overflow:auto;'>
	<div class='line_contain'>
		<span class='inline_pos width_3 right_align'>
		<p> Socket: </p>
		</span>
	
		<span class='inline_pos width_3 right_align'>
		<p> Driversize: </p>
		<select required name='driversize'> 
		<option value="" selected disabled> Select Driver Size</option>
		<script src="dropdown/driversize.js"> </script> </select>
		</span>
		
		<span class='inline_pos width_3 right_align'>
		<p> Sae Size: </p>
		<select required name='saesize'>
		<option value="" selected disabled> Select Sae Size</option> 
		<script src="dropdown/driversize.js"> </script> </select>
		</span>
	</div>
	
	<div class='line_contain'>
		<span class='inline_pos width_3'> <p> </p></span>
		<span class='inline_pos width_3 right_align'>
		<p> Deep Socket: </p>
		<select name='deepsocket'>
		<option value="" selected disabled> Deep Socket? </option>
		<script src="dropdown/boolean.js"> </script>		
		</select> 
		</span>
	</div>
  </div>

  <div class='Ratchet' style='overflow:visible;'>
	<div class='line_contain'>
		<span class='inline_pos width_3 right_align'>
		<p> Ratchet: </p>
		</span>
	
		<span class='inline_pos width_3 right_align'>
		<p> Driversize: </p>
		<select required name='driversize'> 
		<option value="" selected disabled> Select Driver Size</option>
		<script src="dropdown/driversize.js"> </script> </select>
		</span>
	</div>
  </div>

  <div class='Pliers' style='overflow:visible;'>
	<div class='line_contain'>
		<span class='inline_pos width_3 right_align'>
		<p> Plier: </p>
		</span>
                <span class='inline_pos width_3 right_align'>
                <p> Adjustable: </p>
                <select required name='adjustable'>
                <option value="" selected disabled> Adjustable? </option>
                <script src="dropdown/boolean.js"> </script>
                </select>
                </span>	
	</div>
  </div>

  <div class='Gun' style='overflow:visible;'>
	<div class='line_contain'>
		<span class='inline_pos width_3 right_align'>
		<p> Gun: </p>
		</span>
                <span class='inline_pos width_3 right_align'>
                <p> Gauge-Rating: </p>
                <select name='gaugerating'>
                <option value="" selected disabled> Select Gauge Rating </option>
                <script src="dropdown/gaugerating.js"> </script>
                </select>
		</span>
		<span class='inline_pos width_3 right_align'>
		<p> Capacity: </p>
		<input required class='user' type="number" placeholder="Capacity" name="capacity" min=10 step=10>	
		</span>
	</div>
  </div>

  <div class='Hammer' style='overflow:visible;'>
        <div class='line_contain'>
                <span class='inline_pos width_3 right_align'>
                <p> Hammer: </p>
                </span>
                <span class='inline_pos width_3 right_align'>
                <p> Anti-Vibration: </p>
                <select required name='antivibration'>
                <option value="" selected disabled> Anti-Vibration? </option>
                <script src="dropdown/boolean.js"> </script>
                </select>
                </span>
        </div>
  </div>

  <button name="submit" type="submit" style='margin-left:3%'>Submit</button>
  </div>

  <div id='Ladder' class="MainMenuCus returned_div" style='margin-top:-1.5%;padding-bottom:20px'>
  <p> Ladder Tools Only: </p>

  <div class="line_contain" >
	<span class='inline_pos width_3 right_align'>
	<p> Step Count: </p>
	<input class='user' type="number" min=0 placeholder="Step Count" name="stepcount">
	</span>
        <span class='inline_pos width_3 right_align'>
        <p> Capacity: </p>
        <input class='user' type="number" min=0 step=10 placeholder="Weight Capacity" name="weightcapacity">
        </span>
  </div>

  <div class='Straight'>
        <div class='line_contain'>
                <span class='inline_pos width_3 right_align'> <p> Straight: </p></span>
                <span class='inline_pos width_3 right_align'>
                <p> Rubber Feet: </p>
                <select name='rubberfeet'>
                <option value="" selected disabled> RubberFeet? </option>
                <script src="dropdown/boolean.js"> </script>
                </select>
                </span>
        </div>
  </div>

  <div class='Step'>
        <div class='line_contain'>
                <span class='inline_pos width_3 right_align'> <p> Step: </p></span>
                <span class='inline_pos width_3 right_align'>
                <p> Pail Shelf: </p>
                <select name='pailshelf'>
                <option value="" selected disabled> pailshelf? </option>
                <script src="dropdown/boolean.js"> </script>
                </select>
                </span>
        </div>
  </div>

  <button name="submit" type="submit" style='margin-left:3%'>Submit</button>
  </div>

  <div id='Garden' class="MainMenuCus returned_div" style='margin-top:-1.5%;padding-bottom:20px'>
  <p> Garden Tools Only: </p>
   <div class="line_contain" >
        <span class='inline_pos width_3 right_align'>
        <p> Handle-Material: </p>
        <input required class='user' type="text" placeholder="Handle Material" name="handlematerial">
        </span>
  </div> 

  <div class='Pruner'>
          <div class="line_contain" >
                <span class='inline_pos width_3 right_align'>
                <p> Pruning: </p>
                </span>
	        <span class='inline_pos width_3 right_align'>
        	<p> Blade-Material: </p>
        	<input class='user' type="text" placeholder="Blade Material" name="bladematerial">
        	</span>
	  </div>

	 <div class="line_contain" >
		<span class='inline_pos width_3 right_align'> <p> </p></span>
		<span class='inline_pos width_3 right_align'>
		<p> Blade Length: </p>
		<input required class='user' type="number" min=0 placeholder="Blade Length" name="bladelength">
		</span>
		<span class='inline_pos width_3 right_align'>
		<p> Length Fraction: </p>
		<select required name='bladelength_f'> 
		<script src='dropdown/fractions.js'> </script>
		</select>
		</span>
	 </div>
  </div>

  <div class='Striking'>
          <div class="line_contain" >
                <span class='inline_pos width_3 right_align'>
                <p> Striking: </p>
                </span>
	        <span class='inline_pos width_3 right_align'>
        	<p> Head Weight: </p>
		<input required class='user' type="number" placeholder="Head Weight" name="headweight"
		step=0.1 min=0>
        	</span>
	  </div>
  </div>

  <div class='Digger'>
         <div class="line_contain" >
                <span class='inline_pos width_3 right_align'> <p> Digging:</p></span>
                <span class='inline_pos width_3 right_align'>
                <p> Blade Width: </p>
                <input class='user' type="number" min=0 placeholder="Blade Width" name="bladewidth">
                </span>
                <span class='inline_pos width_3 right_align'>
                <p> Width Fraction: </p>
                <select name='bladewidth_f'>
                <script src='dropdown/fractions.js'> </script>
                </select>
                </span>
         </div>

         <div class="line_contain" >
                <span class='inline_pos width_3 right_align'> <p> </p></span>
                <span class='inline_pos width_3 right_align'>
                <p> Blade Length: </p>
                <input required class='user' type="number" min=0 placeholder="Blade Length" name="bladelength">
                </span>
                <span class='inline_pos width_3 right_align'>
                <p> Length Fraction: </p>
                <select required name='bladelength_f'>
                <script src='dropdown/fractions.js'> </script>
                </select>
                </span>
         </div>
  </div>

  <div class='Rakes'>
         <div class="line_contain" >
                <span class='inline_pos width_3 right_align'> <p> Rake: </p></span>
                <span class='inline_pos width_3 right_align'>
                <p> Tine Count: </p>
                <input required class='user' type="number" min=0 placeholder="Tine Count" name="tinecount">
                </span>
         </div>
  </div>

   <div class='Wheelbarrows'>
         <div class="line_contain" >
		<span class='inline_pos width_3 right_align'> <p> Wheelbarrow: </p></span>
		<span class='inline_pos width_3 right_align'>
		<p> Bin Material: </p>
		<input required class='user' type="text" placeholder="Bine Material" name="binmaterial">
		</span>
                <span class='inline_pos width_3 right_align'>
                <p> Bin Volume: </p>
                <input class='user' type="number" min=0 step=0.1 placeholder="Bin Volume" name="binvolume">
                </span>
	 </div>

	<div class="line_contain" >
		<span class='inline_pos width_3 right_align'> <p> </p></span>
		<span class='inline_pos width_3 right_align'>
                <p> Wheel-Count: </p>
                <input required class='user' type="number" min=1 placeholder="Wheel Count" name="wheelcount">
                </span>
	</div>
  </div>
  <button name="submit" type="submit" style='margin-left:3%'>Submit</button>
</div>
</form>

<footer>
	<?php 
	$name = ucfirst($_SESSION['login_user']);
	echo ("<p style=\"padding-bottom:10px;padding-right:30px;color:white; float: right; size:1vw\"> <em> Welcome to <b> Tools-4-Rents </b>, $name! <em> </p>");
	?>
</footer>
</body>
</html>
