import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:offcampus/repos/message/message_repo.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final MessageRepo _messageRepo;

  MessageBloc(this._messageRepo) : super(MessageInitial());

  @override
  Stream<MessageState> mapEventToState(MessageEvent event) async* {
    if (event is FetchMessages) {
      yield* _mapFetchMessagesToState(event);
    } else if (event is AddMessage) {
      yield* _mapAddMessageToState(event);
    }
  }

  Stream<MessageState> _mapFetchMessagesToState(FetchMessages event) async* {
    final currState = state;
    if (currState is MessageInitial) {
      try {
        final messages = await _messageRepo.fetchMessages(event.chatId);
        yield MessageSuccess(messages);
      } catch (_) {
        yield MessageFailure();
      }
    }
  }

  Stream<MessageState> _mapAddMessageToState(AddMessage event) async* {
    final currState = state;
    if (currState is MessageSuccess) {
      try {
        final message = await _messageRepo.addMessage(
            event.userId, event.chatId, event.text);
        final messages = List.from(currState.messages);
        messages.insert(0, message);

        yield MessageSuccess(messages);
      } catch (_) {
        yield MessageFailure();
      }
    }
  }
}
