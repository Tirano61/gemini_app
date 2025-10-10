
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gemini_app/presentation/providers/chat/basic_chat.dart';
import 'package:gemini_app/presentation/providers/chat/is_gemini_writing.dart';
import 'package:gemini_app/presentation/providers/users/user_provider.dart';
import 'package:gemini_app/presentation/widgets/chat/custom_botton_input.dart';
import 'package:image_picker/image_picker.dart';


class BasicPromptScreen extends ConsumerWidget {
  const BasicPromptScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final geminiUser = ref.watch(geminiUserProvider);
    final user = ref.watch(userProvider);
    final isGeminiWriting = ref.watch(isGeminiWritingProvider);
    final chatMessages = ref.watch(basicChatProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Prompt Screen'),
      ),
      body: Chat(
        messages: chatMessages,
        onSendPressed: (types.PartialText partialText) {
          /* final basicChatNotifier = ref.read(basicChatProvider.notifier);
          basicChatNotifier.addMessage(partialText: partialText, user: user); */
        },
        user: user,
        theme: DarkChatTheme(),
        //showUserAvatars: true,
        showUserNames: true,
        customBottomWidget: CustomBottomInput(onSend: (partialText, {images = const []}) {
          final basicChatNotifier = ref.read(basicChatProvider.notifier);
          basicChatNotifier.addMessage(partialText: partialText, user: user, images: images);

          print(images);
        },),
        /* onAttachmentPressed:()async {
          ImagePicker picker = ImagePicker();
          final List<XFile> images = await picker.pickMultiImage(limit: 4);
          if (images.isEmpty)return;

          print(images);
        }, */
        typingIndicatorOptions: TypingIndicatorOptions(
          typingUsers: isGeminiWriting ? [geminiUser] : [],
          customTypingWidget: Text('Gemini está pensando...'),
        ),
      ),
    );
  }
}