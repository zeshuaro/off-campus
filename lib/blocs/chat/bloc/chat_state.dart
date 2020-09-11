part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<Chat> chats;

  ChatLoaded(this.chats);

  @override
  List<Object> get props => [chats];

  @override
  String toString() => 'ChatLoaded: { chats: ${chats.length} }';
}
