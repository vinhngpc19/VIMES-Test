import 'package:flutter_test/flutter_test.dart';
import 'package:vimes_test/pages/stock_in/stock_in_notifier.dart';

void main() {
  late StockInNotifier notifier;

  setUp(() {
    notifier = StockInNotifier();
  });

  group('Validation Tests', () {
    test('validateUnit trả lỗi khi rỗng', () {
      expect(notifier.validateUnit(''), 'Vui lòng điền thông tin vào ô trên');
      expect(
          notifier.validateUnit('   '), 'Vui lòng điền thông tin vào ô trên');
      expect(notifier.validateUnit('Test'), null);
    });
    test('validateDepartment trả lỗi khi rỗng', () {
      expect(notifier.validateDepartment(''),
          'Vui lòng điền thông tin vào ô trên');
      expect(notifier.validateDepartment('   '),
          'Vui lòng điền thông tin vào ô trên');
      expect(notifier.validateDepartment('Test'), null);
    });
    test('validateStockInNumber trả lỗi ngắn khi rỗng', () {
      expect(notifier.validateStockInNumber(''), 'Bắt buộc');
      expect(notifier.validateStockInNumber('   '), 'Bắt buộc');
      expect(notifier.validateStockInNumber('Test'), null);
    });
  });

  group('Number Formatting', () {
    test('convertToNum trả về 0 nếu rỗng hoặc null', () {
      expect(notifier.convertToNum(''), 0);
      expect(notifier.convertToNum(null), 0);
    });
    test('convertToNum xử lý số có dấu chấm', () {
      expect(notifier.convertToNum('1.000'), 1000);
      expect(notifier.convertToNum('1.000.000'), 1000000);
    });
    test('formatPrice định dạng số đúng', () {
      expect(notifier.formatPrice(1000), '1.000');
      expect(notifier.formatPrice(1000000), '1.000.000');
      expect(notifier.formatPrice(null), '0');
    });
  });

  group('Tính tổng sản phẩm', () {
    test('Tính tổng đúng khi nhập price và quantity', () {
      notifier.itemControllers[0]['price']?.text = '1.000';
      notifier.itemControllers[0]['quantity']?.text = '2';
      // Kích hoạt listener
      notifier.itemControllers[0]['price']?.text = '1.000';
      expect(notifier.itemTotals[0], 2000);
    });
    test('Tổng = 0 khi nhập sai dữ liệu', () {
      notifier.itemControllers[0]['price']?.text = 'abc';
      notifier.itemControllers[0]['quantity']?.text = 'xyz';
      notifier.itemControllers[0]['price']?.text = 'abc';
      expect(notifier.itemTotals[0], 0);
    });
  });
}
