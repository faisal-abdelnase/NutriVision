import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class AiClinicalIntelligenceCard extends StatelessWidget {
  const AiClinicalIntelligenceCard({Key? key}) : super(key: key);

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
          // Header Row with Wrap & Flexible to prevent overflow
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      size: 16,
                      color: AppColors.primaryTeal,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'AI Clinical Intelligence',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Real-time physiological biomarker projection',
                          style: TextStyle(
                            fontSize: 8,
                            color: AppColors.mutedText,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Gemini Bio-Vision v3.2',
                  style: TextStyle(
                    fontSize: 8,
                    color: Color(0xFF166534),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Ratio Banner
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Icon(Icons.check_circle_outline, size: 14, color: Color(0xFF0369A1)),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Exceptional Omega-3 to Omega-6 Ratio (4.2 : 1)\nEffectively downregulates NF-kB inflammatory cascade markers and protects cardiovascular health.',
                    style: TextStyle(
                      fontSize: 9,
                      color: Color(0xFF0369A1),
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Postprandial Glycemic Chart Simulated
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Expanded(
                      child: Text(
                        '📈 Postprandial Glycemic Forecast',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkText,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Zero Hypoglycemic Dip Risk',
                      style: TextStyle(
                        fontSize: 8,
                        color: AppColors.primaryTeal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Smooth Arc Indicator
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: CustomPaint(painter: _CurvePainter()),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Expanded(
                      child: Text(
                        'Fast (0 min)',
                        style: TextStyle(fontSize: 7, color: AppColors.mutedText),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '+60 min (Peak)',
                        style: TextStyle(fontSize: 7, color: AppColors.mutedText),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '+120 min',
                        style: TextStyle(fontSize: 7, color: AppColors.mutedText),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '+180 min (Basal)',
                        style: TextStyle(fontSize: 7, color: AppColors.mutedText),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Expansion Info
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '💡 Why this physiological profile matters',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFEA580C),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'The synergistic combination of 48g dense protein and 8.5g viscous soluble fiber dramatically reduces gastric emptying velocity. This guarantees 4.5 continuous hours of high cognitive focus.',
                  style: TextStyle(
                    fontSize: 8,
                    color: Color(0xFFC2410C),
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.chat_bubble_outline, size: 12),
            label: const Flexible(
              child: Text(
                'Ask AI Nutritionist about this meal (اسأل أخصائي التغذية الذكي)',
                style: TextStyle(fontSize: 10),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 38),
              backgroundColor: const Color(0xFF0284C7),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryTeal
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.4,
      size.height * 0.1,
      size.width * 0.7,
      size.height * 0.5,
    );
    path.lineTo(size.width, size.height * 0.7);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}