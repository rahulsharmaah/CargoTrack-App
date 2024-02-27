<?php
include '../connection.php';

// Define the API endpoint
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $partyData = []; // Initialize an empty array to store party data
    
    // Query to fetch party data from the database
    $sql = "SELECT * FROM party_master";
    $result = mysqli_query($connection, $sql);
    
    // Fetch party data and add it to the array
    while ($row = mysqli_fetch_assoc($result)) {
        $partyData[] = $row;
    }
    
    // Return party data as JSON response
    header('Content-Type: application/json');
    echo json_encode($partyData);
} else {
    // Handle other HTTP methods as needed
    http_response_code(405); // Method Not Allowed
}
?>
