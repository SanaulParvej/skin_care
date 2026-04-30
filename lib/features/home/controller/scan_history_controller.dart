import 'package:flutter/foundation.dart';

class ScanHistoryItem {
  ScanHistoryItem({
    required this.name,
    required this.date,
    required this.status,
    required this.score,
  });

  final String name;
  final String date;
  final String status;
  final int score;
}

class ScanHistoryController extends ChangeNotifier {
  ScanHistoryController._();

  static final ScanHistoryController instance = ScanHistoryController._();

  final List<ScanHistoryItem> _items = [];

  List<ScanHistoryItem> get items => List.unmodifiable(_items);

  int get totalScans => _items.length;
  int get safeCount =>
      _items.where((item) => item.status.toUpperCase() == 'SAFE').length;
  int get riskyCount =>
      _items.where((item) => item.status.toUpperCase() == 'RISKY').length;

  void addScanResult({
    required String status,
    required List<dynamic> harmfulFound,
    String productName = 'Scanned Product',
  }) {
    final normalizedStatus = status.toUpperCase();
    final harmfulCount = harmfulFound.length;
    final score = (100 - (harmfulCount * 20)).clamp(0, 100);

    _items.insert(
      0,
      ScanHistoryItem(
        name: productName,
        date: _formattedDate(),
        status: normalizedStatus == 'RISKY' ? 'Risky' : 'Safe',
        score: score,
      ),
    );
    notifyListeners();
  }

  String _formattedDate() {
    final now = DateTime.now();
    final mm = now.month.toString().padLeft(2, '0');
    final dd = now.day.toString().padLeft(2, '0');
    return '${now.year}-$mm-$dd';
  }
}
