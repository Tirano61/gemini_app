
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gemini_app/presentation/providers/user_provider.dart';
import 'package:uuid/uuid.dart';

final user = const types.User(
  id: 'user-id',
  firstName: 'John',
  lastName: 'Doe',
  imageUrl: 'https://picsum.photos/id/1/200/200',
);


final textMessage = <types.Message>[
  types.TextMessage(author: user,createdAt: DateTime.now().millisecondsSinceEpoch,id: Uuid().v4(),text: 'Hello, world! 1'),
  //types.TextMessage(author: user,createdAt: DateTime.now().millisecondsSinceEpoch,id: Uuid().v4(),text: 'Hello, world 2!'),
  //types.TextMessage(author: geminiUser,createdAt: DateTime.now().millisecondsSinceEpoch,id: Uuid().v4(),text: 'Hello, world 3!'),
];

class BasicPromptScreen extends ConsumerWidget {
  const BasicPromptScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final geminiUser = ref.watch(geminiUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Prompt Screen'),
      ),
      body: Chat(
        messages: [
          types.TextMessage(author: geminiUser, createdAt: DateTime.now().millisecondsSinceEpoch,id: Uuid().v4(),text: 'Hola, ¿cómo estás?'),
        ],
        onSendPressed: (types.PartialText partialText) {
          print('Message sent: ${partialText.text}');
        },
        user: user,
        theme: DarkChatTheme(),
        //showUserAvatars: true,
        showUserNames: true,
        typingIndicatorOptions: TypingIndicatorOptions(
          //typingUsers: [geminiUser],
          customTypingWidget: Text('Gemini está pensando...'),
        ),
      ),
    );
  }
}