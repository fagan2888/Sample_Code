<?php
$st = $pdo->query("select power_source, sub_option, sub_type, purchase_price from Tool where tool_id = $value");
?>
