<?php
// Function to calculate party balances
function calculatePartyBalances($paymentData, $receiptData, $saleData, $purchaseData) {
    $partyBalances = [];

    // Combine all data into a single array
    $allData = array_merge($paymentData, $receiptData, $saleData, $purchaseData);

    foreach ($allData as $entry) {
        $partyName = $entry['party']; // Assuming 'party' field links to party
        $date = $entry['date']; // Date field in your data
        $amount = $entry['amount'];

        $formattedDate = date('Y-m-d', strtotime($date));

        // Create or update the party balance for the specific date
        if (isset($partyName)) {
            if (!isset($partyBalances[$partyName])) {
                $partyBalances[$partyName] = [];
            }

            if (!isset($partyBalances[$partyName][$formattedDate])) {
                $partyBalances[$partyName][$formattedDate] = 0;
            }

            $partyBalances[$partyName][$formattedDate] += $amount;
        }
    }

    // Convert the party balances array to a list of objects
    $partyBalanceList = [];

    foreach ($partyBalances as $partyName => $balances) {
        foreach ($balances as $date => $balance) {
            $partyBalanceList[] = [
                'partyName' => $partyName,
                'date' => $date,
                'balance' => $balance,
            ];
        }
    }

    return $partyBalanceList;
}