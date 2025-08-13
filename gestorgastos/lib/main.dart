import 'package:exprense_tracker/providers/transaction_provider.dart';
import 'package:exprense_tracker/screens/summary_screen.dart';
import 'package:exprense_tracker/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('America/Guayaquil'));
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => TransactionProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const Scaffold(
          body: SummaryScreen(),
        ));
  }
}
