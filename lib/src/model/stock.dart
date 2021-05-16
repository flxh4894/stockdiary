import 'package:flutter/cupertino.dart';

class Stock {
  String name;
  int dealType;
  int price;
  int amount;
  String dealDay;

  Stock(
      {@required this.name,
      @required this.dealType,
      @required this.price,
      @required this.amount,
      this.dealDay});

  factory Stock.fromJson(Map<String, dynamic> json) => Stock(
      name: json['name'],
      dealType: json['dealType'],
      price: json['price'],
      amount: json['amount']
  );

  factory Stock.fromJsonDb(Map<String, dynamic> json) => Stock(
      name: json['name'],
      dealType: json['deal_type'],
      price: json['price'],
      amount: json['amount'],
      dealDay: json['date']
  );

  Map<String, dynamic> toMap() => {
    'name': name,
    'dealType': dealType,
    'price': price,
    'amount': amount,
    'dealDay': dealDay
  };

  Map<String, dynamic> toMapDb(int diaryId) => {
    'diary_id': diaryId,
    'name': name,
    'deal_type': dealType,
    'price': price,
    'amount': amount,
    'date': dealDay
  };

}
