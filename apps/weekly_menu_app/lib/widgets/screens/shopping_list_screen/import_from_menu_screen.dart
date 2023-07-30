import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:data/repositories.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:model/menu.dart';
import 'package:model/recipe.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:common/date.dart';
import 'package:common/log.dart';
import 'package:common/extensions.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weekly_menu_app/widgets/screens/menu_page/screen.dart';

part 'import_from_menu_screen.g.dart';

final _screenNotifierProvider = StateNotifierProvider.autoDispose<
    _ImportFromMenuScreenStateNotifier, _ImportFromMenuScreenState>((ref) {
  List<DailyMenu> loadDailyMenus() {
    final now = Date.now();
    final startDate =
        now.subtract(Duration(days: ImportFromMenuScreen.START_DAY_OFFSET));

    return List.generate(ImportFromMenuScreen.LOAD_MENU_DAYS_LIMIT, (index) {
      final dailyMenu =
          ref.watch(dailyMenuProvider(startDate.add(Duration(days: index))));

      return dailyMenu;
    });
  }

  return _ImportFromMenuScreenStateNotifier(
      _ImportFromMenuScreenState(dailyMenuList: loadDailyMenus()));
});

@immutable
@CopyWith()
class _ImportFromMenuScreenState {
  final List<DailyMenu> dailyMenuList;

  _ImportFromMenuScreenState({this.dailyMenuList = const <DailyMenu>[]});

  List<DailyMenu> get notEmptyDailyMenuList {
    return [...dailyMenuList]..removeWhere((d) => d.isEmpty);
  }
}

class _ImportFromMenuScreenStateNotifier
    extends StateNotifier<_ImportFromMenuScreenState> {
  _ImportFromMenuScreenStateNotifier(super.state);
}

class ImportFromMenuScreen extends HookConsumerWidget {
  static const LOAD_MENU_DAYS_LIMIT = 10;
  static const START_DAY_OFFSET = 3;
  static final DAILY_MENU_DATE_PARSER = DateFormat('EEE,dd');

  const ImportFromMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(_screenNotifierProvider);
    final dailyMenuList = state.notEmptyDailyMenuList;
    return Scaffold(
      appBar: AppBar(
        title: Text("Select recipes"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.black54,
                  size: 30,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Select the recipes in the daily menu to import the corresponding ingredients to the shopping list.",
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: dailyMenuList.length,
                itemBuilder: (context, idx) =>
                    _buildDailyItemWidget(context, ref, dailyMenuList[idx]),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget? _buildDailyItemWidget(
      BuildContext context, WidgetRef ref, DailyMenu dailyMenu) {
    final theme = Theme.of(context);
    final recipeRepo = ref.read(recipeRepositoryProvider);
    final recipeIds = dailyMenu.recipeIds;
    final Iterable<Future<Recipe?>> recipeListFutures =
        recipeIds.map((id) async {
      try {
        final recipe = await recipeRepo.load(id);
        if (recipe != null) return recipe;
      } catch (e, st) {
        //we skip recipe that are not available
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to load some recipes")));
        logError("failed to retrieve recipe: ${id}", e, st);
      }
      return null;
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DAILY_MENU_DATE_PARSER.format(dailyMenu.day.toDateTime),
          style: theme.textTheme.titleLarge,
        ),
        SizedBox(height: 10),
        FutureBuilder(
          future: Future.wait(recipeListFutures),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: 10,
                  width: 200,
                  color: Colors.grey.shade300,
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...snapshot.data!.mapNullable((recipe) {
                  if (recipe != null) return Text(recipe.name);
                  return null;
                })
              ],
            );
          },
        ),
      ],
    );
  }
}
