<?php
include '../connection.php';


$sqlQuery = "Select * FROM party_master ORDER BY party_name";
                                                                    
$resultOfQuery = $connectNow->query($sqlQuery);

if($resultOfQuery->num_rows > 0) 
{
    $partyLedgerRecord = array();
    while($rowFound = $resultOfQuery->fetch_assoc())
    {
        $partyLedgerRecord[] = $rowFound;
    }

    echo json_encode(
        array(
            "success"=>true,
            "partyLedgerData"=>$partyLedgerRecord,
        )
    );
}
else 
{
    echo json_encode(array("success"=>false));
}