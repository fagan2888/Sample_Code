<?php
	// Don't Forget to exit after header!! otherwise will continue process!
	session_start();
	try{
		$pdo = new PDO("mysql:dbname=Tools4Rent", "root", "root");
	}catch(PDOException $e){
		print $e->getMessage();
	}	

	$type  = htmlspecialchars($_POST['type']);	
	$powersource  = htmlspecialchars($_POST['powersource']);
	$subtype  = htmlspecialchars($_POST['subtype']);
	$subopt  = htmlspecialchars($_POST['subopt']);
	$puchase_price = htmlspecialchars($_POST['purchase']);
	$manufacturer = htmlspecialchars($_POST['manufacturer']);
	$material = htmlspecialchars($_POST['material']);
	$weight = htmlspecialchars($_POST['weight']);
	$unit =  htmlspecialchars($_POST['width_u']);
	if ($unit == 'Inch')
		$width = htmlspecialchars($_POST['width_num']) + htmlspecialchars($_POST['width_f']);
	else if ($unit == 'Feet')
		$width = (htmlspecialchars($_POST['width_num']) + htmlspecialchars($_POST['width_f']))*12;	
	else
		echo "Length Unit can only be feet or inch";

	$unit =  htmlspecialchars($_POST['height_u']);
	if ($unit == 'Inch')
		$height = htmlspecialchars($_POST['height_num']) + htmlspecialchars($_POST['height_f']);
	else if ($unit == 'Feet')
		$height = (htmlspecialchars($_POST['height_num']) + htmlspecialchars($_POST['height_f']))*12;
	else
		echo "Length Unit can only be feet or inch";


	$query = "INSERT INTO Tool(type, power_source, sub_type, sub_option, purchase_price, manufacturer, material, weight, width, length) 
	VALUES(?,?,?,?, ?,?,?,?,?,?)";
        $st = $pdo->prepare($query);
	$data = array("$type", "$powersource", "$subtype", "$subopt", $puchase_price, "$manufacturer", "$material", $weight, $width, $height);
	$st->execute($data);
        $res_id = $pdo->lastInsertId();		
	
	
	if ($type == 'Hand'){
		$query = "INSERT INTO Hand(tool_id) VALUES(?)";
		$st = $pdo->prepare($query);
		$st->execute(array($res_id));

		if ($subtype == 'Screwdriver'){
			$query = "INSERT INTO Screwdriver(tool_id, screw_size) VALUES(?,?)";
			$st = $pdo->prepare($query);
			$st->execute(array($res_id,htmlspecialchars($_POST['screwsize'])));
		}else if ($subtype == 'Socket'){
			$query = "INSERT INTO Socket(tool_id, drive_size, sae_size, deepsockect) VALUES(?,?,?,?)";
			$st = $pdo->prepare($query);
			$data = array($res_id,htmlspecialchars($_POST['driversize']),htmlspecialchars($_POST['saesize']),
					htmlspecialchars($_POST['deepsocket']));
			$st->execute($data);
		}else if ($subtype == 'Ratchet'){
			$query = "INSERT INTO Ratchet(tool_id, drive_size) VALUES(?,?)";
			$st = $pdo->prepare($query);
			$st->execute(array($res_id,htmlspecialchars($_POST['driversize'])));
		}else if ($subtype == 'Wrench'){
			$query = "INSERT INTO Wrench(tool_id) VALUES(?)";
			$st = $pdo->prepare($query);
			$st->execute(array($res_id));
		}else if ($subtype == 'Pliers'){
			$query = "INSERT INTO Pliers(tool_id, adjustable) VALUES(?,?)";
			$st = $pdo->prepare($query);
			$data = array($res_id, htmlspecialchars($_POST['adjustable']));
			$st->execute($data);
		}else if ($subtype == 'Gun'){
			$query = "INSERT INTO Gun(tool_id, gauge_rating, capacity) VALUES(?,?,?)";
			$st = $pdo->prepare($query);
			$st->execute(array($res_id, htmlspecialchars($_POST['gaugerating']), 
				htmlspecialchars($_POST['capacity'])));
		}else if ($subtype == 'Hammer'){
			$query = "INSERT INTO Hammer(tool_id, anti_vibration) VALUES(?,?)";
			$st = $pdo->prepare($query);
			$st->execute(array($res_id, htmlspecialchars($_POST['antivibration'])));
		}else{
			echo "<br/> No Hand Subtype $sutype";
		}

	} else if ($type == 'Garden'){
		$handlematerial =  htmlspecialchars($_POST['handlematerial']);
		$query = "INSERT INTO Garden(tool_id, handle_material) 
			VALUES(?,?)";
		$st = $pdo->prepare($query);
		$st->execute(array($res_id,"$handlematerial"));
		if ($subtype == 'Digger'){
			$query = "INSERT INTO Digger(tool_id, blade_width, blade_length) VALUES(?,?,?)";
			$st = $pdo->prepare($query);
			$data = array($res_id, htmlspecialchars($_POST['bladewidth'])+htmlspecialchars($_POST['bladewidth_f']),
				htmlspecialchars($_POST['bladelength'])+htmlspecialchars($_POST['bladelength_f']));
			$st->execute($data);
		}else if ($subtype == 'Pruner'){
			$query = "INSERT INTO Pruner(tool_id, blade_material, blade_length) VALUES(?,?,?)";
			$st = $pdo->prepare($query);
			$data = array($res_id, htmlspecialchars($_POST['bladematerial']),
			       	htmlspecialchars($_POST['bladelength'])+htmlspecialchars($_POST['bladelength_f']));
			$st->execute($data);
		}else if ($subtype == 'Rakes'){
			$query = "INSERT INTO Rakes(tool_id, tine_count) VALUES(?,?)";
			$st = $pdo->prepare($query);
			$st->execute(array($res_id, htmlspecialchars($_POST['tinecount'])));
		}else if ($subtype == 'Wheelbarrows'){
			$query = "INSERT INTO Wheelbarrows(tool_id, bin_material, bin_volume, wheel_count) VALUES(?,?,?,?)";
			$st = $pdo->prepare($query);
			$st->execute(array($res_id, htmlspecialchars($_POST['binmaterial']),
				htmlspecialchars($_POST['binvolume']), htmlspecialchars($_POST['wheelcount'])));
		}else if ($subtype == 'Striking'){
			$query = "INSERT INTO Striking(tool_id, head_weight) VALUES(?,?)";
			$st = $pdo->prepare($query);
			$st->execute(array($res_id, htmlspecialchars($_POST['headweight'])));
		}else {
			echo "<br/> No Garden Subtype $sutype";
		}

	} else if ($type == 'Power'){
		if ($powersource == 'DC')
			$voltrating = htmlspecialchars($_POST['dcvoltrating']);
		else
			$voltrating = htmlspecialchars($_POST['acvoltrating']);
	
		$amprating = (htmlspecialchars($_POST['amprating']))*htmlspecialchars($_POST['ampunit']);
		$minrpm = htmlspecialchars($_POST['minrpm']);
		$maxrpm = htmlspecialchars($_POST['maxrpm']);
		$query = "INSERT INTO Power(tool_id, volt_rating, amp_rating, min_rpm_rating, max_rpm_rating) VALUES(?,?,?,?,?)";
		$st = $pdo->prepare($query);
		$st->execute(array($res_id,$voltrating, $amprating, $minrpm, $maxrpm));
		if ($subtype == 'Drill'){
			$query = "INSERT INTO Drill(tool_id, adjustable, mintorque, maxtorque) 
				VALUES(?,?,?,?)";
			$st = $pdo->prepare($query);
			//print_r($st->errorInfo()); // Use this to debug
			$data = array($res_id, htmlspecialchars($_POST['adjustable']), 
			htmlspecialchars($_POST['mintorque']), htmlspecialchars($_POST['maxtorque']));
			$st->execute($data);
			//print_r($st->errorInfo()); // Use this to debug
		} else if ($subtype == 'Saw'){
			$query = "INSERT INTO Saw(tool_id, blade_size)
                                        VALUES(?,?)";
                        $st = $pdo->prepare($query);
                        $data = array($res_id, htmlspecialchars($_POST['bladesize']) + htmlspecialchars($_POST['bladesize_f']));
                        $st->execute($data);
		} else if ($subtype == 'Sander'){
			$query = "INSERT INTO Sander(tool_id, dust_bag)
				VALUES(?,?)";
			$st = $pdo->prepare($query);
			$data = array($res_id, htmlspecialchars($_POST['dustbag']));
			$st->execute($data);
		} else if ($subtype == 'AirCompressor'){
			$query = "INSERT INTO AirCompressor(tool_id, tank_size, pressure_rating)
                                VALUES(?,?,?)";
                        $st = $pdo->prepare($query);
                        $data = array($res_id, htmlspecialchars($_POST['tanksize']),
					htmlspecialchars($_POST['pressurerating']));
                        $st->execute($data);
		} else if ($subtype == 'Mixer'){
			$query = "INSERT INTO Mixer(tool_id, motor_rating, drum_size)
                                VALUES(?,?,?)";
                        $st = $pdo->prepare($query);
                        $data = array($res_id, htmlspecialchars($_POST['motorrating']) +
                        htmlspecialchars($_POST['motorrating_f']), htmlspecialchars($_POST['drumsize']));
                        $st->execute($data);
		} else if ($subtype == 'Generator'){
			$query = "INSERT INTO Generator(tool_id, power_rating)
                                VALUES(?,?)";
                        $st = $pdo->prepare($query);
                        $data = array($res_id, htmlspecialchars($_POST['powerrating']));
                        $st->execute($data);
		} else
			echo "<br/> No Power subtype $subtype";

		if (!empty($_POST['acce_descriptions1'])){
			$desc = htmlspecialchars($_POST['acce_descriptions1']);
			$sq = $pdo->query("select * from Accessory WHERE accessory_description='$desc'");
			$rows = $sq->fetchColumn();
			if (!$rows){
				$query = "INSERT INTO Accessory VALUES(?)";
				$st = $pdo->prepare($query);
				$st->execute(array($desc));
			}
			$data = array($res_id, htmlspecialchars($_POST['acce_quantities1']), "$desc");
			$query = "INSERT INTO Pair VALUES(?,?,?)";
			$st = $pdo->prepare($query);
			$st->execute($data);
		}

		if (!empty($_POST['acce_descriptions2'])){
			$desc = htmlspecialchars($_POST['acce_descriptions2']);
			$sq = $pdo->query("select * from Accessory WHERE accessory_description='$desc'");
			$rows = $sq->fetchColumn();
			if (!$rows){
				$query = "INSERT INTO Accessory VALUES(?)";
				$st = $pdo->prepare($query);
				$st->execute(array($desc));
			}
			$data = array($res_id, htmlspecialchars($_POST['acce_quantities2']), "$desc");
			$query = "INSERT INTO Pair VALUES(?,?,?)";
			$st = $pdo->prepare($query);
			$st->execute($data);
		}

		if (!empty($_POST['acce_descriptions3'])){
			$desc = htmlspecialchars($_POST['acce_descriptions3']);
			$sq = $pdo->query("select * from Accessory WHERE accessory_description='$desc'");
			$rows = $sq->fetchColumn();
			if (!$rows){
				$query = "INSERT INTO Accessory VALUES(?)";
				$st = $pdo->prepare($query);
				$st->execute(array($desc));
			}
			$data = array($res_id, htmlspecialchars($_POST['acce_quantities3']), "$desc");
			$query = "INSERT INTO Pair VALUES(?,?,?)";
			$st = $pdo->prepare($query);
			$st->execute($data);
		}

                if (!empty($_POST['acce_descriptions4'])){
                        $desc = htmlspecialchars($_POST['acce_descriptions4']);
                        $sq = $pdo->query("select * from Accessory WHERE accessory_description='$desc'");
                        $rows = $sq->fetchColumn();
                        if (!$rows){
                                $query = "INSERT INTO Accessory VALUES(?)";
                                $st = $pdo->prepare($query);
                                $st->execute(array($desc));
                        }
                        $data = array($res_id, htmlspecialchars($_POST['acce_quantities4']), "$desc");
                        $query = "INSERT INTO Pair VALUES(?,?,?)";
                        $st = $pdo->prepare($query);
                        $st->execute($data);
                }

		if ($powersource == 'DC'){
			$voltrating = htmlspecialchars($_POST['dcvoltrating']);
			$battery  = htmlspecialchars($_POST['batterytype']);
			$desc = $voltrating.'V '.$battery.' Battery';
                        $sq = $pdo->query("select * from Accessory WHERE accessory_description='$desc'");
                        $rows = $sq->fetchColumn();
                        if (!$rows){
                                $query = "INSERT INTO Accessory VALUES(?)";
                                $st = $pdo->prepare($query);
                                $st->execute(array($desc));
                        }
                        $data = array($res_id, htmlspecialchars($_POST['battery_quantities']), "$desc");
                        $query = "INSERT INTO Pair VALUES(?,?,?)";
                        $st = $pdo->prepare($query);
                        $st->execute($data);		
		}
	
	} else if ($type == 'Ladder'){
		$stepcount = htmlspecialchars($_POST['stepcount']);
		$weightcapacity = htmlspecialchars($_POST['weightcapacity']);
		$query = "INSERT INTO Ladder(tool_id, step_cout, weight_capacity) VALUES(?,?,?)";
		$st = $pdo->prepare($query);
		$st->execute(array($res_id,$stepcount,$weightcapacity));
		
		 if ($subtype == 'Straight'){
                        $query = "INSERT INTO Straight(tool_id, rubber_feet) VALUES(?,?)";
                        $st = $pdo->prepare($query);
                        $st->execute(array($res_id, htmlspecialchars($_POST['rubberfeet'])));
		 }else if ($subtype == 'Step'){
			 $query = "INSERT INTO Step(tool_id, pail_shelf) VALUES(?,?)";
			 $st = $pdo->prepare($query);
			 $st->execute(array($res_id, htmlspecialchars($_POST['pailshelf'])));
		 }else
			 echo "<br/> There is no Ladder $subtype";

	} else {
		echo "\n There is no type for $type";
	}

	header("Location: addtools.php?last_tool=".$res_id);
	exit();
?>
