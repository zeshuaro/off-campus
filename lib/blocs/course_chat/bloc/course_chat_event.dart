part of 'chat_bloc.dart';

abstract class CourseChatEvent extends Equatable {
  const CourseChatEvent();

  @override
  List<Object> get props => [];
}

class LoadCourseChats extends CourseChatEvent {
  final String userId;

  LoadCourseChats(this.userId);

  @override
  List<Object> get props => [userId];
}

class UpdateCourseChats extends CourseChatEvent {
  final List<Chat> chats;

  UpdateCourseChats(this.chats);

  @override
  List<Object> get props => [chats];
}
