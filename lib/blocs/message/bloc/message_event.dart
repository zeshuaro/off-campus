part of 'message_bloc.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

class FetchMessages extends MessageEvent {
  final String chatId;

  FetchMessages(this.chatId);

  @override
  List<Object> get props => [chatId];
}

class AddMessage extends MessageEvent {
  final String userId;
  final String chatId;
  final String text;

  AddMessage(this.userId, this.chatId, this.text);

  @override
  List<Object> get props => [userId, chatId, text];
}
