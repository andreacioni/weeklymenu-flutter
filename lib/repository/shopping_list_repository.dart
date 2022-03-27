import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:weekly_menu_app/globals/http.dart';
import 'package:weekly_menu_app/models/shopping_list.dart';
import 'package:weekly_menu_app/repository/base_repository.dart';
import 'package:weekly_menu_app/services/auth_service.dart';
import '../models/shopping_list.dart';

final _shoppingListsLocalRepositoryProvider =
    FutureProvider<_ShoppingListLocalRepository>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  final shopListCollection = isar.getCollection<ShoppingList>('ShoppingList');
  return _ShoppingListLocalRepository(shopListCollection);
});

final _shoppingListsRemoteRepositoryProvider =
    FutureProvider<_ShoppingListRemoteRepository>((ref) async {
  final authService = ref.watch(authServiceProvider);
  final dio = ref.read(dioProvider);
  return _ShoppingListRemoteRepository(authService, dio);
});

final shoppingListsRepositoryProvider = FutureProvider((ref) async {
  final remote = await ref.watch(_shoppingListsRemoteRepositoryProvider.future);
  final local = await ref.watch(_shoppingListsLocalRepositoryProvider.future);
  return ShoppingListRepository(remote, local);
});

class _ShoppingListLocalRepository extends LocalRepository<ShoppingList> {
  _ShoppingListLocalRepository(IsarCollection<ShoppingList> collection)
      : super(collection);
}

class _ShoppingListRemoteRepository extends RemoteRepository<ShoppingList> {
  _ShoppingListRemoteRepository(AuthService authService, Dio dio)
      : super(authService, dio);
}

class ShoppingListRepository extends Repository<ShoppingList> {
  ShoppingListRepository(
      _ShoppingListRemoteRepository remote, _ShoppingListLocalRepository local)
      : super(remote, local);
}
