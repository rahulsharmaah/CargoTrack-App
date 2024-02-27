<?php
include '../connection.php';

//date_default_timezone_set('Asia/Kolkata');
// Retrieve data from the HTTP POST request
$saleData = json_decode(file_get_contents('php://input'), true);

$saleDate = $saleData['sale_date'];
$saleCustomerid = $saleData['sale_customerid'];
$saleCustomer = $saleData['sale_customer'];
$saleVehicleno = $saleData['sale_vehicleno'];
$saleLgwt = $saleData['sale_lgwt'];
$saleUgwt = $saleData['sale_ugwt'];
$saleNtwt = $saleData['sale_ntwt'];
$saleImno = $saleData['sale_imno'];
$saleAdd = $saleData['sale_add'];
$saleDed = $saleData['sale_ded'];
$saleTotal = $saleData['sale_total'];
$saleCreatedby = $saleData['sale_createdby'];
$saleDt = $saleData['sale_dt'];
$itemDetailsList = $saleData['item_details'];

$sqlQuery = "INSERT INTO sale (sale_date, sale_customerid, sale_customer, sale_vehicleno, sale_lgwt, sale_ugwt, sale_ntwt, sale_imno, sale_add, sale_ded, sale_total, sale_createdby, sale_dt) VALUES ('$saleDate', '$saleCustomerid' '$saleCustomer', '$saleVehicleno', '$saleLgwt', '$saleUgwt', '$saleNtwt', '$saleImno', '$saleAdd', '$saleDed', '$saleTotal', '$saleCreatedby', '$saleDt')";

$resultOfQuery = $connectNow->query($sqlQuery);

if ($resultOfQuery) {
    $saleId = $connectNow->insert_id;

    foreach ($itemDetailsList as $item) {
        $itemName = $item['item_name'];
        $itemQty = $item['item_qty'];
        $itemRate = $item['item_rate'];

        $sqlItem = "INSERT INTO sitems (sale_id, item_name, item_qty, item_rate) VALUES ('$saleId', '$itemName', '$itemQty', '$itemRate')";
        $resultItem = $connectNow->query($sqlItem);

        if (!$resultItem) {
            echo json_encode(array("success" => false, "error" => "Failed to insert item data."));
            exit;
        }
    }

    echo json_encode(array("success" => true, "sale_id" => $saleId));
} else {
    echo json_encode(array("success" => false, "error" => "Failed to insert sale data."));
}
?>
