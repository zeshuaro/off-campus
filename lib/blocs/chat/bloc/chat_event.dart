part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class LoadChats extends ChatEvent {
  final String userId;

  LoadChats(this.userId);

  @override
  List<Object> get props => [userId];
}

class AddChat extends ChatEvent {
  final List<String> userIds;

  AddChat(this.userIds);

  @override
  List<Object> get props => [userIds];
}

class UpdateChats extends ChatEvent {
  final List<Chat> chats;

  UpdateChats(this.chats);

  @override
  List<Object> get props => [chats];
}
