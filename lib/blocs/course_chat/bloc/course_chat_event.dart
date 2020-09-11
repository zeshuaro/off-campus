part of 'course_chat_bloc.dart';

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

  @override
  String toString() {
    return 'UpdateCourseChats: { chats: ${chats.length} }';
  }
}

class JoinCourseChat extends CourseChatEvent {
  final String chatId;
  final String userId;

  JoinCourseChat(this.chatId, this.userId);

  @override
  List<Object> get props => [chatId, userId];
}
