// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lapangan_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TempatOlahragaAdapter extends TypeAdapter<TempatOlahraga> {
  @override
  final int typeId = 0;

  @override
  TempatOlahraga read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TempatOlahraga(
      id: fields[0] as String,
      namaTempat: fields[1] as String,
      jenisLapangan: fields[2] as String,
      lokasiWilayah: fields[3] as String,
      ratingAvg: fields[4] as double,
      hargaSewa: fields[5] as int,
      latitude: fields[6] as double,
      longitude: fields[7] as double,
      imageUrl: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TempatOlahraga obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.namaTempat)
      ..writeByte(2)
      ..write(obj.jenisLapangan)
      ..writeByte(3)
      ..write(obj.lokasiWilayah)
      ..writeByte(4)
      ..write(obj.ratingAvg)
      ..writeByte(5)
      ..write(obj.hargaSewa)
      ..writeByte(6)
      ..write(obj.latitude)
      ..writeByte(7)
      ..write(obj.longitude)
      ..writeByte(8)
      ..write(obj.imageUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TempatOlahragaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
