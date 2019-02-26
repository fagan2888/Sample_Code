<?php
	session_start();
	$tool_id = isset($_GET['tool_id'])?$_GET['tool_id']:'';
	try{
                $pdo = new PDO("mysql:dbname=Tools4Rent", "root", "root");
        }catch(PDOException $e){
                print $e->getMessage();
        }
	$st = $pdo->query("select power_source, sub_option, sub_type, purchase_price, width, length, manufacturer, type, weight, material from Tool where tool_id = $tool_id");
  	$temp = $st -> fetch();
  	$short_descript = ucfirst($temp[0]) . " ". ucfirst($temp[1]) ." ".ucfirst($temp[2]);
  	if (ucfirst($temp[0]) == 'Manual')
		$short_descript = ucfirst($temp[1]) ." ".ucfirst($temp[2]);
  	$rental_price = ceil(0.15 * $temp[3] *100)/100;
	$deposit_price = ceil(0.4 * $temp[3]*100)/100;
	// Bellow is the description for full descriptions
	$fraction = array('0','1/8','1/4','3/8',
			'1/2','5/8','3/4','7/8');
	$width_t = intval($temp[4] * 8);
	$width_t_i = intval($width_t / 8);
	$width_t_f = $width_t % 8;
	if ($width_t_f == 0)
		$width_exp = (string)$width_t_i;
	else
		$width_exp = (string)$width_t_i .'-'.$fraction[$width_t_f];
	
	$length_t = intval($temp[5] * 8);
	$length_t_i = intval($length_t / 8);
	$length_t_f = $length_t % 8;
	if ($length_t_f == 0)
		$length_exp = (string)$length_t_i;
        else
		$length_exp = (string)$length_t_i .'-'.$fraction[$length_t_f];	
	
	$full_description = $width_exp ." in. W x ". $length_exp ." in. L ";
	if (ucfirst($temp[0]) == 'Manual')
		$full_description = $full_description . " ". ucfirst($temp[1]) ." ".ucfirst($temp[2]);
	else if ((ucfirst($temp[0]) == 'AC') or (ucfirst($temp[0]) == 'Ac'))
		$full_description = $full_description . " ". "A/C electric ". ucfirst($temp[1]) ." ".ucfirst($temp[2]);
	else if ((ucfirst($temp[0]) == 'DC') or (ucfirst($temp[0]) == 'Dc'))
		$full_description = $full_description . " ". "D/C cordless ". ucfirst($temp[1]) ." ".ucfirst($temp[2]);
	else if (ucfirst($temp[0]) == 'Gaspower')
		$full_description = $full_description . " ". "Gaspower ". ucfirst($temp[1]) ." ".ucfirst($temp[2]);
	else
		echo "No powersource for".$temp[0];

	$full_description = $full_description ." ".round($temp[8],1).' Lbs ';
	if (!empty($temp[9]))
		$full_description = $full_description ." ".$temp[9];

	if ($temp[7] == 'Hand'){
		if ($temp[2] == 'Screwdriver'){
			$lq = $pdo->query("select * from Screwdriver where tool_id = $tool_id");
			$lq_temp = $lq -> fetch();
			$full_description = $full_description ." ScrewSize #".$lq_temp[1];
		}else if ($temp[2] == 'Socket'){
			$lq = $pdo->query("select * from Socket where tool_id = $tool_id");
			$lq_temp = $lq -> fetch();
			$full_description = $full_description ." DriverSize ".$fraction[intval(8*$lq_temp[1])].' inch';
			$full_description = $full_description ." SaeSize ".$fraction[intval(8*$lq_temp[2])].' inch';
			if (!empty($lq_temp[3]))
				$full_description = $full_description ." Deepsocket: ".$lq_temp[3];
		}else if ($temp[2] == 'Ratchet'){
			$lq = $pdo->query("select * from Ratchet where tool_id = $tool_id");
			$lq_temp = $lq -> fetch();
			$full_description = $full_description ." DriverSize ".$fraction[intval(8*$lq_temp[1])].' inch';
		}else if ($temp[2] == 'Wrench'){
		}else if ($temp[2] == 'Pliers'){
			$lq = $pdo->query("select * from Pliers where tool_id = $tool_id");
			$lq_temp = $lq -> fetch();
			if (!empty($lq_temp[1]))
				$full_description = $full_description ." Adjustable: ".$lq_temp[1];
		}else if ($temp[2] == 'Gun'){
			$lq = $pdo->query("select * from Gun where tool_id = $tool_id");
			$lq_temp = $lq -> fetch();
			$full_description = $full_description ." Gauga Rating ". $lq_temp[1].' gauge';
			if($lq_temp[2] != 0)
				$full_description = $full_description ." Capacity ".$lq_temp[2].' nails';
		}else if ($temp[2] == 'Hammer'){
			$lq = $pdo->query("select * from Hammer where tool_id = $tool_id");
			$lq_temp = $lq -> fetch();
			if(!empty($lq_temp[1]))
				$full_description = $full_description ." AntiVibration ".$lq_temp[1];
		}else
			echo "No subtype in Hand ".$temp[2];
	}else if ($temp[7] == 'Garden'){
		$lq = $pdo->query("select * from Garden where tool_id = $tool_id");
		$lq_temp = $lq -> fetch();
		$full_description = $full_description ." Handle Material ".$lq_temp[1];
		if ($temp[2] == 'Digger'){
			$lq = $pdo->query("select * from Digger where tool_id = $tool_id");
			$lq_temp = $lq -> fetch();
			if ($lq_temp[1] != 0){
				if ($lq_temp[1]-intval($lq_temp[1]) == 0)
					$full_description = $full_description . ' '. intval($lq_temp[1]).' Inch Blade Length';
				else
					$full_description = $full_description . ' '. intval($lq_temp[1]).'-'.
					$fraction[8*($lq_temp[1]-intval($lq_temp[1]))].' Inch Blade Length';
			}
			if ($lq_temp[2] != 0){
				if ($lq_temp[2]-intval($lq_temp[2]) == 0)
					$full_description = $full_description . ' '. intval($lq_temp[2]).' Inch Blade Width';
				else
					$full_description = $full_description . ' '. intval($lq_temp[2]).'-'.
					$fraction[8*($lq_temp[2]-intval($lq_temp[2]))].' Inch Blade Width';
			}
		}else if ($temp[2] == 'Pruner'){
			$lq = $pdo->query("select * from Pruner where tool_id = $tool_id");
			$lq_temp = $lq -> fetch();
			if (!empty($lq_temp[1]))
				$full_description = $full_description . ' Blade Material '.$lq_temp[1];
			if($lq_temp[2]-intval($lq_temp[2]) == 0)
				 $full_description = $full_description . ' '. intval($lq_temp[2]).' Inch Blade Length';
			else
				$full_description = $full_description . ' '. intval($lq_temp[2]).'-'. 
				$fraction[8*($lq_temp[2]-intval($lq_temp[2]))].' Inch Blade Length';
		}else if ($temp[2] == 'Rakes'){
			$lq = $pdo->query("select * from Rakes where tool_id = $tool_id");
			$lq_temp = $lq -> fetch();
			$full_description = $full_description . ' Tine Count '.$lq_temp[1];
		}else if ($temp[2] == 'Wheelbarrows'){
			$lq = $pdo->query("select * from Wheelbarrows where tool_id = $tool_id");
			$lq_temp = $lq -> fetch();
			$full_description = $full_description . ' Bin Material '.$lq_temp[1];
			$full_description = $full_description . ' Wheel Counts '.$lq_temp[3];
			if($lq_temp[1]!=0)
				$full_description = $full_description . ' Bin Volume '.$lq_temp[2].' cu ft';
		}else if ($temp[2] == 'Striking'){
			$lq = $pdo->query("select * from Striking where tool_id = $tool_id");
			$lq_temp = $lq -> fetch();
			$full_description = $full_description . ' Head Weight '.round($lq_temp[1],1).' pound';
		}else
			echo "No subtype in Garden ".$temp[2];
	}else if ($temp[7] == 'Ladder'){
                $lq = $pdo->query("select * from Ladder where tool_id = $tool_id");
                $lq_temp = $lq -> fetch();
		if ($lq_temp[1] != 0)
			$full_description = $full_description ." Step Count ". $lq_temp[1];
		if ($lq_temp[2] != 0)
			$full_description = $full_description ." Capacity ". $lq_temp[2].' pound';
		if ($temp[2] == 'Straight'){
			$lq = $pdo->query("select * from Straight where tool_id = $tool_id");
			$lq_temp = $lq -> fetch();
			if (!empty($lq_temp[1]))
				$full_description = $full_description ." Rubber Feet ". $lq_temp[1];
		}else if ($temp[2] == 'Step'){
			$lq = $pdo->query("select * from Step where tool_id = $tool_id");
			$lq_temp = $lq -> fetch();
			if (!empty($lq_temp[1]))
				$full_description = $full_description ." Pail Shelf ". $lq_temp[1];
		}else
			echo "No subtype in Ladder ".$temp[2];
	
	}else if ($temp[7] == 'Power'){
		$lq = $pdo->query("select * from Power where tool_id = $tool_id");
		$lq_temp = $lq -> fetch();
		$full_description = $full_description ." Volt Rating ". $lq_temp[1].'V';
		$full_description = $full_description ." Amp Rating ". $lq_temp[2].'RPM';
		$full_description = $full_description ." MinRpm Rating ". $lq_temp[3].'RPM';
		if ($lq_temp[4] != 0)
			$full_description = $full_description ." MaxRpm Rating ". $lq_temp[4].'RPM';
		if ($temp[2] == 'Drill'){
			$lq = $pdo->query("select * from Drill where tool_id = $tool_id");
			$lq_temp = $lq -> fetch();
			$full_description = $full_description ." Adjustable ". $lq_temp[1];
			$full_description = $full_description ." MinTorque Rating ". $lq_temp[2].' ft lb';
			if ($lq_temp[3] != 0)
				$full_description = $full_description ." MaxTorque Rating ". $lq_temp[3].' ft lb';
		}else if ($temp[2] == 'Saw'){
			$lq = $pdo->query("select * from Saw where tool_id = $tool_id");
			$lq_temp = $lq -> fetch();
			if ($lq_temp[1]-intval($lq_temp[1]) == 0)
				$full_description = $full_description . ' '. intval($lq_temp[1]).' Inch Blade Length';
			else
				$full_description = $full_description . ' '. intval($lq_temp[1]).'-'.
				$fraction[8*($lq_temp[1]-intval($lq_temp[1]))].' Inch Blade Length';
		}else if ($temp[2] == 'Sander'){
			$lq = $pdo->query("select * from Sander where tool_id = $tool_id");
			$lq_temp = $lq -> fetch();
			$full_description = $full_description . " Dust Bag ".$lq_temp[1];
		}else if ($temp[2] == 'AirCompressor'){
			$lq = $pdo->query("select * from AirCompressor where tool_id = $tool_id");
			$lq_temp = $lq -> fetch();
			$full_description = $full_description . " Tank Size ".$lq_temp[1].' Gallon';
			if ($lq_temp[2] != 0)
				$full_description = $full_description . " Power Rating ".round($lq_temp[2],1).' PSI';
		}else if ($temp[2] == 'Mixer'){
			$lq = $pdo->query("select * from Mixer where tool_id = $tool_id");
			$lq_temp = $lq -> fetch();
			if ($lq_temp[1]-intval($lq_temp[1]) == 0)
				$full_description = $full_description . ' '. intval($lq_temp[1]).' HP Motor Rating';
			else
				$full_description = $full_description . ' '. intval($lq_temp[1]).'-'.
				$fraction[8*($lq_temp[1]-intval($lq_temp[1]))].' HP Motor Rating';
			$full_description = $full_description . " Drum Size ".round($lq_temp[2],1).' cu ft';
		}else if ($temp[2] == 'Generator'){
			$lq = $pdo->query("select * from Generator where tool_id = $tool_id");
			$lq_temp = $lq -> fetch();
			$full_description = $full_description . " Power Rating ".round($lq_temp[1],1).' Watts';
		}else
			echo "No subtype in Power ".$temp[2];

		$acces = $pdo->query("select * from Pair where tool_id = $tool_id");
		$access_array = $acces->fetchAll();
	}else
		echo "No type for".$temp[7];	

	$full_description = $full_description . " By ".$temp[6];
?>

<html lang="en">
<head>
<style>
* {
        margin: 0;
        padding: 0;
        border: 0;
        font-family: 'Lato', sans-serif;
        overflow: auto;
}
</style>
</head>
<body style='background-color:rgb(217, 238, 247);'>
  <div style="height:100px;background-color:rgb(47,47,47);">
    <p style='color: white; font-size: 30px; font-weight: bold; padding: 25px;'> Tool Detail </p>
  </div>
  <div style='margin:30px 30px; '>
    <p style='font-size:20px'> <b> Tool ID: </b> </p>
    <p style='font-size:18px'> <?php echo "$tool_id"; ?> <br/> </p>
    <p style='font-size:20px; padding-top:10px'> <b> Tool Type: </b> </p>
     <p style='font-size:18px'> <?php echo "$temp[7]"." Tool"; ?> </p>
     <p style='font-size:20px; padding-top:10px'> <b> Short Description: </b> </p>
    <p style='font-size:18px'> <?php echo "$short_descript"; ?> </p>
     <p style='font-size:20px; padding-top:10px'> <b> Full Description: </b> </p>
   <p style='font-size:18px'> <?php echo "$full_description"; ?> </p>
    <p style='font-size:20px; padding-top:10px'> <b> Deposit Price: </b> </p>
    <p style='font-size:18px'> <?php echo sprintf("%.2f",$deposit_price); ?> </p>
   <p style='font-size:20px; padding-top:10px'> <b> Rental Price: </b> </p>
    <p style='font-size:18px'> <?php echo sprintf("%.2f",$rental_price); ?> </p>
 <?php
	if (count($access_array)>0){
		echo "<p style='font-size:20px; padding-top:10px'> <b> Accessories: </b> </p>";
		foreach ($access_array as $key => $row){
			$ind = $key + 1;
			echo "<p style='font-size:18px;padding-left:40px;'> $ind: ($row[1]) $row[2] </p>";
		}
	}

?>
 

</div>
</body>
</html>


