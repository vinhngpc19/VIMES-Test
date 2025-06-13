import 'package:vimes_test/data/models/stock_in_item_model.dart';

class StockInModel {
  String? unit;
  String? department;
  String? stockInDate;
  String? stockInNumber;
  int? debitNumber;
  String? creditNumber;
  //
  String? deliverName;
  String? byName;
  String? byNumber;
  String? byDate;
  String? byOwner;
  String? stockInAt;
  String? stockInAdress;
  //
  List<StockInItemModel>? items;
  //
  String? stringTotalMoney;
  String? referenceNumber;
  String? signaturePadString;

  StockInModel({
    required this.unit,
    required this.department,
    required this.stockInDate,
    required this.stockInNumber,
    required this.debitNumber,
    required this.creditNumber,
    required this.deliverName,
    required this.byName,
    required this.byNumber,
    required this.byDate,
    required this.byOwner,
    required this.stockInAt,
    required this.stockInAdress,
    //
    required this.items,
    //
    this.stringTotalMoney,
    this.referenceNumber,
    required this.signaturePadString,
  });

  factory StockInModel.fromJson(Map<String, dynamic> json) {
    return StockInModel(
      unit: json['unit'],
      department: json['department'],
      stockInDate: json['stockInDate'],
      stockInNumber: json['stockInNumber'],
      debitNumber: json['debitNumber'],
      creditNumber: json['creditNumber'],
      deliverName: json['deliverName'],
      byName: json['byName'],
      byNumber: json['byNumber'],
      byDate: json['byDate'],
      byOwner: json['byOwner'],
      stockInAt: json['stockInAt'],
      stockInAdress: json['stockInAdress'],
      items: (json['items'] as List<dynamic>?)
          ?.map(
              (item) => StockInItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      stringTotalMoney: json['stringTotalMoney'],
      referenceNumber: json['referenceNumber'],
      signaturePadString: json['signaturePadString'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'unit': unit,
      'department': department,
      'stockInDate': stockInDate,
      'stockInNumber': stockInNumber,
      'debitNumber': debitNumber,
      'creditNumber': creditNumber,
      'deliverName': deliverName,
      'byName': byName,
      'byNumber': byNumber,
      'byDate': byDate,
      'byOwner': byOwner,
      'stockInAt': stockInAt,
      'stockInAdress': stockInAdress,
      'items': items?.map((item) => item.toJson()).toList(),
      'stringTotalMoney': stringTotalMoney,
      'referenceNumber': referenceNumber,
      'signaturePadString': signaturePadString,
    };
  }
}
