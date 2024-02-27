class SaleUser {
  int sale_id;
  String sale_date;
  String sale_customer;
  String sale_vehicleno;
  String sale_lgwt;
  String sale_ugwt;
  String sale_gross;
  String sale_dust;
  String sale_ntwt;
  String sale_imno;
  String sale_add;
  String sale_ded;
  String sale_total;
  String sale_createdby;
  String sale_dt;
  List<ItemSaleDetails> itemDetailsList;

  SaleUser(
      this.sale_id,
      this.sale_date,
      this.sale_customer,
      this.sale_vehicleno,
      this.sale_lgwt,
      this.sale_ugwt,
      this.sale_gross,
      this.sale_dust,
      this.sale_ntwt,
      this.sale_imno,
      this.sale_add,
      this.sale_ded,
      this.sale_total,
      this.sale_createdby,
      this.sale_dt,
      this.itemDetailsList);

  factory SaleUser.fromJson(Map<String, dynamic> json) {
    List<dynamic>? itemDetailsJsonList = json['item_details'];
    List<ItemSaleDetails> itemDetailsList = itemDetailsJsonList?.map((item) => ItemSaleDetails.fromJson(item)).toList() ?? [];
    //List<ItemsaleDetails> itemDetailsList = itemDetailsJsonList?.map((item) => ItemsaleDetails.fromJson(item)).toList();

    return SaleUser(
      int.parse(json["sale_id"]),
      json["sale_date"],
      json["sale_customer"],
      json["sale_vehicleno"],
      json["sale_lgwt"],
      json["sale_ugwt"],
      json["sale_gross"],
      json["sale_dust"],
      json["sale_ntwt"],
      json["sale_imno"],
      json["sale_add"],
      json["sale_ded"],
      json["sale_total"],
      json["sale_createdby"],
      json["sale_dt"],
      itemDetailsList,
    );
  }

  Map<String, dynamic> toJson() => {
    'sale_id': sale_id.toString(),
    'sale_date': sale_date,
    'sale_customer': sale_customer,
    'sale_vehicleno': sale_vehicleno,
    'sale_lgwt': sale_lgwt.toString(),
    'sale_ugwt': sale_ugwt.toString(),
    'sale_gross': sale_gross.toString(),
    'sale_dust': sale_dust.toString(),
    'sale_ntwt': sale_ntwt.toString(),
    'sale_imno': sale_imno,
    'sale_add': sale_add.toString(),
    'sale_ded': sale_ded.toString(),
    'sale_total': sale_total.toString(),
    'sale_createdby': sale_createdby,
    'sale_dt': sale_dt,
    'item_details': itemDetailsList.map((item) => item.toJson()).toList(),
  };
}

class ItemSaleDetails {
  final String item_name;
  final double item_qty;
  final double item_rate;

  ItemSaleDetails({
    required this.item_name,
    required this.item_qty,
    required this.item_rate,
  });

  Map<String, dynamic> toJson() {
    return {
      'item_name': item_name,
      'item_qty': item_qty,
      'item_rate': item_rate,
    };
  }

  factory ItemSaleDetails.fromJson(Map<String, dynamic> json) {
    return ItemSaleDetails(
      item_name: json['item_name'],
      item_qty: json['item_qty'],
      item_rate: json['item_rate'],
    );
  }
}