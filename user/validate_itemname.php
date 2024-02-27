<?php

include '../connection.php';

$itemName = $_POST['item_name'];

$sqlQuery = "SELECT * FROM item_master WHERE item_name='$itemName'";

$resultOfQuery = $connectNow->query($sqlQuery);

if($resultOfQuery->num_rows > 0) 
{
    
    echo json_encode(array("itemNameFound"=>true));
}
else
{
   
    echo json_encode(array("itemNameFound"=>false));
}



