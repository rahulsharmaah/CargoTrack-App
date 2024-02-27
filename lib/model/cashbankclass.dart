class CashBank {
  int cb_id;
  String cb_date;
  String cb_name;
  String cb_ob;
  String cb_active;

  CashBank(
      this.cb_id,
      this.cb_date,
      this.cb_name,
      this.cb_ob,
      this.cb_active,
      );

  factory CashBank.fromJson(Map<String, dynamic> json) => CashBank(
      int.parse(json["cb_id"]),
      json["cb_date"],
      json["cb_name"],
      json["cb_ob"],
      json["cb_active"]);

  Map<String, dynamic> toJson() => {
    'cb_id': cb_id.toString(),
    'cb_date': cb_date,
    'cb_name': cb_name,
    'cb_ob': cb_ob,
    'cb_active': cb_active,
  };
}