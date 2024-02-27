<?php
include '../connection.php';

// Calculate the "to" date (current date)
$toDate = date('Y-m-d'); // Format: YYYY-MM-DD

// Calculate the "from" date as 3 days before the current date
$fromDate = date('Y-m-d', strtotime('-7 days', strtotime($toDate))); // Format: YYYY-MM-DD

// Build the SQL query to fetch purchase records within the date range
$sqlQuery = "SELECT * FROM sale WHERE sale_date BETWEEN '$fromDate' AND '$toDate' ORDER BY sale_id DESC";

$resultOfQuery = $connectNow->query($sqlQuery);

if ($resultOfQuery->num_rows > 0) {
    $saleReportRecord = array();
    while ($rowFound = $resultOfQuery->fetch_assoc()) {
        $saleReportRecord[] = $rowFound;
    }

    echo json_encode(
        array(
            "success" => true,
            "saleReportData" => $saleReportRecord,
        )
    );
} else {
    echo json_encode(array("success" => false));
}
?>
