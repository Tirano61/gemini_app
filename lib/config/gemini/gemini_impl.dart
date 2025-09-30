



import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  Stream<String> getResponseStream(String prompt) async* {
   try{
      // TODO: Tener presente que vamos a enviar imagenes tambien
      //! Multipart 
      final body = {'prompt': prompt};
      final response = await _http.post('/basic-prompt-stream', 
        data: jsonEncode(body), 
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