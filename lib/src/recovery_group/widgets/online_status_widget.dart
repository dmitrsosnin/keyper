import 'dart:async';
import 'package:flutter/material.dart';

import '/src/core/theme/theme.dart';
import '/src/core/model/core_model.dart';
import '/src/core/di_container.dart';

class OnlineStatusWidget extends StatefulWidget {
  final PeerId peerId;

  const OnlineStatusWidget({super.key, required this.peerId});

  @override
  State<OnlineStatusWidget> createState() => _OnlineStatusWidgetState();
}

class _OnlineStatusWidgetState extends State<OnlineStatusWidget> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    final networkService = context.read<DIContainer>().networkService;
    _timer = Timer.periodic(
      networkService.router.requestTimeout,
      (_) => networkService.pingPeer(widget.peerId),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<bool>(
        initialData: context
            .read<DIContainer>()
            .networkService
            .getPeerStatus(widget.peerId),
        stream: context
            .read<DIContainer>()
            .networkService
            .peerStatusChangeStream
            .where((e) => e.key == widget.peerId)
            .map((e) => e.value),
        builder: (_, s) => s.data == true
            ? Text(
                'Online',
                style: textStyleSourceSansPro412.copyWith(color: clGreen),
              )
            : Text(
                'Offline',
                style: textStyleSourceSansPro412.copyWith(color: clRed),
              ),
      );
}
