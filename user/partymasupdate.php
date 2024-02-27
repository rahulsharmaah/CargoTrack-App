<?php
include '../connection.php';

$partyId = $_POST['party_id']; // You should also receive the party ID to identify which record to update.
$partyName = $_POST['party_name'];
$partyOb = $_POST['party_ob'];
$partyActive = $_POST['party_active'];

// Update the existing record in the party_master table
$sqlQuery = "UPDATE party_master SET party_name = '$partyName', party_ob = '$partyOb', party_active = '$partyActive' WHERE party_id = $partyId";

$resultOfQuery = $connectNow->query($sqlQuery);

if ($resultOfQuery) {
    echo json_encode(array("success" => true));
} else {
    echo json_encode(array("success" => false));
}
?>
