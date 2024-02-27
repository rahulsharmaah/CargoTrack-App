class API {
  static const hostConnect = "https://ksvaidh.srvc.in";
  static const hostConnectUser = "$hostConnect/user";

  static const validateMobile = "$hostConnectUser/validate_mobile.php";
  static const signup = "$hostConnectUser/signup.php";
  static const login = "$hostConnectUser/login.php";
  static const userSearch = "$hostConnectUser/userlist.php";

  static const validatePartyName = "$hostConnectUser/validate_partyname.php";
  static const pmCreate = "$hostConnectUser/partymaster.php";
  static const pmUpdate = "$hostConnectUser/partymasupdate.php";
  static const searchPartyLedger = "$hostConnectUser/partysearch.php";
  static const pLSearch = "$hostConnectUser/ledgerlist.php";

  static const validateItemName = "$hostConnectUser/validate_itemname.php";
  static const imCreate = "$hostConnectUser/itemmaster.php";
  static const iLSearch = "$hostConnectUser/itemlist.php";

  static const validateCbName = "$hostConnectUser/validate_cbname.php";
  static const cbCreate = "$hostConnectUser/cashbankmaster.php";
  static const cbSearch = "$hostConnectUser/cblist.php";

  static const recCreate = "$hostConnectUser/receiptmaster.php";
  static const payCreate = "$hostConnectUser/paymentmaster.php";
  static const saleCreate = "$hostConnectUser/salemaster.php";
  static const purCreate = "$hostConnectUser/purmaster.php";

  static const purRepDisplay = "$hostConnectUser/purchasereport.php";
  static const saleRepDisplay = "$hostConnectUser/salereport.php";
  static const recRepDisplay = "$hostConnectUser/receiptreport.php";
  static const payRepDisplay = "$hostConnectUser/paymentreport.php";

  static const fetchPartyData = "$hostConnectUser/partyfletch.php";
  static const fetchTransactions = "$hostConnectUser/transparty.php";
  static const calculateDailyBalance = "$hostConnectUser/dailybalance.php";
  static const clBalance = "$hostConnect/clbalance.php";
}
