



import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';

class GeminiImpl {
  
  
  final Dio _http = Dio(
    BaseOptions(
      // Use a safe fallback if API_BASE_URL is not defined to avoid
      // a runtime Null check operator exception. Prefer configuring
      // the .env file with the correct URL in production.
      baseUrl: dotenv.env['ENDPOINT_API_URL'] ?? 'http://localhost:3000',
      
  ));

  Future<String> getResponse(String prompt) async {
    try{
      final body = {'prompt': prompt};
      final response = await _http.post('/basic-prompt', data: jsonEncode(body));

      return response.toString();
      
    }catch(e){
      print('Error en la peticion a Gemini: $e');
      return 'Error en la peticion a Gemini';
    }
  }

  Stream<String> getResponseStream(String prompt,{List<XFile> files = const []}) async* {
   
    yield* _getChatResponseStream(
      prompt: prompt, 
      endpoint: '/basic-prompt-stream',
      files: files,
    );
  }

  Stream<String> getChatStream(String prompt, String chatId, {List<XFile> files = const []}) async* {
   
    yield* _getChatResponseStream(
      endpoint: '/chat-stream',
      prompt: prompt, 
      files: files,
      formFields: {
        'chatId': chatId,
      }
    );
  }

  /// Emitir el stream de informacion
  Stream<String> _getChatResponseStream({required prompt, required endpoint, List<XFile> files = const[], Map<String,dynamic> formFields = const {}}) async* {
    try{
      
      //! Multipart 
      final formData = FormData();
      formData.fields.add(MapEntry('prompt', prompt));
      for(final entry in formFields.entries) {
        formData.fields.add(MapEntry(entry.key, entry.value.toString()));
      }
      
      if(files.isNotEmpty){
        for(XFile file in files) {
          formData.files.add(
            MapEntry(
              'files', 
              await MultipartFile.fromFile(file.path, filename: file.name)
            )
          );
        }
      }

      
      final response = await _http.post(
        endpoint, 
        data: formData, 
        options: Options(
          responseType: ResponseType.stream,
        )
      );

      final stream = response.data.stream as Stream<List<int>>;
      String buffer = '';

      await for (final chunk in stream) {
        final chunkString = utf8.decode(chunk, allowMalformed: true);
        buffer += chunkString;
        yield buffer;
      }

    }catch(e){
      yield 'Error en la peticion a Gemini';
    }
  }
}