import 'package:flutter/material.dart';
import '../../../common/utils/app_colors.dart';
import '../../../common/widgets/app_logo_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            const Text(
              'Learn more about our app',
              style: TextStyle(color: AppColors.subText),
            ),
            const SizedBox(height: 20),
            _AboutHeroCard(),
            const SizedBox(height: 16),
            _FeaturesCard(),
            const SizedBox(height: 16),
            _ProjectInfoCard(),
            const SizedBox(height: 16),
            _SupportCard(),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'Made with care for safer skincare\n© 2026 Skincare Safety. All rights reserved.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AppColors.subText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutHeroCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Center(child: AppLogoWidget(size: 42)),
          ),
          const SizedBox(height: 16),
          const Text(
            'Skincare Safety',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          const Text('Version 1.0.0', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 12),
          const Text(
            'AI-Powered Cosmetic Product Safety Checker',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _FeaturesCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Features', style: TextStyle(fontWeight: FontWeight.w700)),
            SizedBox(height: 12),
            _FeatureTile(
              title: 'Image Scanning',
              subtitle: 'Capture or upload product images for instant analysis',
              color: AppColors.primary,
            ),
            _FeatureTile(
              title: 'AI Analysis',
              subtitle: 'Advanced AI detects harmful ingredients automatically',
              color: AppColors.purple,
            ),
            _FeatureTile(
              title: 'Safety Reports',
              subtitle: 'Get detailed safety reports with ingredient breakdown',
              color: AppColors.safe,
            ),
            _FeatureTile(
              title: 'Scan History',
              subtitle: 'Track all your previous product scans in one place',
              color: AppColors.warning,
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.circle, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: AppColors.subText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Project Information',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 12),
            _InfoRow(label: 'Project Type', value: 'Defence Project'),
            _InfoRow(label: 'Technology', value: 'AI & Machine Learning'),
            _InfoRow(label: 'Purpose', value: 'Consumer Safety'),
            _InfoRow(label: 'Platform', value: 'Mobile Application'),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.subText)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _SupportCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contact & Support',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            _SupportTile(
              title: 'Email Support',
              subtitle: 'smperves12@gmail.com',
              color: AppColors.mint,
            ),
            const SizedBox(height: 10),
            _SupportTile(
              title: 'Help Center',
              subtitle: 'FAQs and guides',
              color: const Color(0xFFFFF2E5),
            ),
          ],
        ),
      ),
    );
  }
}

class _SupportTile extends StatelessWidget {
  const _SupportTile({
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.mail_outline_rounded,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
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
    );
  }
}
