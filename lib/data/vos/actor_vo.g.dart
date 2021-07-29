// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'actor_vo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActorVOAdapter extends TypeAdapter<ActorVO> {
  @override
  final int typeId = 1;

  @override
  ActorVO read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActorVO(
      fields[0] as bool,
      fields[1] as int,
      (fields[2] as List)?.cast<MovieVO>(),
      fields[3] as double,
      fields[10] as String,
      fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ActorVO obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.adult)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.knownFor)
      ..writeByte(3)
      ..write(obj.popularity)
      ..writeByte(10)
      ..write(obj.name)
      ..writeByte(11)
      ..write(obj.profilePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActorVOAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActorVO _$ActorVOFromJson(Map<String, dynamic> json) {
  return ActorVO(
    json['adult'] as bool,
    json['id'] as int,
    (json['known_for'] as List)
        ?.map((e) =>
            e == null ? null : MovieVO.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['popularity'] as num)?.toDouble(),
    json['name'] as String,
    json['profile_path'] as String,
  );
}

Map<String, dynamic> _$ActorVOToJson(ActorVO instance) => <String, dynamic>{
      'name': instance.name,
      'profile_path': instance.profilePath,
      'adult': instance.adult,
      'id': instance.id,
      'known_for': instance.knownFor,
      'popularity': instance.popularity,
    };
