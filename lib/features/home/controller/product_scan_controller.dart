import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../../../core/services/api_url.dart';
import '../../../core/services/network_caller.dart';
import '../../../core/services/network_response.dart';

class ProductScanResult {
  const ProductScanResult({
    required this.status,
    required this.riskScore,
    required this.ingredients,
    required this.harmfulFound,
    required this.rawText,
    required this.extractedText,
  });

  final String status;
  final int riskScore;
  final List<String> ingredients;
  final List<String> harmfulFound;
  final String rawText;
  final String extractedText;

  factory ProductScanResult.fromJson(
    Map<String, dynamic> json, {
    required String extractedText,
  }) {
    final ingredients = _toStringList(json['ingredients']);
    final harmfulFound = _toStringList(json['harmful_found']);
    final riskScore = int.tryParse(json['risk_score']?.toString() ?? '') ?? 0;

    return ProductScanResult(
      status: (json['status']?.toString() ?? 'SAFE').trim(),
      riskScore: riskScore,
      ingredients: ingredients,
      harmfulFound: harmfulFound,
      rawText: (json['raw_text']?.toString() ?? extractedText).trim(),
      extractedText: extractedText,
    );
  }

  static List<String> _toStringList(dynamic raw) {
    if (raw is! List) {
      return <String>[];
    }

    return raw
        .map((item) => item.toString().trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }
}

class ProductScanController {
  ProductScanController._();

  static final ProductScanController instance = ProductScanController._();

  Future<NetworkResponse<ProductScanResult>> scanFromImage(
    File imageFile,
  ) async {
    try {
      final extractedText = await _extractTextFromImage(imageFile);

      if (extractedText.isEmpty) {
        return const NetworkResponse(
          isSuccess: false,
          statusCode: 422,
          errorMessage:
              'No readable ingredient text found. Please capture a clearer label image.',
        );
      }

      final response = await NetworkCaller.postRequest(
        ApiUrl.scan,
        body: <String, dynamic>{'text': extractedText},
      );

      if (!response.isSuccess) {
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage:
              response.errorMessage ?? 'Failed to analyze ingredients.',
        );
      }

      if (response.data is! Map<String, dynamic>) {
        return const NetworkResponse(
          isSuccess: false,
          statusCode: 500,
          errorMessage: 'Invalid scan response format from server.',
        );
      }

      final parsed = ProductScanResult.fromJson(
        response.data as Map<String, dynamic>,
        extractedText: extractedText,
      );

      return NetworkResponse<ProductScanResult>(
        isSuccess: true,
        statusCode: response.statusCode,
        data: parsed,
      );
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: 0,
        errorMessage: 'Scan failed: $e',
      );
    }
  }

  Future<String> _extractTextFromImage(File imageFile) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    try {
      final inputImage = InputImage.fromFilePath(imageFile.path);
      final recognizedText = await textRecognizer.processImage(inputImage);

      final lines = recognizedText.blocks
          .expand((block) => block.lines)
          .map((line) => line.text.trim())
          .where((line) => line.isNotEmpty)
          .toList();

      if (lines.isNotEmpty) {
        return lines.join('\n');
      }

      return recognizedText.text.trim();
    } finally {
      textRecognizer.close();
    }
  }
}
