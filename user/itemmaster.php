<?php
include '../connection.php';

$itemName = $_POST['item_name'];
$itemActive = $_POST['item_active'];

$sqlQuery = "INSERT INTO item_master SET item_name= '$itemName', item_active= '$itemActive' ";

$resultOfQuery = $connectNow->query($sqlQuery);

if($resultOfQuery)
{
    echo json_encode(array("success"=>true));
}
else
{
    echo json_encode(array("success"=>false));
}

