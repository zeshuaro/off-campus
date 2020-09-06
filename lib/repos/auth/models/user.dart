import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class MyUser extends Equatable {
  final String id;
  final String name;
  final String university;
  final String faculty;
  final String degree;

  MyUser(this.id, this.name, this.university, this.faculty, this.degree);

  factory MyUser.fromJson(Map<String, dynamic> json) => _$MyUserFromJson(json);
  Map<String, dynamic> toJson() => _$MyUserToJson(this);

  @override
  List<Object> get props => [id, name, university, faculty, degree];
}
