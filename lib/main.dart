import 'package:flutter/material.dart';
import 'package:focus/Theme/app_theme.dart';
import 'screens/screens.dart';
import '../data/database_barrel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final dataRepo = DatabaseRepository(DatabaseProvider.get);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      home: const TaskScreen(),
    );
  }
}
