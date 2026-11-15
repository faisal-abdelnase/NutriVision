import 'package:flutter/material.dart';
import 'package:nutri_vision/core/theme/theme_extensions.dart';
import 'package:nutri_vision/core/utils/formatters.dart';

class MealHistoryDayHeader extends StatelessWidget {
  const MealHistoryDayHeader({super.key, required this.date});

  final DateTime date;

  String _label() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final diff =
        today.difference(DateTime(date.year, date.month, date.day)).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return Formatters.date(date);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        _label(),
        style: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(color: context.surfaceColors.textSecondary),
      ),
    );
  }
}
