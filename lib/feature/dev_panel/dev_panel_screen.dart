import 'package:get_it/get_it.dart';
import 'package:guardian_keyper/feature/vault/domain/entity/vault_id.dart';

import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/feature/vault/domain/entity/vault.dart';
import 'package:guardian_keyper/feature/network/data/network_manager.dart';
import 'package:guardian_keyper/feature/message/domain/entity/message_model.dart';
import 'package:guardian_keyper/feature/message/ui/dialogs/on_message_active_dialog.dart';

class DevPanelScreen extends StatelessWidget {
  const DevPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final networkManager = GetIt.I<NetworkManager>();
    return ScaffoldSafe(
        child: ListView(
      padding: paddingAll20,
      children: [
        ListTile(
          title: const Text('OnMessageActiveDialog'),
          subtitle: Text(MessageCode.createVault.name),
          onTap: () => OnMessageActiveDialog.show(
            context,
            message: MessageModel(
              code: MessageCode.createVault,
              peerId: networkManager.selfId.copyWith(name: 'Myself'),
              payload: Vault(
                ownerId: networkManager.selfId.copyWith(name: 'Himself'),
                id: VaultId(name: 'Cool Vault'),
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
