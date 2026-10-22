import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class TopHeaderBar extends StatelessWidget {
  const TopHeaderBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Clinical Operations Dashboard', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 2),
                  const Text('Wednesday, Oct 24 • Clinical Cycle Week 4', style: TextStyle(color: AppColors.mutedText, fontSize: 11)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildSyncBadge(),
                      _buildLanguageToggle(),
                      IconButton(icon: const Icon(Icons.wb_sunny_outlined, size: 18), onPressed: () {}),
                      IconButton(icon: const Icon(Icons.notifications_none, size: 18), onPressed: () {}),
                    ],
                  ),
                ],
              );
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Clinical Operations Dashboard', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    SizedBox(height: 2),
                    Text('Wednesday, Oct 24 • Clinical Cycle Week 4', style: TextStyle(color: AppColors.mutedText, fontSize: 11)),
                  ],
                ),
                Row(
                  children: [
                    _buildSyncBadge(),
                    const SizedBox(width: 12),
                    _buildLanguageToggle(),
                    const SizedBox(width: 12),
                    IconButton(icon: const Icon(Icons.wb_sunny_outlined, size: 18), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.notifications_none, size: 18), onPressed: () {}),
                    const CircleAvatar(radius: 12, backgroundColor: AppColors.primaryTeal, child: Icon(Icons.person, size: 14, color: Colors.white)),
                  ],
                )
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        // State Simulator Sub-bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const Icon(Icons.tune, size: 14, color: AppColors.primaryTeal),
                const SizedBox(width: 6),
                const Text('STATE SIMULATOR:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.mutedText)),
                const SizedBox(width: 12),
                _buildChip('Default Ready', true),
                _buildChip('Active Input', false),
                _buildChip('Vision AI Scanning', false),
                _buildChip('Ambiguous Error', false),
                _buildChip('Telemetry Preview', false),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2FE),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('العربية (RTL View)', style: TextStyle(fontSize: 10, color: Color(0xFF0369A1), fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildSyncBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.sync, size: 12, color: AppColors.primaryTeal),
          SizedBox(width: 4),
          Text('Sync 99.8% • EHR Node 04', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildLanguageToggle() {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
            child: const Text('EN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Text('العربية', style: TextStyle(fontSize: 10, color: AppColors.mutedText)),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, bool active) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: active ? AppColors.buttonPrimary : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(color: active ? Colors.white : AppColors.darkText, fontSize: 10, fontWeight: FontWeight.w500),
      ),
    );
  }
}