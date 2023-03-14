import '/src/core/widgets/common.dart';
import '/src/guardian/guardian_controller.dart';

import 'shard_page.dart';

class ShardsPage extends StatelessWidget {
  static const _textSubtitle =
      'Guardian Keyper app splits seed phrases into a number '
      'of encrypted parts called “Shards”. Shards are stored on devices '
      'of ”Guardians”, trusted persons. They can be used to securely restore '
      'lost or forgotten seed phrases.\n\nWhen someone asks you to become '
      'their Guardian, you can accept an invitation and as a result get their '
      'Shard. All Shards will be displayed on this page.';

  const ShardsPage({super.key});

  @override
  Widget build(final BuildContext context) =>
      ValueListenableBuilder<Box<RecoveryGroupModel>>(
        valueListenable: GetIt.I<Box<RecoveryGroupModel>>().listenable(),
        builder: (_, boxRecoveryGroups, __) {
          final myId = GetIt.I<GuardianController>().state;
          final guardedGroups =
              boxRecoveryGroups.values.where((e) => e.ownerId != myId);
          return ListView(
            primary: true,
            children: [
              // Header
              const HeaderBar(caption: 'Shards'),
              // Body
              if (guardedGroups.isEmpty)
                const PageTitle(
                  title: 'You don’t have any Shards yet',
                  subtitle: _textSubtitle,
                )
              else ...[
                for (final group in guardedGroups)
                  Padding(
                    padding: paddingH20 + paddingV6,
                    child: ListTile(
                      title: RichText(
                        text: TextSpan(
                          style: textStyleSourceSansPro614,
                          children: buildTextWithId(id: group.id),
                        ),
                      ),
                      subtitle: RichText(
                        text: TextSpan(
                          style: textStyleSourceSansPro414Purple,
                          children: buildTextWithId(id: group.ownerId),
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ScaffoldWidget(
                            child: ShardPage(groupId: group.id),
                          ),
                        ),
                      ),
                    ),
                  )
              ],
            ],
          );
        },
      );
}
