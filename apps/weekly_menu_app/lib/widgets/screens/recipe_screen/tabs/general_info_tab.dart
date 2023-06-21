import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:data/repositories.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:model/recipe.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:common/extensions.dart';

import '../../../shared/base_dialog.dart';
import '../../../shared/flutter_data_state_builder.dart';
import '../../../shared/number_text_field.dart';
import '../notifier.dart';
import '../screen.dart';

class RecipeGeneralInfoTab extends StatefulWidget {
  const RecipeGeneralInfoTab({
    Key? key,
  }) : super(key: key);

  @override
  State<RecipeGeneralInfoTab> createState() => _RecipeGeneralInfoTabState();
}

class _RecipeGeneralInfoTabState extends State<RecipeGeneralInfoTab>
    with AutomaticKeepAliveClientMixin<RecipeGeneralInfoTab> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: _RecipeInformationTiles(),
          ),
        ],
      ),
    );
  }
}

class _RecipeInformationTiles extends HookConsumerWidget {
  final ExpandableController expandablePanelController =
      ExpandableController(initialExpanded: true);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final notifier = ref.read(recipeScreenNotifierProvider.notifier);

    final editEnabled =
        ref.watch(recipeScreenNotifierProvider.select((n) => n.editEnabled));

    final recipeDescription = ref.watch(recipeScreenNotifierProvider
        .select((n) => n.recipeOriginator.instance.description));
    final recipeNote = ref.watch(recipeScreenNotifierProvider
        .select((n) => n.recipeOriginator.instance.note));
    final section = ref.watch(recipeScreenNotifierProvider
        .select((n) => n.recipeOriginator.instance.section));
    final tags = ref.watch(recipeScreenNotifierProvider
        .select((n) => n.recipeOriginator.instance.tags));
    final recipeUrl = ref.watch(recipeScreenNotifierProvider
        .select((n) => n.recipeOriginator.instance.recipeUrl));
    final videoUrl = ref.watch(recipeScreenNotifierProvider
        .select((n) => n.recipeOriginator.instance.videoUrl));
    final relatedRecipes = ref.watch(recipeScreenNotifierProvider
        .select((n) => n.recipeOriginator.instance.relatedRecipes));

    useEffect(() {
      return () => expandablePanelController.dispose();
    }, const []);

    List<Widget> buildRecipeNote() {
      if (!recipeNote.isBlank) {
        return [
          SizedBox(height: 20),
          Card(
            child: ExpandablePanel(
              controller: expandablePanelController,
              theme: ExpandableThemeData(
                  inkWellBorderRadius: BorderRadius.circular(20)),
              header: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(children: [
                  Icon(Icons.assignment_outlined),
                  SizedBox(width: 20),
                  Text(
                    'Notes',
                    style: theme.textTheme.titleSmall,
                  )
                ]),
              ),
              collapsed: Container(),
              expanded: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(recipeNote!),
              ),
            ),
          )
        ];
      }

      return const [];
    }

    List<Widget> buildTagsSection() {
      if (tags.isNotEmpty) {
        return [
          const SizedBox(height: 20),
          Text(
            'Tags',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          Wrap(
            children: List.generate(
              tags.length,
              (i) => Container(
                margin: const EdgeInsets.only(right: 10),
                child: Chip(
                  key: ValueKey(i),
                  backgroundColor: theme.primaryColorLight,
                  avatar: Icon(
                    Icons.tag,
                    color: Colors.black45,
                  ),
                  label: Text(tags[i]),
                  deleteIcon: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black12,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 15,
                    ),
                  ),
                  onDeleted:
                      editEnabled ? () => notifier.deleteTagByIndex(i) : null,
                ),
              ),
            ),
          )
        ];
      }

      return const [];
    }

    List<Widget> buildSection() {
      if (section != null) {
        return [
          SizedBox(height: 10),
          Row(children: [
            Chip(
              label: Text(section),
              backgroundColor: theme.primaryColor,
            )
          ]),
        ];
      }

      return const [];
    }

    List<Widget> buildRecipeLinkSection() {
      if (!recipeUrl.isBlank || !videoUrl.isBlank) {
        return [
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (recipeUrl != null)
                Flexible(
                  child: Card(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () async {
                        if (!await launchUrl(Uri.parse(recipeUrl))) {
                          throw 'Could not launch $recipeUrl';
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(children: [
                              Icon(Icons.link),
                              SizedBox(width: 20),
                              Text(
                                'Link',
                                style: theme.textTheme.titleSmall,
                              )
                            ]),
                            Icon(Icons.launch)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              if (videoUrl != null)
                Flexible(
                  child: Card(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(children: [
                              Icon(Icons.link),
                              SizedBox(width: 20),
                              Text(
                                'Video',
                                style: theme.textTheme.titleSmall,
                              )
                            ]),
                            Icon(Icons.launch)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ];
      }

      return const [];
    }

    List<Widget> buildRecipeDescription() {
      if (recipeDescription.isNotBlank) {
        return [
          SizedBox(height: 10),
          AutoSizeText(
            recipeDescription!,
            textAlign: TextAlign.start,
            maxLines: 2,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontStyle: FontStyle.italic,
                color: Colors.black.withOpacity(0.7)),
          ),
          SizedBox(height: 10),
        ];
      }

      return const [];
    }

    List<Widget> buildRelatedRecipesSection() {
      if (relatedRecipes.isNotEmpty) {
        return [
          const SizedBox(height: 20),
          Text(
            'Other recipes',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: relatedRecipes
                  .map((rr) => _RelatedRecipeCard(
                        rr.id,
                        editEnabled: editEnabled,
                      ))
                  .toList(),
            ),
          )
        ];
      }
      return const [];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ...buildSection(),
        SizedBox(height: 5),
        _RecipeTitle(),
        ...buildRecipeDescription(),
        SizedBox(height: 20),
        _RecipeHighlights(editEnabled),
        SizedBox(height: 20),
        ...buildRecipeLinkSection(),
        ...buildRecipeNote(),
        ...buildRelatedRecipesSection(),
        ...buildTagsSection(),
      ],
    );
  }
}

class _RecipeHighlights extends HookConsumerWidget {
  static final double BOX_SIZE = 100;

  final bool editEnabled;

  _RecipeHighlights(this.editEnabled);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final notifier = ref.read(recipeScreenNotifierProvider.notifier);

    final servings = ref.watch(recipeScreenNotifierProvider
        .select((n) => n.recipeOriginator.instance.servs));
    final cookingTime = ref.watch(recipeScreenNotifierProvider
        .select((n) => n.recipeOriginator.instance.estimatedCookingTime));
    final preparationTime = ref.watch(recipeScreenNotifierProvider
        .select((n) => n.recipeOriginator.instance.estimatedPreparationTime));

    void showTimeWidget() async {
      final newTime = await showDialog<Duration>(
          context: context,
          builder: (context) {
            return _TimeUpdateDialog(
                initialValue: Duration(
                    minutes: (preparationTime ?? 0) + (cookingTime ?? 0)));
          });

      if (newTime != null) {
        notifier.updateEstimatedPreparationTime(newTime.inMinutes);
      }
    }

    void showServingsDialog() async {
      final newServings = await showDialog<int>(
          context: context,
          builder: (context) {
            return _UpdateServingsDialog(initialValue: servings ?? 1);
          });

      if (newServings != null) {
        notifier.updateServings(newServings);
      }
    }

    Widget buildTimeWidget() {
      return InkWell(
        onTap: editEnabled ? () => showTimeWidget() : null,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: BOX_SIZE,
          width: BOX_SIZE,
          decoration: BoxDecoration(
              color: theme.primaryColorLight,
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.schedule, size: 25),
              SizedBox(height: 9),
              Text(displayDuration(preparationTime ?? 0, cookingTime ?? 0),
                  style: Theme.of(context).textTheme.labelMedium)
            ],
          ),
        ),
      );
    }

    Widget buildServingsWidget() {
      return InkWell(
        onTap: editEnabled ? () => showServingsDialog() : null,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: BOX_SIZE,
          width: BOX_SIZE,
          decoration: BoxDecoration(
              color: theme.primaryColorLight,
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.people_outline, size: 25),
              SizedBox(height: 9),
              Text((servings ?? 1).toString() + ' servs.',
                  style: Theme.of(context).textTheme.labelMedium)
            ],
          ),
        ),
      );
    }

    Widget buildAffinityWidget() {
      return InkWell(
        child: Container(
          height: BOX_SIZE,
          width: BOX_SIZE,
          decoration: BoxDecoration(
              color: theme.primaryColorLight,
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.favorite_border_outlined, size: 25),
              SizedBox(height: 9),
              Text('70 %', style: Theme.of(context).textTheme.labelMedium)
            ],
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        buildTimeWidget(),
        buildServingsWidget(),
        buildAffinityWidget(),
      ],
    );
  }

  String displayDuration(num preparationTime, num cookingTime) {
    final total = preparationTime + cookingTime;

    if (total <= 0) {
      return "—";
    }

    final hours = (preparationTime + cookingTime) / 60;
    final minutes = (preparationTime + cookingTime) % 60;
    return hours >= 1
        ? "${hours.toInt()} h ${minutes.toInt()} min"
        : "${minutes.toInt()} min";
  }
}

class _RecipeTitle extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(recipeScreenNotifierProvider.notifier);

    final editEnabled =
        ref.watch(recipeScreenNotifierProvider.select((n) => n.editEnabled));
    final recipeName = ref.watch(recipeScreenNotifierProvider
        .select((n) => n.recipeOriginator.instance.name));

    void openEditRecipeNameModal() async {
      final textController = TextEditingController(text: recipeName);
      String? newRecipeName = await showDialog<String>(
        context: context,
        builder: (_) => BaseDialog<String?>(
          title: 'Name',
          children: [
            TextField(controller: textController),
          ],
          onDoneTap: () {
            var text = textController.text.trim();
            if (text.isNotEmpty) {
              Navigator.of(context).pop(text);
            }
          },
        ),
      );

      if (newRecipeName != null) {
        notifier.updateRecipeName(newRecipeName);
      }
    }

    return Row(
      children: [
        Flexible(
          child: AutoSizeText(
            recipeName,
            maxLines: 2,
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ),
        if (editEnabled) ...[
          SizedBox(width: 10),
          IconButton(
            onPressed: openEditRecipeNameModal,
            icon: Icon(Icons.edit),
            splashRadius: 15,
          ),
        ]
      ],
    );
  }
}

class _RecipeInformationLevelSelect extends StatefulWidget {
  static const LEVELS = 3;

  final int? _initialLevel;
  final String _label;
  final Icon _icon;
  final bool editEnabled;
  final Color activeColor;
  final Color inactiveColor;
  final Function(int) onChange;
  final AutoSizeGroup? autoSizeGroup;

  _RecipeInformationLevelSelect(this._label, this._icon, this._initialLevel,
      {this.editEnabled = false,
      this.activeColor = Colors.black,
      this.inactiveColor = Colors.grey,
      this.autoSizeGroup,
      required this.onChange});

  @override
  _RecipeInformationLevelSelectState createState() =>
      _RecipeInformationLevelSelectState(_initialLevel);
}

class _RecipeInformationLevelSelectState
    extends State<_RecipeInformationLevelSelect> {
  int? _level;

  _RecipeInformationLevelSelectState(this._level);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: AutoSizeText(
        widget._label,
        group: widget.autoSizeGroup,
        maxLines: 1,
      ),
      leading: widget._icon,
      trailing: SizedBox(
        width: 200,
        child: Row(
          children: List.generate(
            _RecipeInformationLevelSelect.LEVELS,
            (index) => !widget.editEnabled
                ? generateIcon(index)
                : IconButton(
                    icon: generateIcon(index),
                    padding: EdgeInsets.all(0),
                    onPressed: () => updateLevel(index + 1),
                    alignment: Alignment.centerRight,
                  ),
          ),
          mainAxisAlignment: MainAxisAlignment.end,
        ),
      ),
    );
  }

  Widget generateIcon(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Icon(
        widget._icon.icon,
        color: (_level != null && index < _level!)
            ? widget.activeColor
            : widget.inactiveColor,
      ),
    );
  }

  void updateLevel(int newLevel) {
    setState(() {
      _level = newLevel;
    });
    widget.onChange(newLevel);
  }
}

class _EditableInformationTile extends StatelessWidget {
  final double? value;
  final double minValue;
  final String title;
  final Icon? icon;
  final String suffix;
  final bool editingEnabled;
  final String hintText;
  final void Function(double) onChanged;
  final AutoSizeGroup? autoSizeGroup;

  _EditableInformationTile(this.value, this.title,
      {this.icon,
      required this.suffix,
      this.editingEnabled = false,
      required this.onChanged,
      this.minValue = 0,
      this.autoSizeGroup,
      String? hintText})
      : this.hintText = hintText ?? title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: editingEnabled
          ? NumberFormField(
              initialValue: value,
              fractionDigits: 0,
              labelText: title,
              minValue: minValue,
              onChanged: (v) => onChanged(v),
              hintText: hintText,
            )
          : AutoSizeText(
              title,
              group: autoSizeGroup,
            ),
      leading: icon,
      trailing: !editingEnabled
          ? AutoSizeText(
              "${value?.truncate() ?? '-'} $suffix",
              style: TextStyle(fontSize: 18),
              group: autoSizeGroup,
            )
          : null,
    );
  }
}

class _TimeUpdateDialog extends StatefulWidget {
  final Duration initialValue;

  _TimeUpdateDialog({this.initialValue = Duration.zero});

  @override
  State<_TimeUpdateDialog> createState() => _TimeUpdateDialogState();
}

class _TimeUpdateDialogState extends State<_TimeUpdateDialog> {
  late Duration _duration;

  @override
  void initState() {
    _duration = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      title: 'Preparation',
      subtitle: 'Select the time you need to prepare the recipe',
      onDoneTap: () => Navigator.pop(context, _duration),
      children: [
        DurationPicker(
          duration: _duration,
          onChange: (val) {
            setState(() => _duration = val);
          },
          snapToMins: 5.0,
        )
      ],
    );
  }
}

class _UpdateServingsDialog extends StatefulWidget {
  final int initialValue;

  _UpdateServingsDialog({this.initialValue = 1});

  @override
  State<_UpdateServingsDialog> createState() => _UpdateServingsDialogState();
}

class _UpdateServingsDialogState extends State<_UpdateServingsDialog> {
  late int _servings;

  @override
  void initState() {
    _servings = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      title: 'Servings',
      subtitle: 'How many people will serve this recipe?',
      onDoneTap: () => Navigator.pop(context, _servings),
      children: [
        SizedBox(
          width: double.maxFinite,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      if (_servings > 1) {
                        _servings = --_servings;
                      }
                    });
                  },
                  icon: Icon(Icons.remove)),
              Text("$_servings x"),
              Icon(Icons.people_outline),
              IconButton(
                  onPressed: () {
                    setState(() {
                      _servings = ++_servings;
                    });
                  },
                  icon: Icon(Icons.add)),
            ],
          ),
        )
      ],
    );
  }
}

class _RelatedRecipeCard extends ConsumerWidget {
  final String recipeId;
  final bool editEnabled;

  const _RelatedRecipeCard(this.recipeId, {Key? key, this.editEnabled = false})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final borderRadius = BorderRadius.circular(10);
    const height = 60.0;
    const width = 190.0;
    const constraints = const BoxConstraints(
        maxHeight: height, maxWidth: width, minHeight: height, minWidth: width);

    final theme = Theme.of(context);

    return Container(
      constraints: constraints,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        clipBehavior: Clip.hardEdge,
        child: RepositoryStreamBuilder<Recipe>(
          stream: ref.read(recipeRepositoryProvider).streamOne(recipeId),
          builder: (context, recipe) {
            return _buildRecipeCard(
                context, editEnabled, recipe, borderRadius, theme, Object());
          },
          loading: _buildLoadingShimmer(),
        ),
      ),
    );
  }

  Shimmer _buildLoadingShimmer() {
    return Shimmer.fromColors(
        child: Expanded(child: Container(color: Colors.red)),
        baseColor: Color.fromARGB(255, 229, 229, 229),
        highlightColor: Colors.white);
  }

  Widget _buildRecipeCard(BuildContext context, bool editEnabled, Recipe recipe,
      BorderRadius borderRadius, ThemeData theme, Object heroTag) {
    return InkWell(
      borderRadius: borderRadius,
      highlightColor: theme.primaryColor.withOpacity(0.4),
      splashColor: theme.primaryColor.withOpacity(0.6),
      onTap: !editEnabled
          ? () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => RecipeScreen(recipe, heroTag: heroTag)),
              );
            }
          : null,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (recipe.imgUrl != null) ...[
            Image(
              fit: BoxFit.cover,
              height: 120,
              width: 190 * 2,
              errorBuilder: (_, __, ___) => Container(),
              image: CachedNetworkImageProvider(
                recipe.imgUrl!,
              ),
            ),
            Container(
              color: Colors.white.withOpacity(0.5),
            )
          ],
          SizedBox(
            width: double.maxFinite,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: AutoSizeText(
                recipe.name,
                textAlign: TextAlign.start,
                style: theme.textTheme.titleMedium!
                    .copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
