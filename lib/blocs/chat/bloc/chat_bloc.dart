import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:offcampus/repos/chat/chat_repo.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepo _chatRepo;
  StreamSubscription _chatsSubscription;

  ChatBloc(this._chatRepo) : super(ChatLoading());

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if (event is LoadChats) {
      yield* _mapLoadChatsToState(event);
    } else if (event is AddChat) {
      yield* _mapAddChatToState(event);
    } else if (event is UpdateChat) {
      yield* _mapUpdateChatToState(event);
    } else if (event is UpdateChats) {
      yield* _mapUpdateChatsToState(event);
    }
  }

  Stream<ChatState> _mapLoadChatsToState(LoadChats event) async* {
    await _chatsSubscription?.cancel();
    _chatsSubscription = _chatRepo.chats(event.userId).listen(
          (chats) => add(UpdateChats(chats)),
        );
  }

  Stream<ChatState> _mapAddChatToState(AddChat event) async* {
    await _chatRepo.addChat(event.chat);
  }

  Stream<ChatState> _mapUpdateChatToState(UpdateChat event) async* {
    await _chatRepo.updateChat(event.chat);
  }

  Stream<ChatState> _mapUpdateChatsToState(UpdateChats event) async* {
    yield ChatLoaded(event.chats);
  }
}
