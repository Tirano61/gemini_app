
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:gemini_app/config/gemini/gemini_impl.dart';
import 'package:gemini_app/presentation/providers/chat/is_gemini_writing.dart';
import 'package:gemini_app/presentation/providers/users/user_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'basic_chat.g.dart';

final uuid = Uuid();

@riverpod
class BasicChat extends _$BasicChat {

  final geminiImpl = GeminiImpl();

  @override
  List<Message> build() {
    return [];
  }

  void addMessage({required PartialText partialText, required User user}) {
    // TODO : Agregar condicion cuando vengan imagenes

    _addTextMessage(partialText: partialText, author: user);
  }

  void _addTextMessage({ required PartialText partialText, required User author}) {
    final message = TextMessage(
      id: uuid.v4(),
      author: author,
      text: partialText.text,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    state = [ message, ...state ];

    _geminiTextResponse(partialText.text);
  }

  void _geminiTextResponse(String prompt)async {
    final isGeminiWriting = ref.read(isGeminiWritingProvider.notifier);
    final geminiUser = ref.read(geminiUserProvider);

    isGeminiWriting.setIsWriting();

    final textResp = await geminiImpl.getResponse(prompt);

    isGeminiWriting.setIsNotWriting();
    final message = TextMessage(
      id: uuid.v4(),
      author: geminiUser,
      text: textResp,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    state = [ message, ...state ];
  }
}