import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'dart:ui' as ui;
import 'package:vimes_test/data/models/stock_in_model.dart';
import 'package:vimes_test/data/models/stock_in_item_model.dart';
import 'package:vimes_test/services/firebase_service.dart';

class StockInNotifier extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final signaturePadKey = GlobalKey<SfSignaturePadState>();
  bool hasSignature = false;

  List<Map<String, TextEditingController>> itemControllers = [
    {
      'name': TextEditingController(),
      'code': TextEditingController(),
      'unit': TextEditingController(),
      'docQuantity': TextEditingController(),
      'quantity': TextEditingController(),
      'price': TextEditingController(),
    }
  ];

  List<num> itemTotals = [0];

  final TextEditingController unitController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController stockInNumberController = TextEditingController();
  final TextEditingController debitNumberController = TextEditingController();
  final TextEditingController creditNumberController = TextEditingController();
  final TextEditingController deliverNameController = TextEditingController();
  final TextEditingController byNameController = TextEditingController();
  final TextEditingController byNumberController = TextEditingController();
  final TextEditingController byOwnerController = TextEditingController();
  final TextEditingController stockInAtController = TextEditingController();
  final TextEditingController stockInAdressController = TextEditingController();
  final TextEditingController stringTotalMoneyController =
      TextEditingController();
  final TextEditingController referenceNumberController =
      TextEditingController();

  String stockInDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  String byDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

  bool isFirstValidate = false;

  ui.Image? signatureImage;

  StockInNotifier() {
    _setupListenPriceAndQuanChange();
  }

  void _setupListenPriceAndQuanChange() {
    for (var i = 0; i < itemControllers.length; i++) {
      final priceController = itemControllers[i]['price'];
      final quantityController = itemControllers[i]['quantity'];

      priceController?.addListener(() => _updateTotal(i));
      quantityController?.addListener(() => _updateTotal(i));
    }
  }

  void _updateTotal(int index) {
    if (index >= itemControllers.length) return;

    final price = convertToNum(itemControllers[index]['price']?.text);
    final quantity = convertToNum(itemControllers[index]['quantity']?.text);

    if (price > 0 && quantity > 0) {
      itemTotals[index] = price * quantity;
    } else {
      itemTotals[index] = 0;
    }
    notifyListeners();
  }

  String? _validateRequired(String? value, {bool isShortError = false}) {
    if (value == null || value.isEmpty) {
      return isShortError ? 'Bắt buộc' : 'Vui lòng điền thông tin vào ô trên';
    }
    return null;
  }

  String? validateUnit(String? value) => _validateRequired(value?.trim());
  String? validateDepartment(String? value) => _validateRequired(value?.trim());
  String? validateStockInNumber(String? value) =>
      _validateRequired(value?.trim(), isShortError: true);
  String? validateDebitNumber(String? value) =>
      _validateRequired(value?.trim(), isShortError: true);
  String? validateCreditNumber(String? value) =>
      _validateRequired(value?.trim(), isShortError: true);
  String? validateDeliverName(String? value) =>
      _validateRequired(value?.trim());
  String? validateByName(String? value) =>
      _validateRequired(value?.trim(), isShortError: true);
  String? validateByNumber(String? value) =>
      _validateRequired(value?.trim(), isShortError: true);
  String? validateByOwner(String? value) => _validateRequired(value?.trim());
  String? validateStockInAt(String? value) => _validateRequired(value?.trim());
  String? validateStockInAdress(String? value) =>
      _validateRequired(value?.trim());

  void onStockInDateChange(String date) {
    stockInDate = date;
    notifyListeners();
  }

  void onByDateChange(String date) {
    byDate = date;
    notifyListeners();
  }

  void addNewItem() {
    itemControllers.add({
      'name': TextEditingController(),
      'code': TextEditingController(),
      'unit': TextEditingController(),
      'docQuantity': TextEditingController(),
      'quantity': TextEditingController(),
      'price': TextEditingController(),
    });
    itemTotals.add(0);

    final index = itemControllers.length - 1;
    final priceController = itemControllers[index]['price'];
    final quantityController = itemControllers[index]['quantity'];

    priceController?.addListener(() => _updateTotal(index));
    quantityController?.addListener(() => _updateTotal(index));

    notifyListeners();
  }

  void removeItem() {
    if (itemControllers.length > 1) {
      final listItemKeys = itemControllers.last.keys.toList();
      for (final key in listItemKeys) {
        itemControllers.last[key]?.dispose();
      }
      itemControllers.removeLast();
      itemTotals.removeLast();
      notifyListeners();
    }
  }

  void checkSignature(bool hasDrawn) {
    hasSignature = hasDrawn;
    notifyListeners();
  }

  void sendData() async {
    isFirstValidate = true;
    notifyListeners();
    if (formKey.currentState!.validate() && hasSignature) {
      final stockIn = StockInModel(
        unit: unitController.text.trim(),
        department: departmentController.text.trim(),
        stockInDate: stockInDate,
        stockInNumber: stockInNumberController.text.trim(),
        debitNumber: int.tryParse(debitNumberController.text.trim()),
        creditNumber: creditNumberController.text.trim(),
        deliverName: deliverNameController.text.trim(),
        byName: byNameController.text.trim(),
        byNumber: byNumberController.text.trim(),
        byDate: byDate,
        byOwner: byOwnerController.text.trim(),
        stockInAt: stockInAtController.text.trim(),
        stockInAdress: stockInAdressController.text.trim(),
        items: itemControllers.map((controller) {
          final price = convertToNum(controller['price']?.text).toInt();
          final quantity =
              int.tryParse(controller['quantity']?.text ?? '0') ?? 0;
          return StockInItemModel(
            name: controller['name']?.text.trim(),
            code: controller['code']?.text.trim(),
            unit: controller['unit']?.text.trim(),
            docQuantity: int.tryParse(controller['docQuantity']?.text ?? '0'),
            quantity: quantity,
            price: price,
            total: price * quantity,
          );
        }).toList(),
        stringTotalMoney: stringTotalMoneyController.text.trim(),
        referenceNumber: referenceNumberController.text.trim(),
        signaturePadString: null,
      );

      // Gửi dữ liệu lên Firestore
      final firebaseService = FirebaseService();
      try {
        await firebaseService.addStockIn(stockIn);
        print('Dữ liệu đã được gửi lên Firestore thành công.');
      } catch (e) {
        print('Lỗi khi gửi dữ liệu lên Firestore: $e');
      }
    }
  }

  num convertToNum(String? value) {
    if (value == null || value.isEmpty) return 0;
    String intValue = value.replaceAll('.', '').replaceAll(' ', '');
    return num.tryParse(intValue) ?? 0;
  }

  String formatPrice(num? value) {
    if (value == null) return '0';
    String text = value.round().toString();
    final chars = text.split('');
    String newText = '';
    for (int i = 0; i < chars.length; i++) {
      if (i > 0 && (chars.length - i) % 3 == 0) {
        newText += '.';
      }
      newText += chars[i];
    }
    return newText;
  }

  void setSignatureImage(ui.Image? image) {
    signatureImage = image;
    notifyListeners();
  }
}
