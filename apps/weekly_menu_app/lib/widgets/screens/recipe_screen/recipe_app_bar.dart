import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'notifier.dart';
import '../../shared/appbar_button.dart';
import '../../shared/base_dialog.dart';

class RecipeAppBar extends HookConsumerWidget {
  static const TAB_BAR_SIZE = 62.0;

  final bool editModeEnabled;
  final Object? heroTag;
  final Function(bool) onRecipeEditEnabled;
  final void Function() onBackPressed;
  final List<Widget> tabs;
  final TabController tabController;
  final bool innerBoxIsScrolled;

  RecipeAppBar({
    this.heroTag,
    this.editModeEnabled = false,
    required this.onRecipeEditEnabled,
    required this.onBackPressed,
    required this.tabs,
    required this.tabController,
    required this.innerBoxIsScrolled,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final notifier = ref.read(recipeScreenNotifierProvider.notifier);

    final imageUrl = ref.watch(recipeScreenNotifierProvider
        .select((n) => n.recipeOriginator.instance.imgUrl));

    final image =
        imageUrl != null ? CachedNetworkImageProvider(imageUrl) : null;

    void _showUpdateImageDialog(BuildContext context) async {
      final textController = TextEditingController();
      if (imageUrl != null) {
        textController.text = imageUrl;
      }

      String? newUrl = await showDialog<String>(
          context: context,
          builder: (_) => BaseDialog(
                title: 'Image URL',
                subtitle: 'Type the URL of the recipe image',
                children: [
                  TextField(
                    decoration: InputDecoration(hintText: 'URL'),
                    controller: textController,
                  )
                ],
                doneButtonText: 'OK',
                onDoneTap: () => Navigator.of(context).pop(textController.text),
              ));

      if (newUrl != null) {
        notifier.updateImageUrl(newUrl);
      }
    }

    return SliverAppBar(
      pinned: true,
      floating: false,
      snap: false,
      leadingWidth: 50,
      automaticallyImplyLeading: false,
      expandedHeight: 300,
      centerTitle: true,
      forceElevated: innerBoxIsScrolled,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: [],
        collapseMode: CollapseMode.parallax,
        centerTitle: false,
        background: Container(
          child: Hero(
            tag: heroTag ?? Object(),
            child: image != null
                ? ClipRRect(
                    child: Stack(
                      alignment: Alignment.center,
                      fit: StackFit.expand,
                      children: [
                        Image(
                          image: image,
                          errorBuilder: (_, __, ___) => Container(),
                          fit: BoxFit.cover,
                        ),
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                          child: Container(color: Colors.black.withOpacity(0)),
                        ),
                        Image(
                          image: image,
                          errorBuilder: (_, __, ___) => Container(),
                          fit: BoxFit.fitHeight,
                        ),
                      ],
                    ),
                  )
                : Container(
                    color: theme.scaffoldBackgroundColor,
                    child: Image.asset(
                      'assets/images/recipe_banner.jpg',
                      cacheHeight: 900,
                      cacheWidth: 1300,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
          ),
        ),
      ),
      title: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppBarButton(
                icon: Icon(
                  Icons.arrow_back,
                  size: 18,
                ),
                onPressed: onBackPressed),
            Row(
              children: [
                if (!editModeEnabled)
                  AppBarButton(
                    icon: Icon(
                      Icons.edit,
                      size: 18,
                    ),
                    onPressed: () => onRecipeEditEnabled(!editModeEnabled),
                  ),
                if (editModeEnabled)
                  AppBarButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: () => _showUpdateImageDialog(context),
                  ),
                if (editModeEnabled)
                  AppBarButton(
                      icon: Icon(Icons.save),
                      onPressed: () => onRecipeEditEnabled(!editModeEnabled)),
              ],
            )
          ]),
      bottom: PreferredSize(
        preferredSize: Size(double.maxFinite, TAB_BAR_SIZE),
        child: Container(
          padding: EdgeInsets.only(top: 10),
          height: TAB_BAR_SIZE,
          decoration: BoxDecoration(
            color: theme.bottomAppBarColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                height: 4,
                width: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black.withOpacity(0.5)),
              ),
              TabBar(
                controller: tabController,
                tabs: tabs,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
