// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adp.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NewsModelAdapter extends TypeAdapter<NewsModelAdp> {
  @override
  final int typeId = 0;

  @override
  NewsModelAdp read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NewsModelAdp(
      id: fields[0] as int?,
      title: fields[1] as String?,
      text: fields[2] as String?,
      url: fields[3] as String?,
      image: fields[4] as String?,
      publishDate: fields[5] as String?,
      author: fields[6] as String?,
      language: fields[7] as String?,
      sourceCountry: fields[8] as String?,
      sentiment: fields[9] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, NewsModelAdp obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.text)
      ..writeByte(3)
      ..write(obj.url)
      ..writeByte(4)
      ..write(obj.image)
      ..writeByte(5)
      ..write(obj.publishDate)
      ..writeByte(6)
      ..write(obj.author)
      ..writeByte(7)
      ..write(obj.language)
      ..writeByte(8)
      ..write(obj.sourceCountry)
      ..writeByte(9)
      ..write(obj.sentiment);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
