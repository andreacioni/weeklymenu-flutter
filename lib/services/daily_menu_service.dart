import 'package:flutter_data/flutter_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weekly_menu_app/models/menu.dart';

final dailyMenuServiceProvider = Provider((ref) {
  final menuRepository = ref.read(menusRepositoryProvider);
  return DailyMenuService(menuRepository);
});

/// Daily menus are not part of the available CRUD API we have to handle
/// all the CRUD operation in this service class
class DailyMenuService {
  final Repository<Menu> _menuRepository;

  DailyMenuService(this._menuRepository);

  Future<void> save(DailyMenu dailyMenu) async {
    for (MenuOriginator menu in dailyMenu.menus) {
      if (menu.recipes.isEmpty) {
        // No recipes in menu means that there isn't a menu for that meal, so when can remove it
        await _menuRepository.delete(menu);
        dailyMenu.removeMenu(menu);
      } else {
        await _menuRepository.save(menu.instance);
      }
    }
  }
}
