import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScanHistoryItem {
  ScanHistoryItem({
    required this.name,
    required this.date,
    required this.status,
    required this.score,
    required this.ingredients,
  });

  final String name;
  final String date;
  final String status;
  final int score;
  final List<String> ingredients;
}

class ScanHistoryController extends ChangeNotifier {
  ScanHistoryController._();

  static final ScanHistoryController instance = ScanHistoryController._();
  static const String _storageKey = 'scan_history_items_v1';

  final List<ScanHistoryItem> _items = [];
  bool _isInitialized = false;

  List<ScanHistoryItem> get items => List.unmodifiable(_items);

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }
    _isInitialized = true;
    await _loadFromStorage();
  }

  int get totalScans => _items.length;
  int get safeCount =>
      _items.where((item) => _normalizeStatus(item.status) == 'SAFE').length;
  int get mediumCount => _items
      .where(
        (item) =>
            _normalizeStatus(item.status) == 'LOW RISK' ||
            _normalizeStatus(item.status) == 'MEDIUM RISK',
      )
      .length;
  int get riskyCount =>
      _items.where((item) => _normalizeStatus(item.status) != 'SAFE').length;

  void addScanResult({
    required String status,
    required List<dynamic> harmfulFound,
    String productName = 'Scanned Product',
    int? score,
  }) {
    final ingredients = harmfulFound
        .map((item) => item.toString().trim())
        .where((item) => item.isNotEmpty)
        .toList();
    final harmfulCount = ingredients.length;
    final resolvedScore = (score ?? (100 - (harmfulCount * 30))).clamp(0, 100);
    final normalizedStatus = _resolveStatus(
      status,
      resolvedScore,
      harmfulCount,
    );

    _items.insert(
      0,
      ScanHistoryItem(
        name: productName,
        date: _formattedDate(),
        status: _displayStatus(normalizedStatus),
        score: resolvedScore,
        ingredients: ingredients,
      ),
    );
    _saveToStorage();
    notifyListeners();
  }

  String _resolveStatus(String status, int score, int harmfulCount) {
    final normalizedInput = _normalizeStatus(status);

    if (normalizedInput != 'UNKNOWN') {
      return normalizedInput;
    }

    if (score >= 80 || harmfulCount == 0) {
      return 'SAFE';
    }
    if (score >= 60 || harmfulCount == 1) {
      return 'LOW RISK';
    }
    if (score >= 35 || harmfulCount <= 2) {
      return 'MEDIUM RISK';
    }
    return 'HIGH RISK';
  }

  String _normalizeStatus(String status) {
    final normalized = status.trim().toUpperCase();

    if (normalized.contains('SAFE')) {
      return 'SAFE';
    }
    if (normalized.contains('LOW')) {
      return 'LOW RISK';
    }
    if (normalized.contains('MEDIUM')) {
      return 'MEDIUM RISK';
    }
    if (normalized.contains('HIGH') || normalized.contains('RISKY')) {
      return 'HIGH RISK';
    }
    return 'UNKNOWN';
  }

  String _displayStatus(String normalizedStatus) {
    switch (normalizedStatus) {
      case 'SAFE':
        return 'Safe';
      case 'LOW RISK':
        return 'Low Risk';
      case 'MEDIUM RISK':
        return 'Medium Risk';
      case 'HIGH RISK':
        return 'High Risk';
      default:
        return 'Unknown';
    }
  }

  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedItems = _items
        .map(
          (item) => {
            'name': item.name,
            'date': item.date,
            'status': item.status,
            'score': item.score,
            'ingredients': item.ingredients,
          },
        )
        .toList();
    await prefs.setString(_storageKey, jsonEncode(encodedItems));
  }

  Future<void> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) {
      return;
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        return;
      }

      _items
        ..clear()
        ..addAll(
          decoded
              .whereType<Map>()
              .map(
                (map) => ScanHistoryItem(
                  name: map['name']?.toString() ?? 'Scanned Product',
                  date: map['date']?.toString() ?? _formattedDate(),
                  status: map['status']?.toString() ?? 'Safe',
                  score: int.tryParse(map['score']?.toString() ?? '') ?? 100,
                  ingredients: (map['ingredients'] is List)
                      ? (map['ingredients'] as List)
                            .map((item) => item.toString().trim())
                            .where((item) => item.isNotEmpty)
                            .toList()
                      : <String>[],
                ),
              )
              .toList(),
        );

      notifyListeners();
    } catch (_) {
      // If old/corrupted data exists, skip restore instead of crashing.
    }
  }

  String _formattedDate() {
    final now = DateTime.now();
    final mm = now.month.toString().padLeft(2, '0');
    final dd = now.day.toString().padLeft(2, '0');
    return '${now.year}-$mm-$dd';
  }
}
