import 'package:flutter/material.dart';

import 'package:guardian_keyper/ui/presenters/home_presenter.dart';
import 'package:guardian_keyper/ui/theme/theme.dart';

import '../dashboard_presenter.dart';

class VaultsCountButton extends StatelessWidget {
  const VaultsCountButton({super.key});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: context.read<HomePresenter>().gotoVaults,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: clGreen,
          ),
          padding: paddingAll8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Vaults',
                    style: textStyleSourceSansPro612.copyWith(color: clBlack),
                  ),
                  Selector<DashboardPresenter, int>(
                    selector: (_, presenter) => presenter.vaultsCount,
                    builder: (_, vaultsCount, __) => Text(
                      '$vaultsCount Vaults',
                      style: textStylePoppins616.copyWith(color: clBlack),
                    ),
                  ),
                ],
              ),
              const Icon(Icons.arrow_forward_ios_outlined, color: clBlack),
            ],
          ),
        ),
      );
}
