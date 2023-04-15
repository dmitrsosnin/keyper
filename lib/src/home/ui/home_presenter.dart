import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:flutter/widgets.dart';

import '/src/core/app/consts.dart';
import '/src/core/data/network_manager.dart';
import '/src/core/ui/widgets/auth/auth.dart';
import '/src/core/ui/page_presenter_base.dart';
import '/src/core/data/platform_gateway.dart';

import '/src/settings/domain/settings_interactor.dart';
import '/src/message/data/message_repository.dart';
import '/src/vaults/data/vault_repository.dart';

export 'package:provider/provider.dart';

class HomePresenter extends PagePresenterBase with WidgetsBindingObserver {
  HomePresenter({
    required super.pages,
    SettingsInteractor? settingsInteractor,
  }) : _settingsInteractor = settingsInteractor ?? SettingsInteractor() {
    WidgetsBinding.instance.addObserver(this);
    _cacheVaults();
    // subscribe to updates
    _vaultsUpdatesSubscription =
        _vaultRepository.watch().listen(_onVaultsUpdate);
    _settingsUpdatesSubscription =
        _settingsInteractor.settingsChanges.listen(_onSettingsUpdate);
  }

  bool canShowMessage = false;

  late final share = _platformGateway.share;

  bool get canNotShowMessage => !canShowMessage;

  PeerId get myPeerId => _myPeerId;

  bool get isFirstStart => _settingsInteractor.passCode.isEmpty;

  Map<VaultId, VaultModel> get myVaults => _myVaults;
  Map<VaultId, VaultModel> get guardedVaults => _guardedVaults;

  void Function(void Function(BoxEvent)) get onMessage =>
      _messageStreamSubscription.onData;

  final _networkService = GetIt.I<NetworkManager>();
  final _platformGateway = GetIt.I<PlatformGateway>();
  final _vaultRepository = GetIt.I<VaultRepository>();
  final _messageRepository = GetIt.I<MessageRepository>();
  final SettingsInteractor _settingsInteractor;

  late final StreamSubscription<BoxEvent> _vaultsUpdatesSubscription;
  late final StreamSubscription<MapEntry<String, Object>>
      _settingsUpdatesSubscription;
  late final _messageStreamSubscription =
      _messageRepository.watch().listen(null);

  final _myVaults = <VaultId, VaultModel>{};
  final _guardedVaults = <VaultId, VaultModel>{};

  late var _myPeerId = _networkService.myPeerId.copyWith(
    name: _settingsInteractor.deviceName,
  );

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      await _networkService.start();
    } else {
      await _networkService.pause();
      await _vaultRepository.flush();
      await _messageRepository.flush();
    }
  }

  @override
  void dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    Future.wait([
      _settingsUpdatesSubscription.cancel(),
      _vaultsUpdatesSubscription.cancel(),
      _messageStreamSubscription.cancel(),
    ]);
    await _networkService.stop();
    await _vaultRepository.flush();
    await _messageRepository.flush();
    super.dispose();
  }

  Future<void> start() async {
    await _networkService.start();
  }

  /// Create ticket to join vault
  Future<MessageModel> createJoinVaultCode() async {
    final message = MessageModel(
      code: MessageCode.createGroup,
      peerId: myPeerId,
    );
    await _messageRepository.put(message.aKey, message);
    return message;
  }

  /// Create ticket to take vault
  Future<MessageModel> createTakeVaultCode(final VaultId? groupId) async {
    final message = MessageModel(code: MessageCode.takeGroup, peerId: myPeerId);
    await _messageRepository.put(
      message.aKey,
      message.copyWith(
        payload: VaultModel(id: groupId, ownerId: PeerId.empty),
      ),
    );
    return message;
  }

  Future<void> demandPassCode(final BuildContext context) => showDemandPassCode(
        context: context,
        onVibrate: _platformGateway.vibrate,
        currentPassCode: _settingsInteractor.passCode,
        useBiometrics: _settingsInteractor.useBiometrics,
        localAuthenticate: _platformGateway.localAuthenticate,
      );

  void _cacheVaults() {
    for (final vault in _vaultRepository.values) {
      vault.ownerId == _myPeerId
          ? _myVaults[vault.id] = vault
          : _guardedVaults[vault.id] = vault;
    }
  }

  void _onSettingsUpdate(final MapEntry<String, Object> event) {
    if (event.key == keyDeviceName) {
      _myPeerId = _myPeerId.copyWith(name: event.value as String);
      notifyListeners();
    }
  }

  void _onVaultsUpdate(final BoxEvent event) {
    if (event.deleted) {
      _myVaults.removeWhere((_, v) => v.aKey == event.key);
      _guardedVaults.removeWhere((_, v) => v.aKey == event.key);
    } else {
      final vault = event.value as VaultModel;
      vault.ownerId == myPeerId
          ? _myVaults[vault.id] = vault
          : _guardedVaults[vault.id] = vault;
    }
    notifyListeners();
  }
}
