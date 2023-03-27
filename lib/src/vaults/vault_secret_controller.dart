part of 'vault_controller.dart';

class VaultSecretController extends VaultControllerBase {
  SecretId secretId;
  final VaultId groupId;
  late final VaultModel group;
  final Set<MessageModel> messages = {};

  VaultSecretController({
    required super.pages,
    super.currentPage,
    required this.groupId,
    required this.secretId,
  }) {
    group = getGroupById(groupId)!;
  }

  void updateMessage(MessageModel message) {
    messages.remove(message);
    messages.add(message);
    notifyListeners();
  }

  void requestShards([_]) {
    if (messages.where((m) => m.hasResponse).length == group.maxSize) {
      stopListenResponse();
    } else {
      for (final message in messages.where((m) => m.hasNoResponse)) {
        sendToGuardian(message);
      }
    }
  }
}