import 'package:vimes_test/data/models/stock_in_item_model.dart';

class StockInModel {
  final String? id;
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
  int? totalMoney;
  //
  String? stringTotalMoney;
  String? referenceNumber;
  String? signaturePadString;

  StockInModel({
    this.id,
    this.unit,
    this.department,
    this.stockInDate,
    this.stockInNumber,
    this.debitNumber,
    this.creditNumber,
    this.deliverName,
    this.byName,
    this.byNumber,
    this.byDate,
    this.byOwner,
    this.stockInAt,
    this.stockInAdress,
    this.items,
    this.stringTotalMoney,
    this.referenceNumber,
    this.signaturePadString,
    this.totalMoney,
  });

  factory StockInModel.fromJson(Map<String, dynamic> json) {
    return StockInModel(
      id: json['id'] as String?,
      unit: json['unit'] as String?,
      department: json['department'] as String?,
      stockInDate: json['stockInDate'] as String?,
      stockInNumber: json['stockInNumber'] as String?,
      debitNumber: json['debitNumber'] as int?,
      creditNumber: json['creditNumber'] as String?,
      deliverName: json['deliverName'] as String?,
      byName: json['byName'] as String?,
      byNumber: json['byNumber'] as String?,
      byDate: json['byDate'] as String?,
      byOwner: json['byOwner'] as String?,
      stockInAt: json['stockInAt'] as String?,
      stockInAdress: json['stockInAdress'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => StockInItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      stringTotalMoney: json['stringTotalMoney'] as String?,
      referenceNumber: json['referenceNumber'] as String?,
      signaturePadString: json['signaturePadString'] as String?,
      totalMoney: json['totalMoney'] as int?,
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
      'totalMoney': totalMoney,
      'items': items?.map((item) => item.toJson()).toList(),
      'stringTotalMoney': stringTotalMoney,
      'referenceNumber': referenceNumber,
      'signaturePadString': signaturePadString,
    };
  }
}
