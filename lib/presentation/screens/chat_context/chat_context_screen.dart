
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gemini_app/presentation/providers/chat/chat_with_context.dart';
import 'package:gemini_app/presentation/providers/users/user_provider.dart';
import 'package:gemini_app/presentation/widgets/chat/custom_botton_input.dart';



class ChatContextScreen extends ConsumerWidget {
  const ChatContextScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final user = ref.watch(userProvider);
    final chatMessages = ref.watch(chatWithContextProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Conversacional'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_outlined),
            onPressed: () {
              final chatNotifier = ref.read(chatWithContextProvider.notifier);
              chatNotifier.newChat();
            },
          ),
        ],
      ),
      body: Chat(
        messages: chatMessages,
        onSendPressed: (_) {},
        user: user,
        theme: DarkChatTheme(),
        showUserNames: true,
        customBottomWidget: CustomBottomInput(
          onSend: (partialText, {images = const []}) {
            final chatNotifier = ref.read(chatWithContextProvider.notifier);
            chatNotifier.addMessage(partialText: partialText, user: user, images: images);
          },
        ),
      ),
    );
  }
}