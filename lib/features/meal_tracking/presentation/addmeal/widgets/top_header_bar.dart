import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class TopHeaderBar extends StatelessWidget {
  const TopHeaderBar({super.key});

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
                  const Text(
                    'Clinical Operations Dashboard',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Wednesday, Oct 24 • Clinical Cycle Week 4',
                    style: TextStyle(color: AppColors.mutedText, fontSize: 11),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      // _buildSyncBadge(),
                      _buildLanguageToggle(),
                      IconButton(
                        icon: const Icon(Icons.wb_sunny_outlined, size: 18),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications_none, size: 18),
                        onPressed: () {},
                      ),
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
                    Text(
                      'Clinical Operations Dashboard',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Wednesday, Oct 24 • Clinical Cycle Week 4',
                      style: TextStyle(
                        color: AppColors.mutedText,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    // _buildSyncBadge(),
                    const SizedBox(width: 12),
                    _buildLanguageToggle(),
                    const SizedBox(width: 12),
                    IconButton(
                      icon: const Icon(Icons.wb_sunny_outlined, size: 18),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_none, size: 18),
                      onPressed: () {},
                    ),
                    const CircleAvatar(
                      radius: 12,
                      backgroundColor: AppColors.primaryTeal,
                      child: Icon(Icons.person, size: 14, color: Colors.white),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  // Widget _buildSyncBadge() {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  //     decoration: BoxDecoration(
  //       color: const Color(0xFFF1F5F9),
  //       borderRadius: BorderRadius.circular(16),
  //     ),
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: const [
  //         Icon(Icons.sync, size: 12, color: AppColors.primaryTeal),
  //         SizedBox(width: 4),
  //         Text(
  //           'Sync 99.8% • EHR Node 04',
  //           style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildLanguageToggle() {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'EN',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              'العربية',
              style: TextStyle(fontSize: 10, color: AppColors.mutedText),
            ),
          ),
        ],
      ),
    );
  }


}
