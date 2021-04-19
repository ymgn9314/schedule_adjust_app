// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_box.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FriendBoxAdapter extends TypeAdapter<FriendBox> {
  @override
  final int typeId = 1;

  @override
  FriendBox read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FriendBox(
      uid: fields[0] as String,
      displayName: fields[1] as String,
      photoUrl: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FriendBox obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.displayName)
      ..writeByte(2)
      ..write(obj.photoUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FriendBoxAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
