part of 'chat_bloc.dart';

abstract class CourseChatState extends Equatable {
  const CourseChatState();

  @override
  List<Object> get props => [];
}

class CourseChatLoading extends CourseChatState {}

class CourseChatLoaded extends CourseChatState {
  final List<Chat> chats;

  CourseChatLoaded(this.chats);

  @override
  List<Object> get props => [chats];
}
