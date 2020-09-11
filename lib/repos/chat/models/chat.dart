import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:offcampus/common/utils.dart';
import 'package:offcampus/repos/chat/models/models.dart';
import 'package:timeago/timeago.dart' as timeago;

part 'chat.g.dart';

@CopyWith()
@JsonSerializable()
class Chat extends Equatable {
  final String id;
  final String title;
  final String lastMessage;
  final String lastMessageUser;
  final int numMembers;

  @JsonKey(defaultValue: <String>[])
  final List<String> userIds;

  @JsonKey(defaultValue: true)
  final bool isInit;

  @JsonKey(fromJson: stringToChatType, toJson: chatTypeToString)
  final ChatType type;

  @JsonKey(
      fromJson: Utils.timestampToDatetime, toJson: Utils.datetimeToTimestamp)
  final DateTime updatedAt;

  Chat({
    @required this.id,
    @required this.type,
    @required this.userIds,
    @required this.title,
    this.lastMessage,
    this.lastMessageUser,
    this.updatedAt,
    this.numMembers,
    this.isInit = true,
  })  : assert(id != null),
        assert(userIds != null),
        assert(title != null);

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
  Map<String, dynamic> toJson() => _$ChatToJson(this);

  @override
  List<Object> get props {
    return [
      id,
      type,
      userIds,
      title,
      lastMessage,
      lastMessageUser,
      updatedAt,
      numMembers,
      isInit,
    ];
  }

  String get relativeUpdatedAt => timeago.format(updatedAt);
}
