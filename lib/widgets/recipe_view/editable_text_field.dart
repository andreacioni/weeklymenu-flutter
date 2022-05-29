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
  final Function(String?)? onSaved;

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
    this.onSaved,
  });

  @override
  _EditableTextFieldState createState() => _EditableTextFieldState();
}

class _EditableTextFieldState extends State<EditableTextField> {
  late final TextEditingController textEditingController;

  @override
  void initState() {
    textEditingController = new TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget._text != null) {
      textEditingController.text = widget._text!;
    }
    return TextFormField(
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
      onSaved: widget.onSaved,
    );
  }
}
