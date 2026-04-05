import 'package:flutter/material.dart';

class AppInfoCard extends StatelessWidget {
  final String appName;
  final String version;
  final String description;
  final String statusText;
  final String footerText;
  final Color statusColor;

  const AppInfoCard({
    super.key,
    required this.appName,
    required this.version,
    required this.description,
    this.statusText = 'Offline Mode Active',
    this.footerText = 'All data is stored locally on your device',
    this.statusColor = const Color(0xFF86D3AE),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD9DDE3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _InfoLabel(text: 'App Name'),
          const SizedBox(height: 4),
          _InfoValue(text: appName),

          const SizedBox(height: 16),

          const _InfoLabel(text: 'Version'),
          const SizedBox(height: 4),
          _InfoValue(text: version),

          const SizedBox(height: 16),

          const _InfoLabel(text: 'Description'),
          const SizedBox(height: 4),
          _InfoValue(
            text: description,
            maxLines: null,
          ),

          const SizedBox(height: 16),
          const Divider(
            height: 1,
            color: Color(0xFFE3E6EB),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                statusText,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF22A06B),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Text(
            footerText,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF7A8394),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoLabel extends StatelessWidget {
  final String text;

  const _InfoLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xFF6B7280),
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _InfoValue extends StatelessWidget {
  final String text;
  final int? maxLines;

  const _InfoValue({
    required this.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: maxLines == null ? TextOverflow.visible : TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 15,
        color: Color(0xFF0F172A),
        fontWeight: FontWeight.w400,
        height: 1.4,
      ),
    );
  }
}