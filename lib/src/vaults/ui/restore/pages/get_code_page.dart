import 'dart:async';
import 'package:flutter/services.dart';

import '/src/core/app/consts.dart';
import '../../../../core/domain/core_model.dart';
import '/src/core/ui/widgets/common.dart';

import '../vault_restore_presenter.dart';

class GetCodePage extends StatefulWidget {
  const GetCodePage({super.key});

  @override
  State<GetCodePage> createState() => _GetCodePageState();
}

class _GetCodePageState extends State<GetCodePage> {
  late final _presenter = context.read<VaultRestorePresenter>();

  Timer? _snackBarTimer;

  @override
  void dispose() {
    _snackBarTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => Column(
        children: [
          // Header
          const HeaderBar(
            caption: 'Restore a Vault',
            closeButton: HeaderBarCloseButton(),
          ),
          // Body
          const PageTitle(
            title: 'Add a Guardian to restore the Vault',
            subtitle: 'Ask a Guardian to find your Vault in the app and click '
                '“Change Vault’s Owner” to show their QR code or share Text  code.',
          ),
          Padding(
            padding: paddingH20,
            child: PrimaryButton(
              text: 'Add via a QR Code',
              onPressed: () async {
                final code = await Navigator.of(context)
                    .pushNamed<String?>(routeScanQrCode);
                _processCode(code);
              },
            ),
          ),
          Padding(
            padding: paddingAll20,
            child: FutureBuilder(
              future: Clipboard.hasStrings(),
              builder: (_, snapshot) => PrimaryButton(
                text: 'Add via a Text Code',
                onPressed: snapshot.data == true
                    ? () async {
                        final clipboardData =
                            await Clipboard.getData(Clipboard.kTextPlain);
                        var code = clipboardData?.text;
                        if (code != null) {
                          code = code.trim();
                          final whiteSpace = code.lastIndexOf('\n');
                          code = whiteSpace == -1
                              ? code
                              : code.substring(whiteSpace).trim();
                        }
                        _processCode(code);
                      }
                    : null,
              ),
            ),
          ),
        ],
      );

  void _processCode(final String? code) {
    final message = MessageModel.tryFromBase64(code);
    String errorText = '';

    if (message == null) {
      errorText = 'The Code is not valid!\nPlease, '
          'make sure if it was generated by Keyper';
    } else if (message.code != MessageCode.takeGroup) {
      errorText = 'This operation is not supported yet.';
    }

    if (errorText.isEmpty) {
      _presenter.qrCode = message;
    } else {
      // Debounce
      if (_snackBarTimer?.isActive ?? false) return;
      _snackBarTimer = Timer(snackBarDuration, () {});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(buildSnackBar(
          text: errorText,
          isError: true,
        ));
      }
    }
  }
}
