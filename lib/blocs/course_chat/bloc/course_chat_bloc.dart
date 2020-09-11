import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:offcampus/repos/chat/chat_repo.dart';

part 'course_chat_event.dart';
part 'course_chat_state.dart';

class CourseChatBloc extends Bloc<CourseChatEvent, CourseChatState> {
  final ChatRepo _chatRepo;
  StreamSubscription _courseChatsSubscription;

  CourseChatBloc(this._chatRepo) : super(CourseChatLoading());

  @override
  Stream<CourseChatState> mapEventToState(CourseChatEvent event) async* {
    if (event is LoadCourseChats) {
      yield* _mapLoadChatsToState(event);
    } else if (event is UpdateCourseChats) {
      yield* _mapUpdateChatsToState(event);
    } else if (event is JoinCourseChat) {
      yield* _mapJoinCourseChatToState(event);
    }
  }

  Stream<CourseChatState> _mapLoadChatsToState(LoadCourseChats event) async* {
    await _courseChatsSubscription?.cancel();
    _courseChatsSubscription = _chatRepo.courseChats(event.userId).listen(
          (chats) => add(UpdateCourseChats(chats)),
        );
  }

  Stream<CourseChatState> _mapUpdateChatsToState(
      UpdateCourseChats event) async* {
    yield CourseChatLoaded(event.chats);
  }

  Stream<CourseChatState> _mapJoinCourseChatToState(
      JoinCourseChat event) async* {
    await _chatRepo.joinCourseChat(event.chatId, event.userId);
  }
}
