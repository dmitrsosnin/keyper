import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/utils/utils.dart';
import 'package:guardian_keyper/feature/auth/data/auth_manager.dart';

import 'auth_dialog_mixin.dart';

class OnChangePassCodeDialog {
  static Future<void> show(BuildContext context) {
    final authManager = GetIt.I<AuthManager>();
    final padding = AuthDialogBase.getPadding(context);
    return screenLock(
      context: context,
      canCancel: true,
      config: AuthDialogBase.screenLockConfig,
      keyPadConfig: AuthDialogBase.keyPadConfig,
      secretsConfig: AuthDialogBase.secretsConfig,
      correctString: authManager.passCode,
      title: Padding(
        padding: padding,
        child: AuthDialogBase.currentPassCodeTitle,
      ),
      cancelButton: AuthDialogBase.cancelButton,
      onCancelled: Navigator.of(context).pop,
      onError: (_) {
        ScaffoldMessenger.of(context)
            .showSnackBar(AuthDialogBase.wrongPassCodeSnackbar);
        authManager.vibrate();
      },
      onUnlocked: () {
        Navigator.of(context).pop();
        final inputController = InputController();
        screenLockCreate(
          context: context,
          canCancel: true,
          digits: passCodeLength,
          config: AuthDialogBase.screenLockConfig,
          keyPadConfig: AuthDialogBase.keyPadConfig,
          secretsConfig: AuthDialogBase.secretsConfig,
          inputController: inputController,
          title: Padding(
            padding: padding,
            child: const Text('Please create your new passcode'),
          ),
          confirmTitle: Padding(
            padding: padding,
            child: const Text('Please repeate your new passcode'),
          ),
          cancelButton: AuthDialogBase.cancelButton,
          onCancelled: Navigator.of(context).pop,
          customizedButtonChild: AuthDialogBase.resetButton,
          customizedButtonTap: inputController.unsetConfirmed,
          onError: (_) {
            ScaffoldMessenger.of(context)
                .showSnackBar(AuthDialogBase.wrongPassCodeSnackbar);
            authManager.vibrate();
          },
          onConfirmed: (passCode) async {
            await authManager.setPassCode(passCode);
            if (context.mounted) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(buildSnackBar(
                text: 'Your login passcode was changed successfully!',
                isFloating: true,
                isError: false,
              ));
            }
          },
        ).then((_) => inputController.dispose);
      },
    );
  }
}
