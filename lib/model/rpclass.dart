class RecUser {
  int receipt_id;
  String receipt_date;
  String receipt_ledger;
  String receipt_cb;
  String receipt_customer;
  String receipt_amount;
  String receipt_notes;
  String receipt_createdby;
  String receipt_dt;
  RecUser(
    this.receipt_id,
    this.receipt_date,
    this.receipt_ledger,
    this.receipt_cb,
    this.receipt_customer,
    this.receipt_amount,
    this.receipt_notes,
    this.receipt_createdby,
    this.receipt_dt,
  );

  factory RecUser.fromJson(Map<String, dynamic> json) => RecUser(
        int.parse(json["receipt_id"]),
        json["receipt_date"],
        json["receipt_ledger"],
        json["receipt_cb"],
        json["receipt_customer"],
        json["receipt_amount"],
        json["receipt_notes"],
        json["receipt_createdby"],
        json["receipt_dt"],
      );

  Map<String, dynamic> toJson() => {
        'receipt_id': receipt_id.toString(),
        'receipt_date': receipt_date,
        'receipt_ledger': receipt_ledger,
        'receipt_cb': receipt_cb,
        'receipt_customer': receipt_customer,
        'receipt_amount': receipt_amount.toString(),
        'receipt_notes': receipt_notes,
        'receipt_createdby': receipt_createdby,
        'receipt_dt': receipt_dt,
      };
}
