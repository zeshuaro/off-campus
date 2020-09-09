part of 'message_bloc.dart';

abstract class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object> get props => [];
}

class MessageInitial extends MessageState {}

class MessageFailure extends MessageState {}

class MessageSuccess extends MessageState {
  final List<Message> messages;

  MessageSuccess(
    this.messages,
  );

  @override
  List<Object> get props => [messages];
}
