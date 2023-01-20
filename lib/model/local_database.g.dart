// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalDatabaseAdapter extends TypeAdapter<LocalDatabase> {
  @override
  final int typeId = 0;

  @override
  LocalDatabase read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalDatabase(
      uuid: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      date: fields[3] as String,
      notify: fields[5] as bool,
      time: fields[4] as String,
      done: fields[6] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, LocalDatabase obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.uuid)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.time)
      ..writeByte(5)
      ..write(obj.notify)
      ..writeByte(6)
      ..write(obj.done);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalDatabaseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
