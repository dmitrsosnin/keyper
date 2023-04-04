import 'package:sss256/sss256.dart';

import '/src/core/data/core_model.dart';
import '/src/core/service/analytics_service.dart';

import '../../vault_presenter.dart';

export 'package:provider/provider.dart';

class VaultAddSecretController extends VaultSecretPresenter {
  var _secretName = '';
  var _secret = '';

  String get secret => _secret;

  bool get isNameTooShort => _secretName.length < IdBase.minNameLength;

  set secret(String value) {
    _secret = value;
    notifyListeners();
  }

  set secretName(String value) {
    _secretName = value;
    notifyListeners();
  }

  VaultAddSecretController({required super.pages, required super.groupId})
      : super(secretId: SecretId());

  void startRequest({
    required Callback onSuccess,
    required Callback onReject,
    required Callback onFailed,
  }) {
    serviceRoot.analyticsService.logEvent(eventStartAddSecret);
    networkSubscription.onData(
      (final incomeMessage) async {
        if (incomeMessage.code != MessageCode.setShard) return;
        final message = checkAndUpdateMessage(incomeMessage);
        if (message == null) return;
        if (message.isAccepted) {
          if (messages.where((m) => m.isAccepted).length == group.maxSize) {
            stopListenResponse();
            final shardValue = group.isSelfGuarded
                ? messages
                    .firstWhere((m) => m.ownerId == myPeerId)
                    .secretShard
                    .shard
                : '';
            await repositoryRoot.vaultRepository.put(
              group.aKey,
              group.copyWith(secrets: {...group.secrets, secretId: shardValue}),
            );
            await serviceRoot.analyticsService.logEvent(eventFinishAddSecret);
            onSuccess(message);
          }
        } else {
          stopListenResponse();
          message.isRejected ? onReject(message) : onFailed(message);
        }
      },
    );
    _splitSecret();
    startNetworkRequest(requestShards);
  }

  /// fill messages with request
  void _splitSecret() {
    final shards = splitSecret(
      treshold: group.threshold,
      shares: group.maxSize,
      secret: _secret,
    );
    if (_secret != restoreSecret(shares: shards.sublist(0, group.threshold))) {
      throw const FormatException('Can not restore the secret!');
    }
    secretId = secretId.copyWith(name: _secretName);
    final shardsIterator = shards.iterator;
    for (final guardian in group.guardians.keys) {
      if (shardsIterator.moveNext()) {
        messages.add(MessageModel(
          peerId: guardian,
          code: MessageCode.setShard,
          status: guardian == myPeerId
              ? MessageStatus.accepted
              : MessageStatus.created,
          payload: SecretShardModel(
            id: secretId,
            ownerId: myPeerId,
            groupId: group.id,
            groupSize: group.size,
            groupThreshold: group.threshold,
            shard: shardsIterator.current,
          ),
        ));
      }
    }
  }
}
