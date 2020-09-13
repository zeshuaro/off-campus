import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:offcampus/common/consts.dart';

part 'uni.g.dart';

@JsonSerializable()
class Uni extends Equatable {
  final String name;
  final String logo;
  final List<String> faculties;

  Uni(this.name, this.logo, this.faculties);

  factory Uni.fromJson(Map<String, dynamic> json) => _$UniFromJson(json);
  Map<String, dynamic> toJson() => _$UniToJson(this);

  @override
  List<Object> get props => [name, logo, faculties];

  List<String> get allFaculties => <String>[kAllKeyword, ...faculties];
}
