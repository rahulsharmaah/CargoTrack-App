<?php
include '../connection.php';

// Define the API endpoint
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Decode the JSON request body to get the required data
    $requestData = json_decode(file_get_contents('php://input'));
    
    // Extract data from the request (replace 'party_id' and other fields with actual field names)
    $partyId = $requestData->party_id;
    $openingBalance = $requestData->opening_ob;
    
    // Query to fetch sales, receipts, purchases, and payments for the specified party
    $sql = "SELECT SUM(sales_amount) AS total_sales, SUM(receipts_amount) AS total_receipts, SUM(purchases_amount) AS total_purchases, SUM(payments_amount) AS total_payments FROM transactions WHERE party_id = $partyId";
    
    $result = mysqli_query($connection, $sql);
    $row = mysqli_fetch_assoc($result);
    
    // Calculate daily balance
    $sales = $row['total_sales'];
    $receipts = $row['total_receipts'];
    $purchases = $row['total_purchases'];
    $payments = $row['total_payments'];
    
    $dailyBalance = $openingBalance + $sales + $receipts - $purchases - $payments;
    
    // Return daily balance as JSON response
    $response = ['daily_balance' => $dailyBalance];
    header('Content-Type: application/json');
    echo json_encode($response);
} else {
    // Handle other HTTP methods as needed
    http_response_code(405); // Method Not Allowed
}
?>
