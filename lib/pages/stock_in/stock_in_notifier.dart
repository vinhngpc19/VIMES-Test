import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'dart:ui' as ui;
import 'package:vimes_test/data/models/stock_in_model.dart';
import 'package:vimes_test/data/models/stock_in_item_model.dart';
import 'package:vimes_test/services/firebase_service.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:vimes_test/pages/home/home_notifier.dart';

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

  final firebaseService = FirebaseService();

  List<num> itemTotals = [0];

  bool isLoading = false;

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

  final FocusNode unitFocusNode = FocusNode();
  final FocusNode departmentFocusNode = FocusNode();
  final FocusNode stockInNumberFocusNode = FocusNode();
  final FocusNode debitNumberFocusNode = FocusNode();
  final FocusNode creditNumberFocusNode = FocusNode();
  final FocusNode deliverNameFocusNode = FocusNode();
  final FocusNode byNameFocusNode = FocusNode();
  final FocusNode byNumberFocusNode = FocusNode();
  final FocusNode byOwnerFocusNode = FocusNode();
  final FocusNode stockInAtFocusNode = FocusNode();
  final FocusNode stockInAdressFocusNode = FocusNode();

  List<Map<String, FocusNode>> itemFocusNodes = [
    {
      'name': FocusNode(),
      'code': FocusNode(),
      'unit': FocusNode(),
      'docQuantity': FocusNode(),
      'quantity': FocusNode(),
      'price': FocusNode(),
    }
  ];
  final ScrollController scrollController = ScrollController();

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
    itemFocusNodes.add({
      'name': FocusNode(),
      'code': FocusNode(),
      'unit': FocusNode(),
      'docQuantity': FocusNode(),
      'quantity': FocusNode(),
      'price': FocusNode(),
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
        itemFocusNodes.last[key]?.dispose();
      }

      itemControllers.removeLast();
      itemFocusNodes.removeLast();
      itemTotals.removeLast();
      notifyListeners();
    }
  }

  void checkSignature(bool hasDrawn) {
    hasSignature = hasDrawn;
    notifyListeners();
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

  bool _validation() {
    if (!isFirstValidate) {
      isFirstValidate = true;
      notifyListeners();
    }

    if (validateUnit(unitController.text.trim()) != null) {
      unitFocusNode.requestFocus();
      return false;
    } else if (validateDepartment(departmentController.text.trim()) != null) {
      departmentFocusNode.requestFocus();
      return false;
    } else if (validateStockInNumber(stockInNumberController.text.trim()) !=
        null) {
      stockInNumberFocusNode.requestFocus();
      return false;
    } else if (validateDebitNumber(debitNumberController.text.trim()) != null) {
      debitNumberFocusNode.requestFocus();
      return false;
    } else if (validateCreditNumber(creditNumberController.text.trim()) !=
        null) {
      creditNumberFocusNode.requestFocus();
      return false;
    } else if (validateDeliverName(deliverNameController.text.trim()) != null) {
      deliverNameFocusNode.requestFocus();
      return false;
    } else if (validateByName(byNameController.text.trim()) != null) {
      byNameFocusNode.requestFocus();
      return false;
    } else if (validateByNumber(byNumberController.text.trim()) != null) {
      byNumberFocusNode.requestFocus();
      return false;
    } else if (validateByOwner(byOwnerController.text.trim()) != null) {
      byOwnerFocusNode.requestFocus();
      return false;
    } else if (validateStockInAt(stockInAtController.text.trim()) != null) {
      stockInAtFocusNode.requestFocus();
      return false;
    } else if (validateStockInAdress(stockInAdressController.text.trim()) !=
        null) {
      stockInAdressFocusNode.requestFocus();
      return false;
    }

    for (int i = 0; i < itemControllers.length; i++) {
      final controller = itemControllers[i];
      final focusNode = itemFocusNodes[i];

      if (controller['name']?.text.trim().isEmpty ?? true) {
        focusNode['name']?.requestFocus();
        return false;
      } else if (controller['code']?.text.trim().isEmpty ?? true) {
        focusNode['code']?.requestFocus();
        return false;
      } else if (controller['unit']?.text.trim().isEmpty ?? true) {
        focusNode['unit']?.requestFocus();
        return false;
      } else if (controller['quantity']?.text.trim().isEmpty ?? true) {
        focusNode['quantity']?.requestFocus();
        return false;
      } else if (controller['price']?.text.trim().isEmpty ?? true) {
        focusNode['price']?.requestFocus();
        return false;
      }
    }

    if (!hasSignature) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
      return false;
    }
    return formKey.currentState!.validate();
  }

  void sendData(BuildContext context) async {
    if (_validation()) {
      isLoading = true;
      notifyListeners();
      String? signatureBase64;
      if (signatureImage != null) {
        final byteData =
            await signatureImage!.toByteData(format: ui.ImageByteFormat.png);
        if (byteData != null) {
          signatureBase64 = base64Encode(byteData.buffer.asUint8List());
        }
      }

      final totalMoney =
          itemTotals.fold<num>(0, (sum, item) => sum + item).toInt();

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
        signaturePadString: signatureBase64,
        totalMoney: totalMoney,
      );
      try {
        await firebaseService.addStockIn(stockIn);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Dữ liệu đã được gửi thành công.'),
            ),
          );
          Navigator.pop(context);
          context.read<HomeNotifier>().loadStockIns();
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gửi thất bại.'),
            ),
          );
        }
      }
      isLoading = false;
      notifyListeners();
    }
  }
}
