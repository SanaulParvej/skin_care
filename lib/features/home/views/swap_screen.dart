import 'package:flutter/material.dart';
import 'dart:io';
import '../../../common/utils/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import '../controller/scan_history_controller.dart';
import '../controller/product_scan_controller.dart';

class SwapScreen extends StatefulWidget {
  const SwapScreen({super.key});

  @override
  State<SwapScreen> createState() => _SwapScreenState();
}

class _SwapScreenState extends State<SwapScreen> {
  File? _selectedImage;
  bool _isLoading = false;
  String? _scanStatus;
  int? _scanScore;
  List<String> _harmfulIngredients = [];
  String? _scanError;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 80);

    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
        _scanStatus = null;
        _scanScore = null;
        _harmfulIngredients = [];
        _scanError = null;
      });
    }
  }

  Future<void> _scanSelectedImage() async {
    if (_selectedImage == null || _isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
      _scanError = null;
    });

    try {
      final response = await ProductScanController.instance.scanFromImage(
        _selectedImage!,
      );
      final parsed = response.data;

      if (response.isSuccess && parsed != null) {
        setState(() {
          _isLoading = false;
          _scanStatus = parsed.status;
          _scanScore = parsed.riskScore;
          _harmfulIngredients = parsed.harmfulFound;
          _scanError = null;
        });

        ScanHistoryController.instance.addScanResult(
          status: parsed.status,
          harmfulFound: parsed.harmfulFound,
          score: parsed.riskScore,
        );
      } else {
        setState(() {
          _isLoading = false;
          _scanStatus = null;
          _scanScore = null;
          _harmfulIngredients = [];
          _scanError = response.errorMessage ?? 'Unknown error occurred';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _scanStatus = null;
        _scanScore = null;
        _harmfulIngredients = [];
        _scanError = 'Failed to scan image: $e';
      });
    }
  }

  Widget _buildScanButton() {
    if (_selectedImage == null) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : _scanSelectedImage,
        icon: _isLoading
            ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Icon(Icons.document_scanner_outlined),
        label: Text(_isLoading ? 'Scanning...' : 'Scan'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  Widget _buildScanResultCard() {
    if (_scanError != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.orangeLight,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.warning.withValues(alpha: 0.35)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.error_outline_rounded, color: AppColors.warning),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _scanError!,
                style: const TextStyle(
                  color: AppColors.text,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_scanStatus == null) {
      return const SizedBox.shrink();
    }

    final normalized = _normalizedStatus(_scanStatus!);
    final isSafe = normalized == 'SAFE';
    final isHighRisk = normalized == 'HIGH RISK';
    final baseColor = isSafe
        ? AppColors.safe
        : isHighRisk
        ? AppColors.risky
        : AppColors.warning;
    final title = isSafe
        ? 'Safe Product'
        : isHighRisk
        ? 'High Risk Product'
        : 'Caution Product';
    final subtitle = isSafe
        ? 'No harmful ingredients were detected in this scan.'
        : isHighRisk
        ? 'Potentially harmful ingredients were found.'
        : 'Some ingredients need caution.';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [baseColor.withValues(alpha: 0.12), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: baseColor.withValues(alpha: 0.35),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: baseColor.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isSafe
                      ? Icons.verified_rounded
                      : isHighRisk
                      ? Icons.warning_amber_rounded
                      : Icons.info_outline_rounded,
                  color: baseColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(color: AppColors.subText),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: baseColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              'Risk score: ${_scanScore ?? 0}/100',
              style: TextStyle(color: baseColor, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Ingredients detected',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          if (_harmfulIngredients.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: const Text(
                'No flagged ingredients found.',
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
              children: _harmfulIngredients
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
                          color: baseColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        ingredient,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Scan Product',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            const Text(
              'Capture or upload product image',
              style: TextStyle(color: AppColors.subText),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      height: 220,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [AppColors.mintLight, Colors.white],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: _isLoading
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 12),
                                  Text(
                                    'Scanning...',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : _selectedImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Image.file(
                                _selectedImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Icon(
                                    Icons.qr_code_scanner_rounded,
                                    size: 40,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'No image selected',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Take a photo or select from gallery',
                                  style: TextStyle(color: AppColors.subText),
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _ActionButton(
                            label: 'Take Photo',
                            color: AppColors.mintLight,
                            icon: Icons.camera_alt_rounded,
                            iconColor: AppColors.primary,
                            onTap: _isLoading
                                ? null
                                : () => _pickImage(ImageSource.camera),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ActionButton(
                            label: 'From Gallery',
                            color: AppColors.purpleLight,
                            icon: Icons.photo_library_rounded,
                            iconColor: AppColors.purple,
                            onTap: _isLoading
                                ? null
                                : () => _pickImage(ImageSource.gallery),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _buildScanButton(),
                    if (_scanStatus != null || _scanError != null) ...[
                      const SizedBox(height: 14),
                      _buildScanResultCard(),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.orangeLight,
                    AppColors.orangeLight.withValues(alpha: 0.5),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    height: 46,
                    width: 46,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.warning.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.lightbulb_outline_rounded,
                      color: AppColors.warning,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tips for Best Results',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Ensure good lighting\nCapture ingredient list clearly\nAvoid blurry images',
                          style: TextStyle(color: AppColors.subText),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.color,
    required this.icon,
    required this.iconColor,
    this.onTap,
  });

  final String label;
  final Color color;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1.0,
        child: Container(
          height: 110,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withValues(alpha: 0.6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: iconColor.withValues(alpha: 0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: iconColor.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
