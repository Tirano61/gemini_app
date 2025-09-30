
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
    _createTextMessage(partialText.text, author);

    //_geminiTextResponse(partialText.text);
    _geminiTextResponseStream(partialText.text);
  }

  void _geminiTextResponse(String prompt)async {
    _setGeminiWritingStatus(  true);

    final geminiUser = ref.read(geminiUserProvider);

    final textResp = await geminiImpl.getResponse(prompt);

    _setGeminiWritingStatus(false);
    
    _createTextMessage(textResp, geminiUser);
  }
  void _geminiTextResponseStream(String prompt)async {

    _createTextMessage('Gemini esta pensando...', ref.read(geminiUserProvider));

    geminiImpl.getResponseStream(prompt).listen((respChunk) {
      if(respChunk.isEmpty) return;

      final updatedMessages = [ ...state ];
      final updateMessage = ( updatedMessages.first as TextMessage).copyWith(
        text: respChunk,
      );

      updatedMessages[0] = updateMessage;

      state = updatedMessages;
    });

  }

  void _createTextMessage(String text, User author){
    final message = TextMessage(
      id: uuid.v4(),
      author: author,
      text: text,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    state = [ message, ...state ];
  }

  // Helper Methods
  void _setGeminiWritingStatus(bool isWriting) {
    final isGeminiWriting = ref.read(isGeminiWritingProvider.notifier);
    isWriting ? isGeminiWriting.setIsWriting() : isGeminiWriting.setIsNotWriting();

  }
}