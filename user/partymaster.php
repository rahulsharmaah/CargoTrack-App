<?php
include '../connection.php';

$partyName = $_POST['party_name'];
$partyOb = $_POST['party_ob'];
$partyActive = $_POST['party_active'];

$sqlQuery = "INSERT INTO party_master SET party_name= '$partyName', party_ob= '$partyOb', party_active= '$partyActive' ";

$resultOfQuery = $connectNow->query($sqlQuery);

if($resultOfQuery)
{
    echo json_encode(array("success"=>true));
}
else
{
    echo json_encode(array("success"=>false));
}
