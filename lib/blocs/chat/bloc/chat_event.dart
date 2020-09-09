part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class FetchChats extends ChatEvent {
  final String userId;

  FetchChats(this.userId);

  @override
  List<Object> get props => [userId];
}

class AddChat extends ChatEvent {
  final String fromUserId;
  final String toUserId;

  AddChat({@required this.fromUserId, @required this.toUserId})
      : assert(fromUserId != null),
        assert(toUserId != null);

  @override
  List<Object> get props => [fromUserId, toUserId];

  List<String> get userIds => <String>[fromUserId, toUserId];
}
