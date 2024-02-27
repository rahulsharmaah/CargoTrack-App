class PurUser {
  int purchase_id;
  String purchase_date;
  String purchase_customer;
  String purchase_vehicleno;
  String purchase_lgwt;
  String purchase_ugwt;
  String purchase_gross;
  String purchase_dust;
  String purchase_ntwt;
  String purchase_imno;
  String purchase_add;
  String purchase_ded;
  String purchase_total;
  String purchase_createdby;
  String purchase_dt;
  List<ItemPurchaseDetails> itemDetailsList;

  PurUser(
      this.purchase_id,
      this.purchase_date,
      this.purchase_customer,
      this.purchase_vehicleno,
      this.purchase_lgwt,
      this.purchase_ugwt,
      this.purchase_gross,
      this.purchase_dust,
      this.purchase_ntwt,
      this.purchase_imno,
      this.purchase_add,
      this.purchase_ded,
      this.purchase_total,
      this.purchase_createdby,
      this.purchase_dt,
      this.itemDetailsList);

  factory PurUser.fromJson(Map<String, dynamic> json) {
    List<dynamic>? itemDetailsJsonList = json['item_details'];
    List<ItemPurchaseDetails> itemDetailsList = itemDetailsJsonList?.map((item) => ItemPurchaseDetails.fromJson(item)).toList() ?? [];
    //List<ItemPurchaseDetails> itemDetailsList = itemDetailsJsonList?.map((item) => ItemPurchaseDetails.fromJson(item)).toList();

    return PurUser(
      int.parse(json["purchase_id"]),
      json["purchase_date"],
      json["purchase_customer"],
      json["purchase_vehicleno"],
      json["purchase_lgwt"],
      json["purchase_ugwt"],
      json["purchase_gross"],
      json["purchase_dust"],
      json["purchase_ntwt"],
      json["purchase_imno"],
      json["purchase_add"],
      json["purchase_ded"],
      json["purchase_total"],
      json["purchase_createdby"],
      json["purchase_dt"],
      itemDetailsList,
    );
  }

  Map<String, dynamic> toJson() => {
    'purchase_id': purchase_id.toString(),
    'purchase_date': purchase_date,
    'purchase_customer': purchase_customer,
    'purchase_vehicleno': purchase_vehicleno,
    'purchase_lgwt': purchase_lgwt.toString(),
    'purchase_ugwt': purchase_ugwt.toString(),
    'purchase_gross': purchase_gross.toString(),
    'purchase_dust': purchase_dust.toString(),
    'purchase_ntwt': purchase_ntwt.toString(),
    'purchase_imno': purchase_imno,
    'purchase_add': purchase_add.toString(),
    'purchase_ded': purchase_ded.toString(),
    'purchase_total': purchase_total.toString(),
    'purchase_createdby': purchase_createdby,
    'purchase_dt': purchase_dt,
    'item_details': itemDetailsList.map((item) => item.toJson()).toList(),
  };
}

class ItemPurchaseDetails {
  final String item_name;
  final double item_qty;
  final double item_rate;
  //final String item_dis;

  ItemPurchaseDetails({
    required this.item_name,
    required this.item_qty,
    required this.item_rate,
   // required this.item_dis,
  });

  Map<String, dynamic> toJson() {
    return {
      'item_name': item_name,
      'item_qty': item_qty,
      'item_rate': item_rate,
      //'item_dis': item_dis,
    };
  }

  factory ItemPurchaseDetails.fromJson(Map<String, dynamic> json) {
    return ItemPurchaseDetails(
      item_name: json['item_name'],
      item_qty: json['item_qty'],
      item_rate: json['item_rate'],
      //item_dis: json['item_dis'],
    );
  }
}