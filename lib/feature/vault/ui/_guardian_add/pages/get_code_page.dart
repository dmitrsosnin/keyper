import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/feature/vault/ui/dialogs/on_version_low.dart';
import 'package:guardian_keyper/feature/vault/ui/dialogs/on_version_high.dart';
import 'package:guardian_keyper/feature/vault/ui/dialogs/on_invalid_dialog.dart';
import 'package:guardian_keyper/feature/vault/ui/dialogs/on_qr_code_scan_dialog.dart';
import 'package:guardian_keyper/feature/vault/ui/dialogs/on_code_input_dialog.dart';
import 'package:guardian_keyper/feature/vault/ui/_secret_add/dialogs/on_fail_dialog.dart';
import 'package:guardian_keyper/feature/vault/ui/_guardian_add/dialogs/on_duplicate_dialog.dart';

import '../vault_guardian_add_presenter.dart';

class GetCodePage extends StatelessWidget {
  const GetCodePage({super.key});

  @override
  Widget build(BuildContext context) => ScaffoldSafe(
        appBar: AppBar(
          title: const Text('Add a Guardian'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Body
            const PageTitle(
              subtitle:
                  'Ask a Guardian to tap on “Become a Guardian” in the app, '
                  'and provide their Guardian QR code or text code.',
            ),
            // Scan QR
            Padding(
              padding: paddingH20,
              child: FilledButton(
                onPressed: () async {
                  final code = await OnQrCodeScanDialog.show(
                    context,
                    caption: 'Scan the Guardian QR',
                  );
                  if (context.mounted) _setCode(context, code);
                },
                child: const Text('Add with a QR Code'),
              ),
            ),
            // Input QR
            Padding(
              padding: paddingAll20,
              child: OutlinedButton(
                onPressed: () async {
                  final code = await OnCodeInputDialog.show(context);
                  if (context.mounted) _setCode(context, code);
                },
                child: const Text('Add with a Text Code'),
              ),
            ),
          ],
        ),
      );

  void _setCode(BuildContext context, String? code) {
    try {
      context.read<VaultGuardianAddPresenter>().setCode(code);
    } on SetCodeEmptyException {
      OnInvalidDialog.show(context);
    } on SetCodeFailException {
      OnFailDialog.show(context);
    } on SetCodeVersionLowException {
      OnVersionLowDialog.show(context);
    } on SetCodeVersionHighException {
      OnVersionHighDialog.show(context);
    } on SetCodeDuplicateException catch (e) {
      OnDuplicateDialog.show(
        context,
        peerName: e.message.peerId.name,
      );
    }
  }
}
