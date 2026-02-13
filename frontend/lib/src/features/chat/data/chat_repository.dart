import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/networking/dio_provider.dart';

part 'chat_repository.g.dart';

class ChatRepository {
  final Dio _dio;

  ChatRepository(this._dio);

  Stream<String> streamChat(String message) async* {
    final response = await _dio.post(
      '/api/v1/chat/stream',
      data: {'message': message},
      options: Options(responseType: ResponseType.stream),
    );

    final stream = (response.data as ResponseBody).stream;
    
    yield* stream
        .map((unit8List) => unit8List.toList()) // Convert Uint8List to List<int>
        .transform(utf8.decoder);
  }
}

@riverpod
ChatRepository chatRepository(ChatRepositoryRef ref) {
  return ChatRepository(ref.watch(dioProvider));
}
