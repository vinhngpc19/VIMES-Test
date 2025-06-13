import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vimes_test/data/models/stock_in_model.dart';

class FirebaseService {
  final CollectionReference _stockInsCollection =
      FirebaseFirestore.instance.collection('stock_in');

  Future<void> addStockIn(StockInModel stockIn) async {
    try {
      await _stockInsCollection.add(stockIn.toJson());
    } catch (e) {
      throw Exception('Lỗi: $e');
    }
  }

  Future<List<StockInModel>> getAllStockIns() async {
    try {
      QuerySnapshot snapshot = await _stockInsCollection.get();
      return snapshot.docs
          .map((doc) =>
              StockInModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Lỗi: $e');
    }
  }

  Future<StockInModel?> getStockInById(String id) async {
    try {
      DocumentSnapshot doc = await _stockInsCollection.doc(id).get();
      if (doc.exists) {
        return StockInModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Lỗi: $e');
    }
  }
}
