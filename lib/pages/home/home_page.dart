import 'package:flutter/material.dart';
import 'package:vimes_test/pages/detail/detail_notifier.dart';
import 'package:vimes_test/pages/detail/detail_page.dart';
import 'package:vimes_test/pages/stock_in/stock_in_page.dart';
import 'package:provider/provider.dart';
import 'package:vimes_test/pages/stock_in/stock_in_notifier.dart';
import 'package:vimes_test/pages/home/home_notifier.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeNotifier>(context, listen: false).loadStockIns();
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
        title: const Text('Trang chủ'),
      ),
      body: Consumer<HomeNotifier>(
        builder: (context, homeNotifier, child) {
          if (homeNotifier.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return RefreshIndicator(
            onRefresh: () async {
              await homeNotifier.loadStockIns();
            },
            child: ListView.builder(
              itemCount: homeNotifier.stockIns.length,
              itemBuilder: (context, index) {
                final stockIn = homeNotifier.stockIns[index];
                return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider(
                                  create: (_) => DetailNotifier(),
                                  child: DetailPage(id: stockIn.id!),
                                )),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stockIn.stockInAt ?? '',
                            maxLines: 2,
                            style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            stockIn.byDate ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ));
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF00A780),
        onPressed: () {
          navigateToStockIn();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void navigateToStockIn() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (_) => StockInNotifier(),
          child: const StockInPage(),
        ),
      ),
    );
  }
}
