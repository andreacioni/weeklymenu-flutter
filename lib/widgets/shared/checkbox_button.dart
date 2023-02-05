import 'package:flutter/material.dart';

class ButtonCheckbox extends StatelessWidget {
  final Widget label;
  final bool checked;
  final void Function(bool?)? onChanged;

  const ButtonCheckbox({
    Key? key,
    required this.label,
    required this.checked,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(8);
    final primaryColor = Theme.of(context).primaryColor;
    return InkWell(
      borderRadius: borderRadius,
      onTap: () => onChanged?.call(!checked),
      child: Container(
        padding: EdgeInsets.only(right: 7),
        decoration: BoxDecoration(
          color: checked ? primaryColor.withOpacity(0.7) : null,
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1,
            style: BorderStyle.solid,
          ),
          borderRadius: borderRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Checkbox(
              value: checked,
              onChanged: onChanged,
              shape: CircleBorder(),
            ),
            label,
          ],
        ),
      ),
    );
  }
}
