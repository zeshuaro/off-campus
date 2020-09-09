part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatFailure extends ChatState {}

class ChatSuccess extends ChatState {
  final List<Chat> chats;
  final Chat chat;

  ChatSuccess(this.chats, [this.chat]);

  @override
  List<Object> get props => [chats, chat];
}
