<?php
include '../connection.php';


$sqlQuery = "Select * FROM cb_master ORDER BY cb_name";
                                                                    
$resultOfQuery = $connectNow->query($sqlQuery);

if($resultOfQuery->num_rows > 0) 
{
    $cbLedgerRecord = array();
    while($rowFound = $resultOfQuery->fetch_assoc())
    {
        $cbLedgerRecord[] = $rowFound;
    }

    echo json_encode(
        array(
            "success"=>true,
            "cbNameData"=>$cbLedgerRecord,
        )
    );
}
else 
{
    echo json_encode(array("success"=>false));
}