class SalReport {
  int sale_id;
  String sale_customer;
  String sale_vehicleno;
  String sale_date;
  String sale_ntwt;
  String sale_total;

  SalReport(
      this.sale_id,
      this.sale_customer,
      this.sale_vehicleno,
      this.sale_date,
      this.sale_ntwt,
      this.sale_total,
      );

  factory SalReport.fromJson(Map<String, dynamic> json) => SalReport(
    int.parse(json["sale_id"]),
    json["sale_customer"],
    json["sale_vehicleno"],
    json["sale_date"],
    json["sale_ntwt"],
    json["sale_total"],
  );

  Map<String, dynamic> toJson() => {
    'sale_id': sale_id.toString(),
    'sale_customer': sale_customer,
    'sale_vehicleno': sale_vehicleno,
    'sale_date': sale_date,
    'sale_ntwt': sale_ntwt,
    'sale_total': sale_total,
  };
}

