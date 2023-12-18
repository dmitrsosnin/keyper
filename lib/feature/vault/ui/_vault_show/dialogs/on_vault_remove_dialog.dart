import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';

import 'package:guardian_keyper/feature/vault/domain/entity/vault_id.dart';
import 'package:guardian_keyper/feature/vault/domain/use_case/vault_interactor.dart';

class OnVaultRemoveDialog extends StatelessWidget {
  static Future<void> show(
    BuildContext context, {
    required VaultId vaultId,
  }) =>
      showModalBottomSheet<bool>(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        builder: (_) => OnVaultRemoveDialog(vaultId: vaultId),
      );

  const OnVaultRemoveDialog({
    required this.vaultId,
    super.key,
  });

  final VaultId vaultId;

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
        icon: const IconOf.removeVault(isBig: true, bage: BageType.warning),
        titleString: 'Do you want to remove this Vault?',
        textString: 'All the Secrets from this Vault will be removed as well.',
        footer: SizedBox(
          width: double.infinity,
          child: PrimaryButton(
            text: 'Yes, remove the Vault',
            onPressed: () async {
              await GetIt.I<VaultInteractor>().removeVault(vaultId);
              if (context.mounted) {
                Navigator.of(context).popUntil((r) => r.isFirst);
              }
            },
          ),
        ),
      );
}
