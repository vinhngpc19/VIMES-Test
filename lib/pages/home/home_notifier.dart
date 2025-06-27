import 'package:flutter/material.dart';
import 'package:vimes_test/data/models/stock_in_model.dart';
import 'package:vimes_test/services/firebase_service.dart';

class HomeNotifier extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  List<StockInModel> stockIns = <StockInModel>[];
  bool isLoading = false;

  Future<void> loadStockIns() async {
    isLoading = true;
    notifyListeners();

    try {
      stockIns = await _firebaseService.getAllStockIns();
    } catch (e) {
      throw Exception('Failed to load stock ins: $e');
    }
    isLoading = false;
    notifyListeners();
  }
}
