<?php
include '../connection.php';

$receiptDate = $_POST['receipt_date'];
$receiptLedger = $_POST['receipt_ledger'];
$receiptCb = $_POST['receipt_cb'];
$receiptCustomerid = $_POST['receipt_customerid'];
$receiptCustomer = $_POST['receipt_customer'];
$receiptAmount = $_POST['receipt_amount'];
$receiptNotes = $_POST['receipt_notes'];
$receiptCreatedby = $_POST['receipt_createdby'];
$receiptDt = $_POST['receipt_dt'];

// Calculate the new Cash/Bank Opening Balance (cb_ob)
$sqlSelectCbOb = "SELECT cb_ob FROM cb_master WHERE cb_name = '$receiptCb'";
$resultSelectCbOb = $connectNow->query($sqlSelectCbOb);

if ($resultSelectCbOb) {
    $row = $resultSelectCbOb->fetch_assoc();
    $currentCbOb = $row['cb_ob'];
    
    // Calculate the new cb_ob value by adding the receipt amount
    $newCbOb = $currentCbOb + $receiptAmount;
    
    // Update the cb_ob value in the cb_master table
    $sqlUpdateCbOb = "UPDATE cb_master SET cb_ob = $newCbOb WHERE cb_name = '$receiptCb'";
    $resultUpdateCbOb = $connectNow->query($sqlUpdateCbOb);

    if ($resultUpdateCbOb) {
        // Insert receipt data
        $sqlQuery = "INSERT INTO receipt SET receipt_date = '$receiptDate', receipt_ledger = '$receiptLedger', receipt_cb = '$receiptCb', receipt_customerid = '$receiptCustomerid', receipt_customer = '$receiptCustomer', receipt_amount = '$receiptAmount', receipt_notes = '$receiptNotes', receipt_createdby = '$receiptCreatedby', receipt_dt = '$receiptDt'";
        $resultOfQuery = $connectNow->query($sqlQuery);

        if ($resultOfQuery) {
            echo json_encode(array("success" => true));
        } else {
            echo json_encode(array("success" => false, "message" => "Failed to insert receipt data."));
        }
    } else {
        echo json_encode(array("success" => false, "message" => "Failed to update cb_ob value."));
    }
} else {
    echo json_encode(array("success" => false, "message" => "Failed to retrieve current cb_ob value."));
}
?>
