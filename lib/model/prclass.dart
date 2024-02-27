class PurReport {
  int purchase_id;
  String purchase_customer;
  String purchase_vehicleno;
  String purchase_date;
  String purchase_ntwt;
  String purchase_total;

  PurReport(
    this.purchase_id,
    this.purchase_customer,
    this.purchase_vehicleno,
    this.purchase_date,
    this.purchase_ntwt,
    this.purchase_total,
  );

  factory PurReport.fromJson(Map<String, dynamic> json) => PurReport(
        int.parse(json["purchase_id"]),
        json["purchase_customer"],
        json["purchase_vehicleno"],
        json["purchase_date"],
        json["purchase_ntwt"],
        json["purchase_total"],
      );

  Map<String, dynamic> toJson() => {
        'purchase_id': purchase_id.toString(),
        'purchase_customer': purchase_customer,
        'purchase_vehicleno': purchase_vehicleno,
        'purchase_date': purchase_date,
        'purchase_ntwt': purchase_ntwt,
        'purchase_total': purchase_total,
      };
}
