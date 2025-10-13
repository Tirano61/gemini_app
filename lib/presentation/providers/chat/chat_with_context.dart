
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:gemini_app/config/gemini/gemini_impl.dart';
import 'package:gemini_app/presentation/providers/users/user_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'chat_with_context.g.dart';

final uuid = Uuid();

@Riverpod(keepAlive: true)
class ChatWithContext extends _$ChatWithContext {

  final geminiImpl = GeminiImpl();
  late User geminiUser;
  late String chatId;

  @override
  List<Message> build() {
    geminiUser = ref.read(geminiUserProvider);
    chatId = Uuid().v4();
    return [];
  }

  void addMessage({required PartialText partialText, required User user, List<XFile> images = const []}) {
    
    if(images.isNotEmpty){  
      addTextMesdsageWithImages(partialText, user, images);
      return;
    }

    _addTextMessage(partialText: partialText, author: user);
  }

  void _addTextMessage({ required PartialText partialText, required User author}) {
    
    _createTextMessage(partialText.text, author);
    _geminiTextResponseStream(partialText.text);
  }

  addTextMesdsageWithImages(PartialText partialText, User author, List<XFile> images)async {
    
    for(XFile image in images) {
      _createImageMessage(image, author);
    }
    await Future.delayed(const Duration(milliseconds: 10));
    _createTextMessage(partialText.text, author);

    _geminiTextResponseStream( partialText.text,  images: images );
  }

  void _geminiTextResponseStream(String prompt, {List<XFile> images = const []})async {

    _createTextMessage('Gemini esta pensando...', ref.read(geminiUserProvider));

    geminiImpl.getChatStream(prompt, chatId, files: images).listen((respChunk) {
      if(respChunk.isEmpty) return;

      final updatedMessages = [ ...state ];
      final updateMessage = ( updatedMessages.first as TextMessage).copyWith(
        text: respChunk,
      );

      updatedMessages[0] = updateMessage;

      state = updatedMessages;
    });

  }

  // Helper Methods
  void newChat() {
    chatId = Uuid().v4();
    state = [];
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

  void _createImageMessage(XFile image, User author) async {
    final message = ImageMessage(
      id: uuid.v4(),
      author: author,
      uri: image.path,
      name: image.name,
      size: await image.length(),
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    state = [ message, ...state ];
  }

}