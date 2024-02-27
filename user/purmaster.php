<?php
include '../connection.php';

date_default_timezone_set('Asia/Kolkata');
// Retrieve data from the HTTP POST request
$purchaseData = json_decode(file_get_contents('php://input'), true);

$purchaseDate = $purchaseData['purchase_date'];
$partyId = $_POST['party_id'];
$purchaseCustomer = $purchaseData['purchase_customer'];
$purchaseVehicleno = $purchaseData['purchase_vehicleno'];
$purchaseLgwt = $purchaseData['purchase_lgwt'];
$purchaseUgwt = $purchaseData['purchase_ugwt'];
$purchaseGross = $purchaseData['purchase_gross'];
$purchaseDust = $purchaseData['purchase_dust'];
$purchaseNtwt = $purchaseData['purchase_ntwt'];
$purchaseImno = $purchaseData['purchase_imno'];
$purchaseAdd = $purchaseData['purchase_add'];
$purchaseDed = $purchaseData['purchase_ded'];
$purchaseTotal = $purchaseData['purchase_total'];
$purchaseCreatedby = $purchaseData['purchase_createdby'];
$purchaseDt = $purchaseData['purchase_dt'];
$itemDetailsList = $purchaseData['item_details'];

// Insert purchase data into the 'purchase' table
$sqlQuery = "INSERT INTO purchase (purchase_date, , party_id, purchase_customer, purchase_vehicleno, purchase_lgwt, purchase_ugwt, purchase_gross, purchase_dust, purchase_ntwt, purchase_imno, purchase_add, purchase_ded, purchase_total, purchase_createdby, purchase_dt) VALUES ('$purchaseDate', '$partyId', '$purchaseCustomer', '$purchaseVehicleno', '$purchaseLgwt', '$purchaseUgwt', '$purchaseGross', '$purchaseDust', '$purchaseNtwt', '$purchaseImno', '$purchaseAdd', '$purchaseDed', '$purchaseTotal', '$purchaseCreatedby', '$purchaseDt')";

$resultOfQuery = $connectNow->query($sqlQuery);

if ($resultOfQuery) {
    $purchaseId = $connectNow->insert_id;

    // Insert item details into the 'puritems' table for the corresponding purchase ID
    foreach ($itemDetailsList as $item) {
        $itemName = $item['item_name'];
        $itemQty = $item['item_qty'];
        $itemRate = $item['item_rate'];
		

        $sqlItem = "INSERT INTO pitems (purchase_id, item_name, item_qty, item_rate) VALUES ('$purchaseId', '$itemName', '$itemQty', '$itemRate')";
        $resultItem = $connectNow->query($sqlItem);

        if (!$resultItem) {
            echo json_encode(array("success" => false, "error" => "Failed to insert item data."));
            exit;
        }
    }

    echo json_encode(array("success" => true, "purchase_id" => $purchaseId));
} else {
    echo json_encode(array("success" => false, "error" => "Failed to insert purchase data."));
}
?>
