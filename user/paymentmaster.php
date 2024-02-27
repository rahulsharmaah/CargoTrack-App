<?php
include '../connection.php';

$paymentDate = $_POST['payment_date'];
$paymentLedger = $_POST['payment_ledger'];
$paymentCb = $_POST['payment_cb'];
$paymentCustomerid = $_POST['payment_customerid'];
$paymentCustomer = $_POST['payment_customer'];
$paymentAmount = $_POST['payment_amount'];
$paymentRef = $_POST['payment_ref'];
$paymentNotes = $_POST['payment_notes'];
$paymentCreatedby = $_POST['payment_createdby'];
$paymentDt = $_POST['payment_dt'];

$sqlQuery = "INSERT INTO payment SET payment_date= '$paymentDate', payment_ledger= '$paymentLedger', payment_cb= '$paymentCb', party_id = '$partyId', payment_customerid = '$paymentCustomerid', payment_customer= '$paymentCustomer', payment_amount= '$paymentAmount',  payment_ref= '$paymentRef', payment_notes= '$paymentNotes', payment_createdby= '$paymentCreatedby', payment_dt= '$paymentDt'";

$resultOfQuery = $connectNow->query($sqlQuery);

if($resultOfQuery)
{
    echo json_encode(array("success"=>true));
}
else
{
    echo json_encode(array("success"=>false));
}
