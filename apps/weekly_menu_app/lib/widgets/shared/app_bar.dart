import 'package:flutter/material.dart';

import 'appbar_button.dart';

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Icon leadingIcon;
  final void Function()? onLeadingTap;
  final ValueChanged<String>? onSearchTextChanged;
  final ValueChanged<String>? onSearchTextSubmitted;

  SearchAppBar({
    this.leadingIcon = const Icon(Icons.menu),
    this.onLeadingTap,
    this.onSearchTextChanged,
    this.onSearchTextSubmitted,
  });

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(80);
}

class _SearchAppBarState extends State<SearchAppBar>
    with SingleTickerProviderStateMixin {
  late FocusNode focusNode;
  late TextEditingController textEditingController;
  late bool hasFocus;

  @override
  void initState() {
    focusNode = FocusNode();
    textEditingController = TextEditingController();
    hasFocus = false;
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBarTheme = Theme.of(context).appBarTheme;
    final osTopPadding = MediaQuery.of(context).padding.top;

    focusNode.addListener(() {
      setState(() => hasFocus = focusNode.hasFocus);
    });

    return Stack(
      children: [
        Material(
          elevation: appBarTheme.elevation ?? 0,
          child: Container(
            height: osTopPadding,
            color: appBarTheme.backgroundColor,
          ),
        ),
        AppBar(
          toolbarHeight: 100,
          title: Material(
            elevation: 1,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: textEditingController,
                focusNode: focusNode,
                decoration: InputDecoration(
                    hintText: !hasFocus ? 'Search' : null,
                    border: InputBorder.none,
                    suffixIcon:
                        textEditingController.text.isNotEmpty || hasFocus
                            ? IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                  textEditingController.clear();
                                  this.widget.onSearchTextChanged?.call("");
                                  this.widget.onSearchTextSubmitted?.call("");
                                },
                              )
                            : Icon(Icons.search)),
                onChanged: (text) {
                  this.widget.onSearchTextChanged?.call(text);
                },
                onSubmitted: (text) {
                  this.widget.onSearchTextSubmitted?.call(text);
                },
              ),
            ),
          ),
          leading: Transform.scale(
            scale: 0.85,
            child: AppBarButton(
              icon: widget.leadingIcon,
              onPressed: () => widget.onLeadingTap?.call(),
            ),
          ),
          actions: <Widget>[
            AppBarButton(
              icon: Icon(
                Icons.filter_list,
              ),
              onPressed: _openOrderingDialog,
            )
          ],
        ),
      ],
    );
  }

  void _openOrderingDialog() async {}
}
