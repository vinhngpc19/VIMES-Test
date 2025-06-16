import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vimes_test/common/custom_input_text.dart';
import 'package:vimes_test/utils/thousands_input_formatter.dart';
import 'package:vimes_test/pages/stock_in/stock_in_notifier.dart';
import 'package:provider/provider.dart';

class StockInInputItem extends StatefulWidget {
  const StockInInputItem(
      {super.key, required this.mapController, required this.index});
  final Map<String, TextEditingController> mapController;
  final int index;
  @override
  State<StockInInputItem> createState() => _StockInInputItemState();
}

class _StockInInputItemState extends State<StockInInputItem> {
  String? _validateRequired(String? value) {
    final String? trimValue = value?.trim();
    if (trimValue == null || trimValue.isEmpty) {
      return 'Vui lòng nhập';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<StockInNotifier>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Stack(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomInputText(
                          marginTop: 0,
                          hintText: 'Tên sản phẩm',
                          title: 'Tên sản phẩm',
                          controller: widget.mapController['name'] ??
                              TextEditingController(),
                          minLines: 3,
                          maxLines: 3,
                          validator: _validateRequired,
                          currentNode: notifier.itemFocusNodes[widget.index]
                              ['name'],
                        ),
                        CustomInputText(
                          hintText: 'Mã số',
                          title: 'Mã số',
                          controller: widget.mapController['code'] ??
                              TextEditingController(),
                          validator: _validateRequired,
                          currentNode: notifier.itemFocusNodes[widget.index]
                              ['code'],
                        ),
                        CustomInputText(
                          hintText: 'Đơn vị tính',
                          title: 'Đơn vị tính',
                          controller: widget.mapController['unit'] ??
                              TextEditingController(),
                          validator: _validateRequired,
                          currentNode: notifier.itemFocusNodes[widget.index]
                              ['unit'],
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(children: [
                                  Text('Số lượng',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                  Padding(
                                    padding: EdgeInsets.only(left: 2),
                                    child: Icon(Icons.error,
                                        color: Colors.red, size: 12),
                                  )
                                ]),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                        width: 90,
                                        child: CustomInputText(
                                          marginTop: 8,
                                          hintText: 'Chứng từ',
                                          controller: widget.mapController[
                                                  'docQuantity'] ??
                                              TextEditingController(),
                                          validator: _validateRequired,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9.]')),
                                          ],
                                          textInputType: TextInputType.number,
                                          currentNode: notifier
                                                  .itemFocusNodes[widget.index]
                                              ['docQuantity'],
                                        )),
                                    const SizedBox(width: 20),
                                    SizedBox(
                                      width: 90,
                                      child: CustomInputText(
                                        marginTop: 8,
                                        hintText: 'Thực nhập',
                                        controller:
                                            widget.mapController['quantity'] ??
                                                TextEditingController(),
                                        validator: _validateRequired,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9.]')),
                                        ],
                                        textInputType: TextInputType.number,
                                        currentNode: notifier
                                                .itemFocusNodes[widget.index]
                                            ['quantity'],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )),
                        CustomInputText(
                          hintText: 'Đơn giá (VNĐ)',
                          title: 'Đơn giá (VNĐ)',
                          controller: widget.mapController['price'] ??
                              TextEditingController(),
                          validator: _validateRequired,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9.]')),
                            ThousandsInputFormatter(),
                          ],
                          textInputType: TextInputType.number,
                          currentNode: notifier.itemFocusNodes[widget.index]
                              ['price'],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(color: Colors.black),
                              children: [
                                const TextSpan(
                                  text: 'Thành tiền (VNĐ): ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                                TextSpan(
                                  text:
                                      '${notifier.formatPrice(notifier.itemTotals[widget.index])}đ',
                                  style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (widget.index == notifier.itemControllers.length - 1 &&
                    widget.index != 0)
                  Positioned(
                    top: -6,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () {
                        notifier.removeItem();
                      },
                    ),
                  ),
              ],
            )),
      ],
    );
  }
}
