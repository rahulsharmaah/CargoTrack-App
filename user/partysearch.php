<?php
include '../connection.php';

$typedledgername = $_POST['typedledgername'];


$sqlQuery = "SELECT * FROM party_master WHERE party_name LIKE '%$typedledgername%'";

$resultOfQuery = $connectNow->query($sqlQuery);

if($resultOfQuery->num_rows > 0) //allow user to login 
{
    $foundPartyLedgerRecord = array();
    while($rowFound = $resultOfQuery->fetch_assoc())
    {
        $foundPartyLedgerRecord[] = $rowFound;
    }

    echo json_encode(
        array(
            "success"=>true,
            "partyFoundData"=>$foundPartyLedgerRecord[0],
        )
    );
}
else //Do NOT allow user to login 
{
    echo json_encode(array("success"=>false));
}
