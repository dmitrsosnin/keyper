import 'package:flutter/foundation.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';

import 'package:guardian_keyper/feature/auth/ui/dialogs/on_change_pass_code_dialog.dart';

import 'settings_presenter.dart';
import 'dialogs/on_set_device_name_dialog.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => SettingsPresenter(),
        child: ScaffoldSafe(
          child: Column(
            children: [
              // Header
              const HeaderBar(
                caption: 'Settings',
                rightButton: HeaderBarButton.close(),
              ),
              // Body
              Expanded(
                child: Consumer<SettingsPresenter>(
                  builder: (context, presenter, __) {
                    final bgColor = Theme.of(context).colorScheme.secondary;
                    final items = <Widget>[
                      // Change Device Name
                      ListTile(
                        leading: IconOf.user(bgColor: bgColor),
                        title: const Text('Change Guardian name'),
                        subtitle: Text(presenter.deviceName),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded),
                        onTap: () => OnSetDeviceNameDialog.show(
                          context,
                          presenter: presenter,
                        ),
                      ),
                      // Change PassCode
                      ListTile(
                        leading: IconOf.passcode(bgColor: bgColor),
                        title: const Text('Passcode'),
                        subtitle: const Text(
                          'Change authentication passcode',
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded),
                        onTap: () => OnChangePassCodeDialog.show(context),
                      ),
                      // Toggle Biometrics
                      if (presenter.hasBiometrics)
                        SwitchListTile.adaptive(
                          secondary: const Icon(
                            Icons.fingerprint,
                            size: 40,
                          ),
                          title: const Text('Biometric login'),
                          subtitle: const Text(
                            'Easier, faster authentication with biometry',
                          ),
                          value: presenter.isBiometricsEnabled,
                          onChanged: presenter.setBiometrics,
                        ),
                      // Toggle Bootstrap
                      SwitchListTile.adaptive(
                        secondary: IconOf.connection(bgColor: bgColor),
                        title: const Text('Proxy connection'),
                        subtitle: const Text(
                          'Connect through Keyper-operated proxy server',
                        ),
                        value: presenter.isBootstrapEnabled,
                        onChanged: presenter.setBootstrap,
                      ),
                      // Theme Mode
                      if (kDebugMode)
                        ListTile(
                          leading: const Icon(
                            Icons.brightness_medium_outlined,
                            size: 40,
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Theme'),
                              SegmentedButton<ThemeMode>(
                                segments: const [
                                  ButtonSegment(
                                    label: Text('Light'),
                                    value: ThemeMode.light,
                                  ),
                                  ButtonSegment(
                                    label: Text('System'),
                                    value: ThemeMode.system,
                                  ),
                                  ButtonSegment(
                                    label: Text('Dark'),
                                    value: ThemeMode.dark,
                                  ),
                                ],
                                emptySelectionAllowed: false,
                                multiSelectionEnabled: false,
                                selected: presenter.selectedThemeMode,
                                onSelectionChanged: presenter.setThemeMode,
                              ),
                            ],
                          ),
                        ),
                    ];
                    return ListView.separated(
                      padding: paddingAll20,
                      itemCount: items.length,
                      itemBuilder: (_, i) => items[i],
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
}
