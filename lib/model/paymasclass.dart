class PayUser {
  int payment_id;
  String payment_date;
  String payment_ledger;
  String payment_cb;
  String payment_customer;
  String payment_amount;
  String payment_ref;
  String payment_notes;
  String payment_createdby;
  String payment_dt;

  PayUser(
      this.payment_id,
      this.payment_date,
      this.payment_ledger,
      this.payment_cb,
      this.payment_customer,
      this.payment_amount,
      this.payment_ref,
      this.payment_notes,
      this.payment_createdby,
      this.payment_dt);

  factory PayUser.fromJson(Map<String, dynamic> json) => PayUser(
      int.parse(json["payment_id"]),
      json["payment_date"],
      json["payment_ledger"],
      json["payment_cb"],
      json["payment_customer"],
      json["payment_amount"],
      json["payment_ref"],
      json["payment_notes"],
      json["payment_createdby"],
      json["payment_dt"]);

  Map<String, dynamic> toJson() => {
    'payment_id': payment_id.toString(),
    'payment_date': payment_date,
    'payment_ledger': payment_ledger,
    'payment_cb': payment_cb,
    'payment_customer': payment_customer,
    'payment_amount': payment_amount.toString(),
    'payment_ref': payment_ref,
    'payment_notes': payment_notes,
    'payment_createdby': payment_createdby,
    'payment_dt': payment_dt,
  };
}
