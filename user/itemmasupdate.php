<?php
include '../connection.php';

$itemId = $_POST['item_id']; // You should also receive the party ID to identify which record to update.
$itemName = $_POST['item_name'];
$itemActive = $_POST['item_active'];

// Update the existing record in the party_master table
$sqlQuery = "UPDATE item_master SET item_name = '$itemName', item_active = '$itemActive' WHERE item_id = $itemId";

$resultOfQuery = $connectNow->query($sqlQuery);

if ($resultOfQuery) {
    echo json_encode(array("success" => true));
} else {
    echo json_encode(array("success" => false));
}
?>
