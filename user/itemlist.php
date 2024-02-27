<?php
include '../connection.php';


$sqlQuery = "Select * FROM item_master ORDER BY item_name";
                                                                    
$resultOfQuery = $connectNow->query($sqlQuery);

if($resultOfQuery->num_rows > 0) 
{
    $itemLedgerRecord = array();
    while($rowFound = $resultOfQuery->fetch_assoc())
    {
        $itemLedgerRecord[] = $rowFound;
    }

    echo json_encode(
        array(
            "success"=>true,
            "itemNameData"=>$itemLedgerRecord,
        )
    );
}
else 
{
    echo json_encode(array("success"=>false));
}