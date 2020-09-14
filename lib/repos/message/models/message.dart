import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:offcampus/common/utils.dart';

part 'message.g.dart';

@JsonSerializable()
class Message extends Equatable {
  final String id;
  final String userId;
  final String username;
  final String text;

  @JsonKey(
      fromJson: Utils.timestampToDatetime, toJson: Utils.datetimeToTimestamp)
  final DateTime createdAt;

  Message(this.id, this.userId, this.username, this.text, this.createdAt);

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);

  @override
  List<Object> get props => [id, userId, username, text, createdAt];
}
