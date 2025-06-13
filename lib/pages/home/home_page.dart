import 'package:flutter/material.dart';
import 'package:vimes_test/pages/stock_in/stock_in_page.dart';
import 'package:provider/provider.dart';
import 'package:vimes_test/pages/stock_in/stock_in_notifier.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF00A780),
          onPressed: () {
            navigateToStockIn();
          },
          child: const Icon(Icons.add, color: Colors.white),
        ));
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
