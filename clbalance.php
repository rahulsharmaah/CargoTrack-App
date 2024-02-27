<?php
include '../connection.php';

// Function to retrieve sales for a party
function getSalesForParty($partyId, $connection) {
    // Implement logic to retrieve sales data for the specified party
    $query = "SELECT SUM(sales_total) as total_sales FROM sale WHERE sale_customerid = $partyId";
    $result = $connection->query($query);

    if ($result) {
        $row = $result->fetch_assoc();
        return $row['total_sales'] ?? 0.0;
    } else {
        return 0.0; // Handle query error
    }
}

// Function to retrieve receipts for a party
function getReceiptsForParty($partyId, $connection) {
    // Implement logic to retrieve receipt data for the specified party
    $query = "SELECT SUM(receipt_amount) as total_receipts FROM receipt WHERE receipt_customerid = $partyId";
    $result = $connection->query($query);

    if ($result) {
        $row = $result->fetch_assoc();
        return $row['total_receipts'] ?? 0.0;
    } else {
        return 0.0; // Handle query error
    }
}

// Function to retrieve purchases for a party
function getPurchasesForParty($partyId, $connection) {
    // Implement logic to retrieve purchase data for the specified party
    $query = "SELECT SUM(purchase_amount) as total_purchases FROM purchase WHERE purchase_customerid = $partyId";
    $result = $connection->query($query);

    if ($result) {
        $row = $result->fetch_assoc();
        return $row['total_purchases'] ?? 0.0;
    } else {
        return 0.0; // Handle query error
    }
}

// Function to retrieve payments for a party
function getPaymentsForParty($partyId, $connection) {
    // Implement logic to retrieve payment data for the specified party
    $query = "SELECT SUM(payment_amount) as total_payments FROM payments WHERE party_id = $partyId";
    $result = $connection->query($query);

    if ($result) {
        $row = $result->fetch_assoc();
        return $row['total_payments'] ?? 0.0;
    } else {
        return 0.0; // Handle query error
    }
}

// Function to calculate closing balance for a party
function calculateClosingBalance($partyId, $connection) {
    try {
        $sales = getSalesForParty($partyId, $connection);
        $receipts = getReceiptsForParty($partyId, $connection);
        $purchases = getPurchasesForParty($partyId, $connection);
        $payments = getPaymentsForParty($partyId, $connection);
        // Calculate closing balance
        $closingBalance = $sales - $receipts + $purchases - $payments;

        return $closingBalance;
    } catch (Exception $e) {
        // Handle errors, log or return default value
        return 0.0;
    }
}

// Function to get party ledgers
function getPartyLedgers($connection) {
    $getPartyLedgers = [];

    // Implement logic to retrieve party ledger data
    $query = "SELECT * FROM parties";
    $result = $connection->query($query);

    if ($result) {
        // Iterate over party records and calculate closing balance
        while ($eachRecord = $result->fetch_assoc()) {
            $partyId = $eachRecord["party_id"];
            $party = [
                "party_id" => $partyId,
                "party_name" => $eachRecord["party_name"],
                "party_ob" => $eachRecord["party_ob"],
                "closingBalance" => calculateClosingBalance($partyId, $connection),
            ];

            $getPartyLedgers[] = $party;
        }
    } else {
        // Handle query error
    }

    return $getPartyLedgers;
}

// Sample usage
$partyLedgers = getPartyLedgers($connection);
echo json_encode($partyLedgers);

// Close the database connection
$connection->close();

?>
