import 'package:flutter/widgets.dart';

import '/src/core/consts.dart';
import '/src/core/service/platform_service.dart';
import '/src/settings/settings_controller.dart';

import 'widgets/check_pass_code.dart';
import 'widgets/create_pass_code.dart';
import 'widgets/change_pass_code.dart';

export 'package:provider/provider.dart';

class AuthController {
  const AuthController();

  Future<void> createPassCode({
    required final BuildContext context,
    required final void Function() onConfirmed,
  }) =>
      showCreatePassCode(
        context: context,
        passCodeLength: passCodeLength,
        snackBarDuration: snackBarDuration,
        onConfirmed: (final String passCode) async {
          await GetIt.I<SettingsController>().setPassCode(passCode);
          onConfirmed();
        },
      );

  Future<void> changePassCode({
    required final BuildContext context,
    required final void Function() onExit,
  }) =>
      showChangePassCode(
        context: context,
        currentPassCode: GetIt.I<SettingsController>().state.passCode,
        snackBarDuration: snackBarDuration,
        onConfirmed: GetIt.I<SettingsController>().setPassCode,
        onExit: onExit,
      );

  Future<void> checkPassCode({
    required final BuildContext context,
    required final void Function() onUnlock,
    required final bool canCancel,
  }) =>
      showCheckPassCode(
        context: context,
        canCancel: canCancel,
        currentPassCode: GetIt.I<SettingsController>().state.passCode,
        snackBarDuration: snackBarDuration,
        checkBiometric: GetIt.I<SettingsController>().state.isBiometricsEnabled
            ? () async {
                if (await GetIt.I<PlatformService>().localAuthenticate()) {
                  onUnlock();
                }
              }
            : null,
        onUnlock: onUnlock,
      );
}
