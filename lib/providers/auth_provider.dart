import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../datasource/network.dart';

class AuthProvider with ChangeNotifier {
  final log = Logger((AuthProvider).toString());
  final NetworkDatasource _restApi = NetworkDatasource.getInstance();

  Future<void> register({@required String email, @required String password}) async {
    await _restApi.register(email, password);
  }
  
  Future<void> login(String email, password) async {
    await _restApi.login(email, password);
  }

  Future<void> logout() async {
    await _restApi.logout();
  }
}