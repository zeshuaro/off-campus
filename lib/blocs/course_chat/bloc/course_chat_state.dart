part of 'course_chat_bloc.dart';

abstract class CourseChatState extends Equatable {
  const CourseChatState();

  @override
  List<Object> get props => [];
}

class CourseChatLoading extends CourseChatState {}

@CopyWith()
class CourseChatLoaded extends CourseChatState {
  final List<Chat> chats;
  final List<Chat> searchResults;

  CourseChatLoaded({@required this.chats, this.searchResults = const <Chat>[]})
      : assert(chats != null);

  @override
  List<Object> get props => [chats, searchResults];

  @override
  String toString() =>
      'CourseChatLoaded: { chats: ${chats.length}, searchResults: ${searchResults.length} }';
}
