import 'package:flutter/material.dart';

class ServingsStepper extends StatelessWidget {
  const ServingsStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 12,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton.outlined(
          onPressed: value > min ? () => onChanged(value - 1) : null,
          icon: const Icon(Icons.remove),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text('$value',
              style: Theme.of(context).textTheme.headlineSmall),
        ),
        IconButton.outlined(
          onPressed: value < max ? () => onChanged(value + 1) : null,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
