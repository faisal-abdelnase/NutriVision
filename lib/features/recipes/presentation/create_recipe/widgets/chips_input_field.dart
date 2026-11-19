import 'package:flutter/material.dart';

/// Text field that turns every submitted entry into a deletable chip.
class ChipsInputField extends StatefulWidget {
  const ChipsInputField({
    super.key,
    required this.hint,
    required this.values,
    required this.onChanged,
  });

  final String hint;
  final List<String> values;
  final ValueChanged<List<String>> onChanged;

  @override
  State<ChipsInputField> createState() => _ChipsInputFieldState();
}

class _ChipsInputFieldState extends State<ChipsInputField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _add() {
    final value = _controller.text.trim();
    if (value.isEmpty) return;
    final exists =
        widget.values.any((v) => v.toLowerCase() == value.toLowerCase());
    if (!exists) widget.onChanged([...widget.values, value]);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _add(),
          decoration: InputDecoration(
            hintText: widget.hint,
            suffixIcon: IconButton(
              tooltip: 'Add',
              icon: const Icon(Icons.add_circle_outline),
              onPressed: _add,
            ),
          ),
        ),
        if (widget.values.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final value in widget.values)
                InputChip(
                  label: Text(value),
                  onDeleted: () => widget.onChanged(
                    widget.values.where((v) => v != value).toList(),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
