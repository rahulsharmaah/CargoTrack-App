class ItemUser {
  int item_id;
  String item_name;
  String item_active;

  ItemUser(
      this.item_id,
      this.item_name,
      this.item_active,
      );

  factory ItemUser.fromJson(Map<String, dynamic> json) => ItemUser(
      int.parse(json["item_id"]),
      json["item_name"],
      json["item_active"]);

  Map<String, dynamic> toJson() => {
    'item_id': item_id.toString(),
    'item_name': item_name,
    'item_active': item_active,
  };
}

class ReceiptUser {
  int receipt_id;
  String receipt_date;
  String receipt_ledgertype;
  String receipt_cashbank;
  String receipt_customerledger;
  int receipt_amount;
  String receipt_notes;


  ReceiptUser(this.receipt_id,
      this.receipt_date,
      this.receipt_ledgertype,
      this.receipt_cashbank,
      this.receipt_customerledger,
      this.receipt_amount,
      this.receipt_notes,);

  factory ReceiptUser.fromJson(Map<String, dynamic> json) =>
      ReceiptUser(
        int.parse(json["receipt_id"]),
        json["receipt_date"],
        json["receipt_ledgertype"],
        json["receipt_cashbank"],
        json["receipt_customerledger"],
        int.parse(json["receipt_amount"]),
        json["receipt_notes"],
      );

  Map<String, dynamic> toJson() =>
      {
        'receipt_id': receipt_id.toString(),
        'receipt_date': receipt_date,
        'receipt_ledgertype': receipt_ledgertype,
        'receipt_cashbank': receipt_cashbank,
        'receipt_customerledger': receipt_customerledger,
        'receipt_amount': receipt_amount.toString(),
        'receipt_notes': receipt_notes,
      };
}