import 'package:flutter_svg/flutter_svg.dart';

import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import 'shard_home_presenter.dart';

class ShardHomeScreen extends StatelessWidget {
  static const _textSubtitle =
      'Shards you are guarding will be displayed here. Each Shard is a secure '
      'component of someone else`s Secret, essential for collective recovery, '
      'yet individually reveals no information.';

  const ShardHomeScreen({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => ShardHomePresenter(),
        child: Consumer<ShardHomePresenter>(
          builder: (context, presenter, __) => Column(
            children: [
              // Header
              const HeaderBar(caption: 'Shards'),
              // Body
              Expanded(
                child: presenter.shards.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/home_shards.svg',
                            height: 64,
                            width: 64,
                          ),
                          const PageTitle(
                            title: 'Shards will appear here',
                            subtitle: _textSubtitle,
                          ),
                        ],
                      )
                    : ListView(
                        children: [
                          for (final vault in presenter.shards.values)
                            Padding(
                              padding: paddingV6,
                              child: ListTile(
                                isThreeLine: true,
                                visualDensity: VisualDensity.standard,
                                title: Text(
                                  vault.id.name,
                                  style: styleSourceSansPro614,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  'Owner: ${vault.ownerId.name}\n'
                                  '${vault.secrets.length} Shard(s)',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: styleSourceSansPro414Purple,
                                  strutStyle: const StrutStyle(height: 1.5),
                                ),
                                trailing: Container(
                                  width: 0,
                                  margin: paddingH20,
                                  alignment: Alignment.centerRight,
                                  child: const Icon(Icons.arrow_forward_ios),
                                ),
                                onTap: () => Navigator.of(context).pushNamed(
                                  routeShardShow,
                                  arguments: vault,
                                ),
                              ),
                            ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      );
}
