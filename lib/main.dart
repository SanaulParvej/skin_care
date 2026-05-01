import 'package:flutter/material.dart';
import 'app.dart';
import 'features/home/controller/scan_history_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScanHistoryController.instance.initialize();
  runApp(const App());
}
