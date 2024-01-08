import 'dart:typed_data';
import 'package:hive/hive.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/data/services/platform_service.dart';
import 'package:guardian_keyper/data/services/analytics_service.dart';
import 'package:guardian_keyper/data/services/preferences_service.dart';
import 'package:guardian_keyper/data/repositories/settings_repository.dart';
import 'package:guardian_keyper/ui/utils/current_route_observer.dart';

import 'package:guardian_keyper/feature/auth/data/auth_manager.dart';
import 'package:guardian_keyper/feature/wallet/data/wallet_manager.dart';
import 'package:guardian_keyper/feature/network/data/network_manager.dart';

import 'package:guardian_keyper/feature/vault/data/vault_repository.dart';
import 'package:guardian_keyper/feature/vault/domain/use_case/vault_interactor.dart';

import 'package:guardian_keyper/feature/message/data/message_repository.dart';
import 'package:guardian_keyper/feature/message/domain/use_case/message_interactor.dart';

class DI {
  static bool _isInited = false;

  static bool? _isDarkModeOn;

  static PreferencesService? _preferences;

  const DI();

  bool get isInited => _isInited;
  bool get isNotInited => !_isInited;

  bool? get isDarkModeOn => _isDarkModeOn;

  Future<void> init() async {
    _preferences ??= await PreferencesService().init();

    // Init values
    _isDarkModeOn = await _preferences?.get(
      PreferencesKeys.keyIsDarkModeOn,
      // TBD: `true` for Keyper (2), `false` for Wallet (3), `null` for system
      !buildV3,
    );
    if (_isInited) return;

    // Register Services
    GetIt.I.registerSingleton<PreferencesService>(_preferences!);
    GetIt.I.registerLazySingleton<PlatformService>(PlatformService.new);
    GetIt.I.registerLazySingleton<SentryNavigatorObserver>(
      SentryNavigatorObserver.new,
    );
    GetIt.I.registerLazySingleton<CurrentRouteObserver>(
      CurrentRouteObserver.new,
    );
    GetIt.I.registerSingleton<AnalyticsService>(
      await AnalyticsService.init(),
    );

    // Register Managers
    GetIt.I.registerSingleton<AuthManager>(
      await AuthManager().init(),
      dispose: (i) => i.close(),
    );
    GetIt.I.registerSingleton<WalletManager>(
      await WalletManager().init(),
      dispose: (i) => i.close(),
    );
    GetIt.I.registerSingleton<NetworkManager>(
      await NetworkManager().init(),
      dispose: (i) => i.close(),
    );

    // Register Repositories
    final encryptionCipher = HiveAesCipher(
      (await _preferences!.get<Uint8List>(PreferencesKeys.keySeed))!,
    );
    Hive.init(_preferences!.pathDataDir);
    GetIt.I.registerSingleton<VaultRepository>(
      await VaultRepository().init(encryptionCipher: encryptionCipher),
      dispose: (i) => i.close(),
    );
    GetIt.I.registerSingleton<MessageRepository>(
      await MessageRepository().init(encryptionCipher: encryptionCipher),
      dispose: (i) => i.close(),
    );
    GetIt.I.registerLazySingleton<SettingsRepository>(
      SettingsRepository.new,
    );

    // Register Interactors
    GetIt.I.registerLazySingleton<MessageInteractor>(
      MessageInteractor.new,
      dispose: (i) => i.close(),
    );
    GetIt.I.registerLazySingleton<VaultInteractor>(
      VaultInteractor.new,
    );

    _isInited = true;
  }
}
