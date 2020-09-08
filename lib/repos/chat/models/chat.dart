import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:offcampus/repos/auth/models/user.dart';

part 'chat.g.dart';

@JsonSerializable()
class Chat extends Equatable {
  final List<MyUser> users;

  Chat(this.users);

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
  Map<String, dynamic> toJson() => _$ChatToJson(this);

  @override
  List<Object> get props => [users];
}
