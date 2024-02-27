class User {
  int user_id;
  String user_name;
  String user_mobile;
  String user_password;
  String user_level;

  User(
    this.user_id,
    this.user_name,
    this.user_mobile,
    this.user_password,
    this.user_level,
  );

  factory User.fromJson(Map<String, dynamic> json) => User(
        int.parse(json["user_id"]),
        json["user_name"],
        json["user_mobile"],
        json["user_password"],
        json["user_level"],
      );

  Map<String, dynamic> toJson() => {
        'user_id': user_id.toString(),
        'user_name': user_name,
        'user_mobile': user_mobile.toString(),
        'user_password': user_password,
        'user_level': user_level,
      };
}

class PartyUser {
  int party_id;
  String party_name;
  String party_ob;
  String party_active;

  PartyUser(
    this.party_id,
    this.party_name,
    this.party_ob,
    this.party_active,
  );

  factory PartyUser.fromJson(Map<String, dynamic> json) => PartyUser(
        int.parse(json["party_id"]),
        json["party_name"],
        json["party_ob"],
        json["party_active"],
      );

  Map<String, dynamic> toJson() => {
        'party_id': party_id.toString(),
        'party_name': party_name,
        'party_ob': party_ob,
        'party_active': party_active,
      };
}

class Transaction {
  final int id;
  final String type; // Sales, Receipt, Purchase, Payment
  final double amount;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      type: json['type'],
      amount: json['amount'].toDouble(),
    );
  }
}
