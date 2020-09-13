import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:offcampus/repos/auth/auth_repo.dart';
import 'package:offcampus/repos/chat/chat_repo.dart';

part 'course_chat_bloc.g.dart';

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
    } else if (event is SearchCourseChats) {
      yield* _mapSearchCourseChatsToState(event);
    }
  }

  Stream<CourseChatState> _mapLoadChatsToState(LoadCourseChats event) async* {
    await _courseChatsSubscription?.cancel();
    _courseChatsSubscription = _chatRepo.courseChats(event.currUser).listen(
          (chats) => add(UpdateCourseChats(chats)),
        );
  }

  Stream<CourseChatState> _mapUpdateChatsToState(
      UpdateCourseChats event) async* {
    yield CourseChatLoaded(chats: event.chats);
  }

  Stream<CourseChatState> _mapJoinCourseChatToState(
      JoinCourseChat event) async* {
    await _chatRepo.joinCourseChat(event.chatId, event.userId);
  }

  Stream<CourseChatState> _mapSearchCourseChatsToState(
      SearchCourseChats event) async* {
    final currState = state;
    if (currState is CourseChatLoaded) {
      final chats = List<Chat>.from(currState.chats).where((chat) {
        return chat.title.toLowerCase().contains(event.keyword.toLowerCase());
      }).toList();
      yield currState.copyWith(searchResults: chats);
    }
  }
}
