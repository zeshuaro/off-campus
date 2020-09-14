import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offcampus/blocs/blocs.dart';
import 'package:offcampus/common/consts.dart';
import 'package:offcampus/repos/chat/chat_repo.dart';
import 'package:offcampus/screens/chat/chat_page.dart';
import 'package:offcampus/widgets/widgets.dart';

class CourseChatListPage extends StatefulWidget {
  @override
  _CourseChatListPageState createState() => _CourseChatListPageState();
}

class _CourseChatListPageState extends State<CourseChatListPage> {
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = context.bloc<AuthBloc>().state.user;
    context.bloc<CourseChatBloc>()..add(LoadCourseChats(user));
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseChatBloc, CourseChatState>(
      builder: (context, state) {
        if (state is CourseChatLoaded) {
          var chats = state.chats;
          if (_textController.text.isNotEmpty) {
            chats = state.searchResults;
          }

          return Padding(
            padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
            child: Column(
              children: [
                SearchBar(
                  controller: _textController,
                  hintText: 'Search for course chats',
                  onChanged: (String string) {
                    context
                        .bloc<CourseChatBloc>()
                        .add(SearchCourseChats(string));
                  },
                  clearTextCallback: () => setState(() {}),
                ),
                WidgetPadding(),
                Expanded(
                  child: chats.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(bottom: 16),
                          itemCount: chats.length,
                          itemBuilder: (context, index) {
                            return _CourseChatCard(chat: chats[index]);
                          },
                        )
                      : Center(
                          child: Text(
                            'No course chats found',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                ),
              ],
            ),
          );
        }

        return LoadingWidget();
      },
    );
  }
}

class _CourseChatCard extends StatelessWidget {
  final Chat chat;

  const _CourseChatCard({Key key, @required this.chat})
      : assert(chat != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyCard(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.of(context).push(ChatPage.route(chat)),
        child: Padding(
          padding: kLayoutPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chat.title,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              WidgetPaddingSm(),
              Row(
                children: [
                  Icon(Icons.people, color: Colors.grey, size: 18),
                  SizedBox(width: 4),
                  Text(
                    '${chat.numMembers} • Last message ${chat.relativeUpdatedAt}',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
