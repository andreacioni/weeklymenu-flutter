import 'package:common/constants.dart';
import 'package:dio/dio.dart';
import 'package:dio_logging_interceptor/dio_logging_interceptor.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:model/recipe.dart';
import 'package:data/configuration/remote_config.dart';

import '../auth/auth_service.dart';
import '../auth/token_service.dart';

final recipeScraperProvider = Provider((ref) {
  final tokenService = ref.read(tokenServiceProvider);
  final ingParserVersion = ref
      .read(remoteConfigProvider)
      .getInt(WeeklyMenuRemoteValues.INGREDIENT_PARSER_VERSION);
  final apiTimeout = ref
      .read(remoteConfigProvider)
      .getInt(WeeklyMenuRemoteValues.API_TIMEOUT_MILLIS);

  final apiBasePath = ref
      .read(remoteConfigProvider)
      .getString(WeeklyMenuRemoteValues.API_BASE_PATH);
  final dio = Dio(
    BaseOptions(
      baseUrl: apiBasePath,
      contentType: 'application/json',
      connectTimeout: apiTimeout,
      receiveTimeout: apiTimeout,
      sendTimeout: apiTimeout,
    ),
  );
  return RecipeScraper._(
    dio,
    tokenService: tokenService,
    ingredientParserVersion: ingParserVersion,
  );
});

class RecipeScraper {
  final Dio _dio;

  final int ingredientParserVersion;
  final TokenService tokenService;

  RecipeScraper._(
    this._dio, {
    required this.tokenService,
    required this.ingredientParserVersion,
  }) {
    _dio.interceptors.add(DioLoggingInterceptor(
      level: Level.body,
      compact: false,
    ));
  }

  Future<Recipe> scrapeUrl(String url) async {
    final token = await tokenService.token;
    final recipeResponse = await _dio.get("/scrapers/recipe",
        queryParameters: {
          'url': url,
          'ing_parser_ver': ingredientParserVersion
        },
        options: Options(headers: {'Authorization': 'Bearer ' + token!.jwt}));

    return Recipe.fromJson(recipeResponse.data);
  }
}
