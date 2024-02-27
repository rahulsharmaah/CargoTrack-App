<?php
include '../connection.php';

// Define the API endpoint
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    // Get the party ID from the request (replace 'party_id' with the actual parameter name)
    $partyId = $_GET['party_id'];
    
    $transactions = []; // Initialize an empty array to store transaction data
    
    // Query to fetch transactions for the specified party
    $sql = "SELECT * FROM transactions WHERE party_id = $partyId";
    $result = mysqli_query($connection, $sql);
    
    // Fetch transaction data and add it to the array
    while ($row = mysqli_fetch_assoc($result)) {
        $transactions[] = $row;
    }
    
    // Return transaction data as JSON response
    header('Content-Type: application/json');
    echo json_encode($transactions);
} else {
    // Handle other HTTP methods as needed
    http_response_code(405); // Method Not Allowed
}
?>