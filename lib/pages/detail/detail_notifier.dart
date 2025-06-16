import 'package:flutter/material.dart';
import 'package:vimes_test/data/models/stock_in_model.dart';
import 'package:vimes_test/services/firebase_service.dart';

class DetailNotifier extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  StockInModel? stockIn;
  bool isLoading = false;

  Future<void> loadStockIn(String id) async {
    isLoading = true;
    notifyListeners();

    try {
      stockIn = await _firebaseService.getStockInById(id);
    } catch (e) {
      print('$e');
    }

    isLoading = false;
    notifyListeners();
  }
}
