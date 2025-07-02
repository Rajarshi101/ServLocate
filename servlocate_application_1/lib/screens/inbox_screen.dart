import 'package:flutter/material.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';

class InboxScreen extends StatelessWidget {
  final String currentUid;
  const InboxScreen({super.key, required this.currentUid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inbox')),
      body: const CometChatConversationsWithMessages(),
    );
  }
}
