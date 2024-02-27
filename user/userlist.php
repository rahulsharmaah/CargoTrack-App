<?php
include '../connection.php';


$sqlQuery = "Select * FROM users_table ORDER BY user_id";
                                                                    
$resultOfQuery = $connectNow->query($sqlQuery);

if($resultOfQuery->num_rows > 0) 
{
    $userLedgerRecord = array();
    while($rowFound = $resultOfQuery->fetch_assoc())
    {
        $userLedgerRecord[] = $rowFound;
    }

    echo json_encode(
        array(
            "success"=>true,
            "userNameData"=>$userLedgerRecord,
        )
    );
}
else 
{
    echo json_encode(array("success"=>false));
}