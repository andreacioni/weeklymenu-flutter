import 'package:flutter/material.dart';

class EditableTextField extends StatefulWidget {
  final String? _text;
  final bool editEnabled;
  final Widget? prefix;
  final String hintText;
  final int minLines;
  final int maxLines;
  final Widget? icon;
  final String? prefixText;
  final TextAlign textAlign;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;

  EditableTextField(
    this._text, {
    this.editEnabled = false,
    this.prefix,
    this.hintText = "",
    this.minLines = 1,
    this.maxLines = 1,
    this.icon,
    this.prefixText,
    this.textAlign = TextAlign.start,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  _EditableTextFieldState createState() => _EditableTextFieldState();
}

class _EditableTextFieldState extends State<EditableTextField> {
  final TextEditingController textEditingController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget._text != null) {
      textEditingController.text = widget._text!;
    }
    return TextField(
      controller: textEditingController,
      enabled: widget.editEnabled,
      decoration: InputDecoration(
        icon: widget.icon,
        border: InputBorder.none,
        contentPadding: EdgeInsets.all(9),
        hintText: widget.hintText,
        prefix: widget.prefix,
        prefixText: widget.prefixText,
      ),
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
    );
  }
}
