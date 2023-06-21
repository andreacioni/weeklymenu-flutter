import 'package:common/storage_type.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final bootstrapConfigurationProvider = Provider(
  (_) => BootstrapConfiguration(
    debug: true,
    storageType: StorageType.flutterData,
    clear: true,
  ),
);

class BootstrapConfiguration {
  final bool debug;
  final StorageType storageType;
  final bool clear;

  BootstrapConfiguration(
      {this.debug = false, required this.storageType, this.clear = false});
}
