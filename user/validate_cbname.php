<?php

include '../connection.php';

$cbName = $_POST['cb_name'];

$sqlQuery = "SELECT * FROM cb_master WHERE cb_name='$cbName'";

$resultOfQuery = $connectNow->query($sqlQuery);

if($resultOfQuery->num_rows > 0) 
{
    
    echo json_encode(array("cashbankNameFound"=>true));
}
else
{
   
    echo json_encode(array("cashbankNameFound"=>false));
}



