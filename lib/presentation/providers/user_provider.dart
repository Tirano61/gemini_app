
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';


@riverpod
types.User geminiUser(Ref ref) {
  final geminiUser = const types.User(
    id: 'gemini-id',
    firstName: 'Gemini',
    imageUrl: 'https://picsum.photos/id/79/200/200',
  );

  return geminiUser;
}