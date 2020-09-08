import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:offcampus/repos/chat/chat_repo.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepo _chatRepo;

  ChatBloc(this._chatRepo) : super(ChatInitial());

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if (event is FetchChats) {
      yield* _mapFetchChatsToState(event);
    } else if (event is AddChat) {
      yield* _mapAddChatToState(event);
    }
  }

  Stream<ChatState> _mapFetchChatsToState(FetchChats event) async* {
    final currState = state;
    if (currState is ChatInitial) {
      try {
        final chats = await _chatRepo.fetchChats(event.userId);
        yield ChatSuccess(chats);
      } catch (_) {
        yield ChatFailure();
      }
    }
  }

  Stream<ChatState> _mapAddChatToState(AddChat event) async* {
    final currState = state;
    if (currState is! ChatFailure) {
      try {
        final chat = await _chatRepo.addChat(event.userIds);
        List<Chat> chats;

        if (currState is ChatInitial) {
          chats = await _chatRepo.fetchChats(event.fromUserId);
        } else if (currState is ChatSuccess) {
          chats = List.from(currState.chats);
          chats.insert(0, chat);
        }

        yield ChatSuccess(chats);
      } catch (_) {
        yield ChatFailure();
      }
    }
  }
}
