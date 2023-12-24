import 'package:hive/hive.dart';
import 'package:flutter/widgets.dart';

import 'package:guardian_keyper/data/services/preferences_service.dart';
import 'package:guardian_keyper/feature/message/domain/entity/message_model.dart';

export 'package:get_it/get_it.dart';

typedef MessageRepositoryEvent = ({
  String key,
  MessageModel? message,
  bool isDeleted,
});

/// Depends on [PreferencesService]
class MessageRepository with WidgetsBindingObserver {
  late final Box<MessageModel> _storage;

  Iterable<MessageModel> get values => _storage.values;

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
        await _storage.flush();
      case _:
    }
  }

  Future<MessageRepository> init({required HiveCipher encryptionCipher}) async {
    Hive.registerAdapter<MessageModel>(MessageModelAdapter());
    _storage = await Hive.openBox<MessageModel>(
      'messages',
      encryptionCipher: encryptionCipher,
    );
    WidgetsBinding.instance.addObserver(this);
    return this;
  }

  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    await _storage.close();
  }

  MessageModel? get(String key) => _storage.get(key);

  bool containsKey(String key) => _storage.containsKey(key);

  Future<void> put(String key, MessageModel value) => _storage.put(key, value);

  Future<void> delete(String key) => _storage.delete(key);

  Stream<MessageRepositoryEvent> watch([String? key]) =>
      _storage.watch(key: key).map((e) => (
            key: e.key as String,
            message: e.value as MessageModel?,
            isDeleted: e.deleted,
          ));

  Future<void> prune() async {
    await _storage.deleteAll(
        _storage.values.where((e) => e.isForPrune).map((e) => e.aKey));
    await _storage.compact();
  }

  Future<void> flush() => _storage.flush();
}

class MessageModelAdapter extends TypeAdapter<MessageModel> {
  @override
  final typeId = MessageModel.typeId;

  @override
  MessageModel read(BinaryReader reader) =>
      MessageModel.fromBytes(reader.readByteList());

  @override
  void write(BinaryWriter writer, MessageModel obj) =>
      writer.writeByteList(obj.toBytes());
}
