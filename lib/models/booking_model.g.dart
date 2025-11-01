// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookingModelAdapter extends TypeAdapter<BookingModel> {
  @override
  final int typeId = 2;

  @override
  BookingModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookingModel(
      namaLapangan: fields[0] as String,
      jenisLapangan: fields[1] as String,
      tanggalBooking: fields[2] as DateTime,
      jamMulai: fields[3] as String,
      durasiJam: fields[4] as int,
      totalHarga: fields[5] as int,
      statusPembayaran: fields[6] as String,
      userId: fields[7] as String,
      imageUrl: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BookingModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.namaLapangan)
      ..writeByte(1)
      ..write(obj.jenisLapangan)
      ..writeByte(2)
      ..write(obj.tanggalBooking)
      ..writeByte(3)
      ..write(obj.jamMulai)
      ..writeByte(4)
      ..write(obj.durasiJam)
      ..writeByte(5)
      ..write(obj.totalHarga)
      ..writeByte(6)
      ..write(obj.statusPembayaran)
      ..writeByte(7)
      ..write(obj.userId)
      ..writeByte(8)
      ..write(obj.imageUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
