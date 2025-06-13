// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vimes_test/common/custom_input_text.dart';
import 'package:vimes_test/common/date_picker.dart';
import 'package:provider/provider.dart';
import 'package:vimes_test/pages/stock_in/components/stock_in_input_item.dart';
import 'package:vimes_test/pages/stock_in/stock_in_notifier.dart';
import 'package:collection/collection.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class StockInPage extends StatefulWidget {
  const StockInPage({super.key});

  @override
  State<StockInPage> createState() => _StockInPageState();
}

class _StockInPageState extends State<StockInPage> {
  late StockInNotifier notifier;

  @override
  void initState() {
    notifier = Provider.of<StockInNotifier>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.2,
        shadowColor: Colors.black,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const Text('Phiếu nhập kho'),
      ),
      body: SafeArea(
          child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Consumer<StockInNotifier>(
                    builder: (context, notifier, child) => Form(
                      key: notifier.formKey,
                      autovalidateMode: notifier.isFirstValidate
                          ? AutovalidateMode.onUserInteraction
                          : null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomInputText(
                            hintText: 'Đơn vị',
                            title: 'Đơn vị',
                            controller: notifier.unitController,
                            validator: notifier.validateUnit,
                          ),
                          CustomInputText(
                            hintText: 'Bộ phận',
                            title: 'Bộ phận',
                            controller: notifier.departmentController,
                            validator: notifier.validateDepartment,
                          ),
                          DatePicker(
                            title: 'Ngày nhập kho',
                            initDate: notifier.stockInDate,
                            onChange: notifier.onStockInDateChange,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 90,
                                child: CustomInputText(
                                  hintText: 'Số',
                                  title: 'Số',
                                  controller: notifier.stockInNumberController,
                                  validator: notifier.validateStockInNumber,
                                ),
                              ),
                              const SizedBox(width: 40),
                              SizedBox(
                                width: 60,
                                child: CustomInputText(
                                  hintText: 'Nợ',
                                  title: 'Nợ',
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]')),
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  textInputType: TextInputType.number,
                                  controller: notifier.debitNumberController,
                                  validator: notifier.validateDebitNumber,
                                ),
                              ),
                              const SizedBox(width: 40),
                              SizedBox(
                                width: 60,
                                child: CustomInputText(
                                  hintText: 'Có',
                                  title: 'Có',
                                  controller: notifier.creditNumberController,
                                  validator: notifier.validateCreditNumber,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Divider(
                              color: Colors.grey.shade300,
                              thickness: 1,
                              height: 1,
                            ),
                          ),
                          CustomInputText(
                            hintText: 'Họ tên người giao',
                            title: 'Họ tên người giao',
                            controller: notifier.deliverNameController,
                            validator: notifier.validateDeliverName,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 120,
                                child: CustomInputText(
                                  hintText: 'Theo',
                                  title: 'Theo',
                                  controller: notifier.byNameController,
                                  validator: notifier.validateByName,
                                ),
                              ),
                              const SizedBox(width: 40),
                              SizedBox(
                                width: 90,
                                child: CustomInputText(
                                  hintText: 'Số',
                                  title: 'Số',
                                  controller: notifier.byNumberController,
                                  validator: notifier.validateByNumber,
                                ),
                              ),
                            ],
                          ),
                          DatePicker(
                            title: 'Ngày',
                            initDate: notifier.byDate,
                            onChange: notifier.onByDateChange,
                          ),
                          CustomInputText(
                            hintText: 'Của đơn vị phân phối',
                            title: 'Của',
                            controller: notifier.byOwnerController,
                            validator: notifier.validateByOwner,
                          ),
                          CustomInputText(
                            hintText: 'Nhập tại kho',
                            title: 'Nhập tại kho',
                            controller: notifier.stockInAtController,
                            validator: notifier.validateStockInAt,
                          ),
                          CustomInputText(
                            hintText: 'Địa điểm',
                            title: 'Địa điểm',
                            maxLines: 3,
                            minLines: 3,
                            controller: notifier.stockInAdressController,
                            validator: notifier.validateStockInAdress,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Divider(
                              color: Colors.grey.shade300,
                              thickness: 1,
                              height: 1,
                            ),
                          ),
                          const Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text('Thêm sản phẩm nhập kho',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold))),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...List.generate(
                                notifier.itemControllers.length,
                                (index) => StockInInputItem(
                                    index: index,
                                    mapController:
                                        notifier.itemControllers[index]),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(color: Colors.black),
                                    children: [
                                      const TextSpan(
                                        text: 'Tổng số tiền (VNĐ): ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                      TextSpan(
                                        text:
                                            '${notifier.formatPrice(notifier.itemTotals.sum)}đ',
                                        style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: notifier.addNewItem,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Divider(
                                  color: Colors.grey.shade300,
                                  thickness: 1,
                                  height: 1,
                                ),
                              ),
                              CustomInputText(
                                hintText: 'Tổng số tiền (Viết bằng chữ)',
                                title: 'Tổng số tiền bằng chữ',
                                showRequired: false,
                                controller: notifier.stringTotalMoneyController,
                              ),
                              CustomInputText(
                                hintText: 'Số chứng từ gốc kèm theo',
                                title: 'Số chứng từ gốc',
                                showRequired: false,
                                controller: notifier.referenceNumberController,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Row(
                                      children: [
                                        Text(
                                          'Chữ ký',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 2),
                                          child: Icon(Icons.error,
                                              color: Colors.red, size: 12),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      height: 200,
                                      padding: const EdgeInsets.all(2.8),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey, width: 1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: SfSignaturePad(
                                        key: notifier.signaturePadKey,
                                        strokeColor: Colors.black,
                                        minimumStrokeWidth: 1,
                                        maximumStrokeWidth: 3,
                                        backgroundColor: Colors.white,
                                        onDrawEnd: () async {
                                          notifier.checkSignature(true);
                                          final image = await notifier
                                              .signaturePadKey.currentState
                                              ?.toImage();
                                          if (image != null) {
                                            notifier.setSignatureImage(image);
                                          }
                                        },
                                      ),
                                    ),
                                    if (!notifier.hasSignature &&
                                        notifier.isFirstValidate)
                                      const Padding(
                                        padding:
                                            EdgeInsets.only(top: 4, left: 6),
                                        child: Text(
                                          'Vui lòng ký vào ô trên',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    const SizedBox(height: 8),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          notifier.signaturePadKey.currentState
                                              ?.clear();
                                          notifier.checkSignature(false);
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.only(right: 6),
                                          child: Text('Xóa',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                      onPressed: () {
                        notifier.sendData();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00A780),
                        foregroundColor: Colors.white,
                      ),
                      child:
                          const Text('Lưu', style: TextStyle(fontSize: 16)))),
            )
          ],
        ),
      )),
    );
  }
}
