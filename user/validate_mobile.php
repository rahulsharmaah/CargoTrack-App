<?php

include '../connection.php';

$userMobile = $_POST['user_mobile'];

$sqlQuery = "SELECT * FROM users_table WHERE user_mobile='$userMobile'";

$resultOfQuery = $connectNow->query($sqlQuery);

if($resultOfQuery->num_rows > 0) 
{
    
    echo json_encode(array("mobileFound"=>true));
}
else
{
   
    echo json_encode(array("mobileFound"=>false));
}



