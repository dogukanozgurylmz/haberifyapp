import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:haberifyapp/features/presentation/splash/splash_view.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  await initializeDateFormatting('tr_TR', null);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  // Hive.registerAdapter(MyModelAdapter());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const SplashView(),
        theme: ThemeData.light(),
      ),
    );
  }
}
