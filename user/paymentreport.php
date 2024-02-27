<?php
include '../connection.php';

// Calculate the "to" date (current date)
$toDate = date('d-m-Y'); // Format: YYYY-MM-DD

// Calculate the "from" date as 3 days before the current date
$fromDate = date('d-m-Y', strtotime('-3 days', strtotime($toDate))); // Format: YYYY-MM-DD

// Build the SQL query to fetch purchase records within the date range
$sqlQuery = "SELECT * FROM payment WHERE payment_date BETWEEN '$fromDate' AND '$toDate' ORDER BY payment_id DESC";

$resultOfQuery = $connectNow->query($sqlQuery);

if ($resultOfQuery->num_rows > 0) {
    $paymentReportRecord = array();
    while ($rowFound = $resultOfQuery->fetch_assoc()) {
        $paymentReportRecord[] = $rowFound;
    }

    echo json_encode(
        array(
            "success" => true,
            "paymentReportData" => $paymentReportRecord,
        )
    );
} else {
    echo json_encode(array("success" => false));
}
?>
