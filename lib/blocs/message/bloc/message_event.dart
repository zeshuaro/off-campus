part of 'message_bloc.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

class InitMessages extends MessageEvent {}

class LoadMessages extends MessageEvent {
  final String chatId;

  LoadMessages(this.chatId);

  @override
  List<Object> get props => [chatId];
}

class AddMessage extends MessageEvent {
  final String userId;
  final String username;
  final String chatId;
  final String text;

  AddMessage(this.userId, this.username, this.chatId, this.text);

  @override
  List<Object> get props => [userId, username, chatId, text];
}

class UpdateMessages extends MessageEvent {
  final List<Message> messages;

  UpdateMessages(this.messages);

  @override
  List<Object> get props => [messages];

  @override
  String toString() => 'UpdateMessages: { messages: ${messages.length} }';
}
