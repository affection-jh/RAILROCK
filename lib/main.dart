import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:railrock/homePage.dart';
import 'firebase_options.dart';
import 'package:railrock/stock/stockClass.dart';
import 'package:railrock/stock/fireMethods.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData() async {
    allStocks = await initializeStocksList();
    categorizeFromAllStocks();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Homepage(),
    );
  }
}
