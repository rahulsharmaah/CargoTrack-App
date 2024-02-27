<?php
include '../connection.php';

$cbDate = $_POST['cb_date'];
$cbName = $_POST['cb_name'];
$cbOb = $_POST['cb_ob'];
$cbActive = $_POST['cb_active'];

$sqlQuery = "INSERT INTO cb_master SET cb_date= '$cbDate', cb_name= '$cbName', cb_ob= '$cbOb', cb_active= '$cbActive'";

$resultOfQuery = $connectNow->query($sqlQuery);

if($resultOfQuery)
{
    echo json_encode(array("success"=>true));
}
else
{
    echo json_encode(array("success"=>false));
}

