$(document).ready( () => {
	ps0 = '<option value="" disabled selected> Select Powersource </option>'
	$('.powersource').html(ps0);
	$('.powersource').attr('disabled','disabled');
	
	sub0 = '<option value="" disabled selected> Select Subtype </option>'
	$('.subtype').html(sub0);
	$('.subtype').attr('disabled','disabled');
	
	$('.type').on('change', event => {
		var type=$(event.currentTarget).parent().find('input[name=type]:checked').val();
		var ps;
		var ps1 = '<option value="all">All</option>';
		var ps2 = '<option value="manual">Manual</option>';
		var ps3 = '<option value="ac">A/C Electric</option>';
		var ps4 = '<option value="dc">D/C cordless</option>';
		var ps5 = '<option value="gaspower">Gas Powered</option>';
		if (type === "all"){
			ps=ps0+ps1+ps2+ps3+ps4+ps5;
		} else if (type === "Hand" || type === "Garden" || type === "Ladder") {
			ps=ps0+ps2;
		} else if (type === "Power") {
			ps=ps0+ps1+ps3+ps4+ps5;
		}
		$(event.currentTarget).parent().find('.subtype').attr('disabled','disabled');	
		$(event.currentTarget).parent().find('.powersource').html(ps);
		$(event.currentTarget).parent().find('.powersource').removeAttr('disabled');
	})

	$('.powersource').on('change', event => {
		var type=$(event.currentTarget).parent().find('input[name=type]:checked').val();
		var pows=$(event.currentTarget).val();
		//alert("Type "+type+' Pows '+pows);
		var sub;
		var sub1 = '<option value="all">All</option>';
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

		if (type === "all" && pows === "all")
			sub = sub0 + sub1 + sub2 + sub3 + sub4 + sub5 + sub6 + sub7 + sub8 + sub9 + sub10 + sub11 + sub12 + sub13 + sub14 + sub15 + sub16 + sub17 + sub18 + sub19 + sub20 + sub21;
		else if (type === "Hand")
			sub = sub0 + sub1 + sub2 + sub3 + sub4 + sub5 + sub6 + sub7 + sub8;
		else if (type === "Garden")
			sub = sub0 + sub1 + sub9 + sub10 + sub11 + sub12 + sub13;
		else if (type === "Ladder")
			sub = sub0 + sub1 + sub14 + sub15;
		else if (pows === "ac")
			sub = sub0 + sub1 + sub16 + sub17 + sub18 + sub19 + sub20;
		else if (pows === "dc")
			sub = sub0 + sub1 + sub16 + sub17 + sub18;
		else if (pows === 'gaspower')
			sub = sub0 + sub1 + sub19 + sub20 + sub21;
		else if (type === 'all' && pows === 'manual')
			sub = sub0 + sub1 + sub2 + sub3 + sub4 + sub5 + sub6 + sub7 + sub8 + sub9 + sub10 + sub11 + sub12 + sub13 + sub14 + sub15;
		else if (type === 'Power' && pows === 'all')
			sub = sub0 + sub1 + sub16 + sub17 + sub18 + sub19 + sub20 + sub21;
		else
			alert("Type "+type+' Pows '+pows);

		$(event.currentTarget).parent().find('.subtype').html(sub);
		$(event.currentTarget).parent().find('.subtype').removeAttr('disabled');
	})
});
