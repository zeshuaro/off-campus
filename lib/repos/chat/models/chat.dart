import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:offcampus/common/utils.dart';
import 'package:offcampus/repos/auth/models/user.dart';

part 'chat.g.dart';

@CopyWith()
@JsonSerializable()
class Chat extends Equatable {
  final String id;
  final List<MyUser> users;
  final String lastMessage;
  final String lastMessageUser;

  @JsonKey(defaultValue: false)
  final bool isInit;

  @JsonKey(
      fromJson: Utils.timestampToDatetime, toJson: Utils.datetimeToTimestamp)
  final DateTime updatedAt;

  Chat({
    @required this.id,
    @required this.users,
    this.lastMessage,
    this.lastMessageUser,
    this.updatedAt,
    this.isInit = false,
  })  : assert(id != null),
        assert(users != null);

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
  Map<String, dynamic> toJson() => _$ChatToJson(this);

  @override
  List<Object> get props =>
      [id, users, lastMessage, lastMessageUser, updatedAt, isInit];
}
