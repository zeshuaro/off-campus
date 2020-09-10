enum ChatType { private, course, unknown }

ChatType stringToChatType(String string) {
  if (string == _ChatTypes.private) {
    return ChatType.private;
  } else if (string == _ChatTypes.course) {
    return ChatType.course;
  }

  return ChatType.unknown;
}

String chatTypeToString(ChatType chatType) {
  if (chatType == ChatType.private) {
    return _ChatTypes.private;
  } else if (chatType == ChatType.course) {
    return _ChatTypes.course;
  }

  return _ChatTypes.unknown;
}

class _ChatTypes {
  static const String private = 'private';
  static const String course = 'course';
  static const String unknown = 'unknown';
}
