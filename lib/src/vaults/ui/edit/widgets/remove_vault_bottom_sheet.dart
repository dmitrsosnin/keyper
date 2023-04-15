import 'package:get_it/get_it.dart';

import '/src/core/ui/widgets/common.dart';
import '/src/core/ui/widgets/icon_of.dart';
import '/src/vaults/data/vault_repository.dart';

import '../../../domain/vault_model.dart';

class RemoveVaultBottomSheet extends StatelessWidget {
  const RemoveVaultBottomSheet({super.key, required this.group});

  final VaultModel group;

  @override
  Widget build(final BuildContext context) => BottomSheetWidget(
        footer: ElevatedButton(
          child: const SizedBox(
            width: double.infinity,
            child: Text(
              'Remove the Vault',
              textAlign: TextAlign.center,
            ),
          ),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => BottomSheetWidget(
                icon: const IconOf.removeGroup(
                  isBig: true,
                  bage: BageType.warning,
                ),
                titleString: 'Do you want to remove this Vault?',
                textString:
                    'All the Secrets from this Vault will be removed as well.',
                footer: SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: 'Yes, remove the Vault',
                    onPressed: () async {
                      await GetIt.I<VaultRepository>().delete(group.aKey);
                      if (context.mounted) {
                        Navigator.of(context).popUntil((r) => r.isFirst);
                      }
                    },
                  ),
                ),
              ),
            );
          },
        ),
      );
}
