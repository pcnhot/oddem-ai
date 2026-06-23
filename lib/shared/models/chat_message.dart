import 'package:equatable/equatable.dart';

enum ChatRole { user, assistant }

/// A single message in the AI Designer mock chat.
class ChatMessage extends Equatable {
  const ChatMessage({
    required this.role,
    required this.text,
    required this.time,
  });

  final ChatRole role;
  final String text;
  final DateTime time;

  bool get isUser => role == ChatRole.user;

  @override
  List<Object?> get props => [role, text, time];
}
