<?php

include '../connection.php';

$partyName = $_POST['party_name'];

$sqlQuery = "SELECT * FROM party_master WHERE party_name='$partyName'";

$resultOfQuery = $connectNow->query($sqlQuery);

if($resultOfQuery->num_rows > 0) 
{
    
    echo json_encode(array("partyNameFound"=>true));
}
else
{
   
    echo json_encode(array("partyNameFound"=>false));
}



