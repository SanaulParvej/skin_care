import 'package:flutter/material.dart';

import '../../../common/utils/app_colors.dart';
import '../controller/scan_history_controller.dart';

class ScanHistoryPage extends StatelessWidget {
  const ScanHistoryPage({super.key});

  void _showScanDetails(BuildContext context, ScanHistoryItem item) {
    final statusColor = _statusColor(item.status);
    final normalizedStatus = _normalizedStatus(item.status);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 5,
                    width: 48,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Scanned on ${item.date}',
                  style: const TextStyle(color: AppColors.subText),
                ),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        statusColor.withValues(alpha: 0.14),
                        Colors.white,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        normalizedStatus == 'SAFE'
                            ? Icons.verified_rounded
                            : normalizedStatus == 'HIGH RISK'
                            ? Icons.warning_amber_rounded
                            : normalizedStatus == 'LOW RISK' ||
                                  normalizedStatus == 'MEDIUM RISK'
                            ? Icons.info_outline_rounded
                            : Icons.warning_amber_rounded,
                        color: statusColor,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _statusMessage(item.status),
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Detected Ingredients',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                if (item.ingredients.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'No flagged ingredients were stored for this scan.',
                      style: TextStyle(
                        color: AppColors.subText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: item.ingredients
                        .map(
                          (ingredient) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: statusColor.withValues(alpha: 0.28),
                              ),
                            ),
                            child: Text(
                              ingredient,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.22),
                    ),
                  ),
                  child: Text(
                    'Verdict: ${_statusLabel(item.status)}',
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = ScanHistoryController.instance;

    return Scaffold(
      appBar: AppBar(title: const Text('Scan History')),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final items = controller.items;

          if (items.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No scan history yet. Start a scan to see product cards here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.subText),
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = items[index];
              final color = _statusColor(item.status);

              return Card(
                child: ListTile(
                  onTap: () => _showScanDetails(context, item),
                  leading: Container(
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(Icons.spa_rounded, color: color),
                  ),
                  title: Text(
                    item.name,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(item.date),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${item.score}/100',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                      Text(
                        _statusLabel(item.status),
                        style: TextStyle(color: color, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

String _statusLabel(String status) {
  switch (_normalizedStatus(status)) {
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

Color _statusColor(String status) {
  switch (_normalizedStatus(status)) {
    case 'SAFE':
      return AppColors.safe;
    case 'LOW RISK':
    case 'MEDIUM RISK':
      return AppColors.warning;
    case 'HIGH RISK':
      return AppColors.risky;
    default:
      return AppColors.primary;
  }
}

String _statusMessage(String status) {
  switch (_normalizedStatus(status)) {
    case 'SAFE':
      return 'Looks safe';
    case 'LOW RISK':
      return 'Low risk found';
    case 'MEDIUM RISK':
      return 'Use with caution';
    case 'HIGH RISK':
      return 'Potential risk';
    default:
      return 'Scan result';
  }
}

String _normalizedStatus(String status) {
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
