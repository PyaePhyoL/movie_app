import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:movie_app/data/vos/base_actor_vo.dart';
import 'package:movie_app/persistence/hive_constants.dart';

import 'movie_vo.dart';

part 'actor_vo.g.dart';

@JsonSerializable()
@HiveType(typeId: HIVE_TYPE_ID_ACTOR_VO, adapterName: "ActorVOAdapter")
class ActorVO extends BaseActorVO {
  @JsonKey(name: "adult")
  @HiveField(0)
  bool adult;

  @JsonKey(name: "id")
  @HiveField(1)
  int id;

  @JsonKey(name: "known_for")
  @HiveField(2)
  List<MovieVO> knownFor;

  @JsonKey(name: "popularity")
  @HiveField(3)
  double popularity;

  ActorVO(
    this.adult,
    this.id,
    this.knownFor,
    this.popularity,
    String name,
    String profilePath,
  ) : super(name, profilePath);

  factory ActorVO.fromJson(Map<String, dynamic> json) =>
      _$ActorVOFromJson(json);

  Map<String, dynamic> toJson() => _$ActorVOToJson(this);
}
