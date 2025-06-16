import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vimes_test/pages/detail/detail_notifier.dart';
import 'dart:convert';

class DetailPage extends StatefulWidget {
  final String id;
  const DetailPage({super.key, required this.id});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DetailNotifier>(context, listen: false)
          .loadStockIn(widget.id);
    });
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
        title: const Text('Chi tiết phiếu nhập kho'),
      ),
      body: Consumer<DetailNotifier>(
        builder: (context, notifier, child) {
          if (notifier.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (notifier.stockIn == null) {
            return const Center(child: Text('Không tìm thấy thông tin'));
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoItem('Đơn vị', notifier.stockIn?.unit ?? ''),
                  _buildInfoItem('Bộ phận', notifier.stockIn?.department ?? ''),
                  _buildInfoItem(
                      'Ngày nhập kho', notifier.stockIn?.stockInDate ?? ''),
                  _buildInfoItem('Số', notifier.stockIn?.stockInNumber ?? ''),
                  _buildInfoItem(
                      'Nợ', notifier.stockIn?.debitNumber?.toString() ?? ''),
                  _buildInfoItem('Có', notifier.stockIn?.creditNumber ?? ''),
                  const Divider(),
                  _buildInfoItem(
                      'Họ tên người giao', notifier.stockIn?.deliverName ?? ''),
                  _buildInfoItem('Theo', notifier.stockIn?.byName ?? ''),
                  _buildInfoItem('Số', notifier.stockIn?.byNumber ?? ''),
                  _buildInfoItem('Ngày', notifier.stockIn?.byDate ?? ''),
                  _buildInfoItem('Của', notifier.stockIn?.byOwner ?? ''),
                  _buildInfoItem(
                      'Nhập tại kho', notifier.stockIn?.stockInAt ?? ''),
                  _buildInfoItem(
                      'Địa điểm', notifier.stockIn?.stockInAdress ?? ''),
                  const Divider(),
                  const Text('Danh sách sản phẩm',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...List.generate(
                    notifier.stockIn?.items?.length ?? 0,
                    (index) {
                      final item = notifier.stockIn?.items?[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoItem('Tên sản phẩm', item?.name ?? ''),
                            _buildInfoItem('Mã sản phẩm', item?.code ?? ''),
                            _buildInfoItem('Đơn vị', item?.unit ?? ''),
                            _buildInfoItem(
                                'Số lượng', item?.quantity?.toString() ?? ''),
                            _buildInfoItem(
                                'Đơn giá', item?.price?.toString() ?? ''),
                            _buildInfoItem(
                                'Thành tiền', item?.total?.toString() ?? ''),
                          ],
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  _buildInfoItem('Tổng số tiền bằng chữ',
                      notifier.stockIn?.stringTotalMoney ?? ''),
                  _buildInfoItem('Số chứng từ gốc',
                      notifier.stockIn?.referenceNumber ?? ''),
                  _buildInfoItem(
                      'Tổng tiền', '${notifier.stockIn?.totalMoney ?? 0}đ'),
                  const Divider(),
                  _buildSignatureImage(notifier.stockIn?.signaturePadString),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignatureImage(String? base64String) {
    if (base64String == null || base64String.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Text(
            'Chữ ký',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          height: 200,
          padding: const EdgeInsets.all(2.8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Image.memory(
            base64Decode(base64String),
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
