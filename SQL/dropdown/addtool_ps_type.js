$(document).ready( () => {
	$('.acce2, .acce3, .acce4').hide();
	$('#addacce2').on('click', ()=>{ $('.acce2').show();});
	$('#addacce3').on('click', ()=>{ $('.acce3').show();});
	$('#addacce4').on('click', ()=>{ $('.acce4').show();});

	ps0 = '<option value="" disabled selected> Select Powersource </option>';
	$('.powersource').html(ps0);
	$('.powersource').attr('disabled','disabled');
	
	sub0 = '<option value="" disabled selected> Select Subtype </option>';
	$('.subtype').html(sub0);
	$('.subtype').attr('disabled','disabled');

	subopt0 = '<option value="" disabled selected> Select Suboption </option>';
	$('.subopt').html(subopt0);
	$('.subopt').attr('disabled','disabled');

	$('.type').on('change', event => {
		$('#Power, #Ladder, #Hand, #Garden').hide().find(':input').attr('disabled',true);
		var type=$('input[name=type]:checked').val();
		var ps;
		var ps2 = '<option value="manual">Manual</option>';
		var ps3 = '<option value="AC">A/C Electric</option>';
		var ps4 = '<option value="DC">D/C cordless</option>';
		var ps5 = '<option value="Gaspower">Gas Powered</option>';
		if (type === "Hand" || type === "Garden" || type === "Ladder") {
			ps=ps0+ps2;
		} else if (type === "Power") {
			ps=ps0+ps3+ps4+ps5;
		}
		$('.subtype').attr('disabled','disabled');
		$('.subopt').attr('disabled','disabled');
		$('.powersource').html(ps);
		$('.powersource').removeAttr('disabled');
	})

	$('.powersource').on('change', event => {
		$('#Power, #Ladder, #Hand, #Garden').hide().find(':input').attr('disabled',true);
		var type=$('input[name=type]:checked').val();
		var pows=$('.powersource').val();
		//alert("Type "+type+' Pows '+pows);
		var sub;
		var sub2 = '<option value="Screwdriver">Screwdriver</option>';
		var sub3 = '<option value="Socket">Socket</option>';
		var sub4 = '<option value="Ratchet">Ratchet</option>';
		var sub5 = '<option value="Wrench">Wrench</option>';
		var sub6 = '<option value="Pliers">Pliers</option>';
		var sub7 = '<option value="Gun">Gun</option>';
		var sub8 = '<option value="Hammer">Hammer</option>';
		var sub9 = '<option value="Digger">Digger</option>';
		var sub10 = '<option value="Pruner">Pruner</option>';
		var sub11 = '<option value="Rakes">Rakes</option>';
		var sub12 = '<option value="Wheelbarrows">Wheelbarrows</option>';
		var sub13 = '<option value="Striking">Striking</option>';
		var sub14 = '<option value="Straight">Straight</option>';
		var sub15 = '<option value="Step">Step</option>';
		var sub16 = '<option value="Drill">Drill</option>';
		var sub17 = '<option value="Saw">Saw</option>';
		var sub18 = '<option value="Sander">Sander</option>';
		var sub19 = '<option value="AirCompressor">Air-Compressor</option>';
		var sub20 = '<option value="Mixer">Mixer</option>';
		var sub21 = '<option value="Generator">Generator</option>';

		if (type === "Hand")
			sub = sub0 + sub2 + sub3 + sub4 + sub5 + sub6 + sub7 + sub8;
		else if (type === "Garden")
			sub = sub0 + sub9 + sub10 + sub11 + sub12 + sub13;
		else if (type === "Ladder")
			sub = sub0 + sub14 + sub15;
		else if (pows === "AC")
			sub = sub0 + sub16 + sub17 + sub18 + sub19 + sub20;
		else if (pows === "DC")
			sub = sub0 + sub16 + sub17 + sub18;
		else if (pows === 'Gaspower')
			sub = sub0 + sub19 + sub20 + sub21;
		else
			alert("Type "+type+' Pows '+pows);

		$('.subopt').attr('disabled','disabled');
		$('.subtype').html(sub);
		$('.subtype').removeAttr('disabled');
	})

	$('.subtype').on('change', event => {
		$('#Power, #Ladder, #Hand, #Garden').hide().find(':input').attr('disabled',true);
		var subtype = $('.subtype').val();
		var subopt = '<option value="" disabled selected> Select Suboption </option>';
		if (subtype === 'Screwdriver'){
			subopt += '<option value="philips">philips (cross)</option>';
			subopt += '<option value="hex">hex</option>';
		        subopt += '<option value="torx">torx</option>';	
			subopt += '<option value="slotted">slotted (flat)</option>';
		}else if (subtype === 'Socket'){
			subopt += '<option value="deep">deep</option>';
			subopt += '<option value="standard">standard</option>';
		}else if (subtype === 'Ratchet'){
			subopt += '<option value="adjustable">adjustable</option>';
			subopt += '<option value="fixed">fixed</option>';
		}else if (subtype === 'Wrench'){
			subopt += '<option value="cresent">crescent</option>';
			subopt += '<option value="torque">torque</option>';
			subopt += '<option value="pip">pip</option>';
		}else if (subtype === 'Pliers'){
			subopt += '<option value="needle">needle nose</option>';
			subopt += '<option value="cutting">cutting</option>';
			subopt += '<option value="crimper">crimper</option>';
		}else if (subtype === 'Gun'){
			subopt += '<option value="nail">nail</option>';
			subopt += '<option value="staple">staple</option>';	
		}else if (subtype === 'Hammer'){
			subopt += '<option value="claw">claw</option>';
			subopt += '<option value="sledge">sledge</option>';
			subopt += '<option value="framing">framing</option>';
		}else if (subtype === 'Digger'){
			subopt += '<option value="pointershovel">pointer shovel</option>';
			subopt += '<option value="faltshovel">flat shovel</option>';
			subopt += '<option value="scoopshovel">scoop shovel</option>';
			subopt += '<option value="edger">edger</option>';
		}else if (subtype === 'Pruner'){
			subopt += '<option value="sheer">sheer</option>';
			subopt += '<option value="loppers">loppers</option>';
			subopt += '<option value="hedge">hedge</option>';
		}else if (subtype === 'Rakes'){
			subopt += '<option value="leaf">leaf</option>';
			subopt += '<option value="landscaping">landscaping</option>';
			subopt += '<option value="rock">rock</option>';
		}else if (subtype === 'Wheelbarrows'){
			subopt += '<option value="1wheel">1-wheel</option>';
			subopt += '<option value="2wheel">2-wheel</option>';
		}else if (subtype === 'Striking'){
			subopt += '<option value="barpry">bar pry</option>';
			subopt += '<option value="rubber mallet">rubber mallet</option>';
			subopt += '<option value="tamper">tamper</option>';
			subopt += '<option value="pickaxe">pick axe</option>';
			subopt += '<option value="singlebitaxe">single bit axe</option>';
		}else if (subtype === 'Straight'){
			subopt += '<option value="rigid">rigid</option>';
			subopt += '<option value="telescoping">telescoping</option>';
		}else if (subtype === 'Step'){
			subopt += '<option value="folding">folding</option>';
			subopt += '<option value="multi-position">multi-position</option>';
		}else if (subtype === 'Drill'){
			subopt += '<option value="driver">driver</option>';
			subopt += '<option value="hammer">hammer</option>';
		}else if (subtype === 'Saw'){
			subopt += '<option value="circular">circular</option>';
			subopt += '<option value="reciprocating">reciprocating</option>';
			subopt += '<option value="jig">jig</option>';
		}else if (subtype === 'Sander'){
			subopt += '<option value="finish">finish</option>';
			subopt += '<option value="sheet">sheet</option>';
			subopt += '<option value="belt">belt</option>';
			subopt += '<option value="randomorbital">random orbital</option>';
		}else if (subtype === 'AirCompressor'){
			subopt += '<option value="reciprocating">reciprocating</option>';
		}else if (subtype === 'Mixer'){
			subopt += '<option value="concrete">concrete</option>';
		}else if (subtype === 'Generator'){
			subopt += '<option value="electric">electric</option>';
		}else
			alert("Error Subtype "+subtype);

		$('.subopt').html(subopt);	
		$('.subopt').removeAttr('disabled');
	});	

	$('.subopt').on('change', event => {
		var subopt = $('.subopt').val();
		var type=$('input[name=type]:checked').val();
		var subtype=$('.subtype').val();
		var pows=$('.powersource').val();
		if (type === 'Power'){		
			$('#Power').show().find(':input').attr('disabled',false);
			$('.NonCordless, .Cordless, .Drill, .Saw, .Sander, .AirCompressor, .Mixer, .Generator').hide().find(':input').attr('disabled',true);
			$('.'+subtype).show().find(':input').attr('disabled',false);
			if (pows === 'DC')
				$('.Cordless').show().find(':input').attr('disabled',false);
			else
				$('.NonCordless').show().find(':input').attr('disabled',false);
		}
		else if (type === 'Hand'){
			$('#Hand').show().find(':input').attr('disabled',false);
			$('.Screwdriver, .Socket, .Ratchet, .Pliers, .Gun, .Hammer').hide().find(':input').attr('disabled',true);
			$('.'+subtype).show().find(':input').attr('disabled',false);
		}
		else if (type === 'Garden'){
			$('#Garden').show().find(':input').attr('disabled',false);
			$('.Pruner, .Striking, .Digger, .Rakes, .Wheelbarrows').hide().find(':input').attr('disabled',true);
			$('.'+subtype).show().find(':input').attr('disabled',false);
		}
		else if (type === 'Ladder'){
			$('#Ladder').show().find(':input').attr('disabled',false);
			$('.Straight, .Step').hide().find(':input').attr('disabled',true);
			$('.'+subtype).show().find(':input').attr('disabled',false);
		}
		else
			alert('No type for '+type);

	})
});
