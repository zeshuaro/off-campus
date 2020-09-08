import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:offcampus/common/utils.dart';
import 'package:offcampus/repos/auth/models/user.dart';

part 'chat.g.dart';

@JsonSerializable()
class Chat extends Equatable {
  final String id;
  final List<MyUser> users;
  final String lastMessage;
  final String lastMessageUser;

  @JsonKey(
      fromJson: Utils.timestampToDatetime, toJson: Utils.datetimeToTimestamp)
  final DateTime updatedAt;

  Chat(this.id, this.users, this.lastMessage, this.lastMessageUser,
      this.updatedAt);

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
  Map<String, dynamic> toJson() => _$ChatToJson(this);

  @override
  List<Object> get props =>
      [id, users, lastMessage, lastMessageUser, updatedAt];
}
