import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:offcampus/repos/message/message_repo.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final MessageRepo _messageRepo;
  StreamSubscription _messagesSubscription;

  MessageBloc(this._messageRepo) : super(MessageLoading());

  @override
  Stream<MessageState> mapEventToState(MessageEvent event) async* {
    if (event is LoadMessages) {
      yield* _mapLoadMessagesToState(event);
    } else if (event is AddMessage) {
      yield* _mapAddMessageToState(event);
    } else if (event is UpdateMessages) {
      yield* _mapUpdateMessageToState(event);
    }
  }

  Stream<MessageState> _mapLoadMessagesToState(LoadMessages event) async* {
    await _messagesSubscription?.cancel();
    _messagesSubscription = _messageRepo.messages(event.chatId).listen(
          (messages) => add(UpdateMessages(messages)),
        );
  }

  Stream<MessageState> _mapAddMessageToState(AddMessage event) async* {
    await _messageRepo.addMessage(event.userId, event.chatId, event.text);
  }

  Stream<MessageState> _mapUpdateMessageToState(UpdateMessages event) async* {
    yield MessageLoaded(event.messages);
  }
}
