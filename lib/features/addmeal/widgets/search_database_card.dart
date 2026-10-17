import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class SearchDatabaseCard extends StatelessWidget {
  const SearchDatabaseCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFFFFF7ED), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.search, color: Color(0xFFEA580C), size: 18),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.badgeOrangeBg, borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: const [
                    CircleAvatar(radius: 3, backgroundColor: AppColors.badgeOrangeText),
                    SizedBox(width: 4),
                    Text('USDA & Clinical DB', style: TextStyle(color: AppColors.badgeOrangeText, fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 12),
          const Text('Search Food Database', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          const Text(
            'Search 500,000+ verified laboratory items, branded foods, or UPC barcodes.',
            style: TextStyle(color: AppColors.mutedText, fontSize: 11),
          ),
          const SizedBox(height: 16),

          // Search Field
          TextField(
            decoration: InputDecoration(
              hintText: 'Search ingredient, barcode, ...',
              hintStyle: const TextStyle(color: AppColors.lightText, fontSize: 12),
              prefixIcon: const Icon(Icons.search, size: 18),
              suffixIcon: const Icon(Icons.qr_code_scanner, size: 18),
              filled: true,
              fillColor: AppColors.inputBg,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Frequent Clinical Matches:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.mutedText)),
          const SizedBox(height: 8),

          _buildMatchTile('Greek Yogurt 0% Fat', '170g • 100 kcal • 18g Prot', Icons.rice_bowl_outlined),
          _buildMatchTile('Quinoa Bowl w/ Edamame', '1 bowl (240g) • 310 kcal', Icons.set_meal_outlined),
          _buildMatchTile('Rolled Oats + Almond Milk', '1 serving • 215 kcal • 4g Fiber', Icons.breakfast_dining_outlined),

          const SizedBox(height: 12),
          const Align(
            alignment: Alignment.centerRight,
            child: Text('Clinical Mode Synced: 2 mins ago', style: TextStyle(fontSize: 9, color: AppColors.lightText)),
          )
        ],
      ),
    );
  }

  Widget _buildMatchTile(String title, String subtitle, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.primaryTeal),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                Text(subtitle, style: const TextStyle(color: AppColors.mutedText, fontSize: 10)),
              ],
            ),
          ),
          const Icon(Icons.add, size: 16, color: AppColors.mutedText),
        ],
      ),
    );
  }
}