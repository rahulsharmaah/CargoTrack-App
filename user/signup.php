<?php
include '../connection.php';

$userName = $_POST['user_name'];
$userMobile = $_POST['user_mobile'];
$userPassword = $_POST['user_password'];
$userLevel = $_POST['user_level']; 

$sqlQuery = "INSERT INTO users_table SET user_name = '$userName', user_mobile = '$userMobile', user_password = '$userPassword', user_level = '$userLevel'";

$resultOfQuery = $connectNow->query($sqlQuery);

if($resultOfQuery)
{
    echo json_encode(array("success"=>true));
}
else
{
    echo json_encode(array("success"=>false));
}

