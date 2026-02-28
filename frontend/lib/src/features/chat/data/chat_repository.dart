import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/networking/dio_provider.dart';

part 'chat_repository.g.dart';

class ChatRepository {
  final Dio _dio;

  ChatRepository(this._dio);

  Stream<String> streamChat(String message, String sessionId) async* {
    final response = await _dio.post(
      '/api/v1/chat/stream',
      data: {'message': message, 'session_id': sessionId},
      options: Options(responseType: ResponseType.stream),
    );

    final stream = (response.data as ResponseBody).stream;

    yield* stream
        .map(
          (unit8List) => unit8List.toList(),
        ) // Convert Uint8List to List<int>
        .transform(utf8.decoder);
  }

  Stream<String> confirmTool(bool confirmed, String sessionId) async* {
    final response = await _dio.post(
      '/api/v1/chat/confirm',
      data: {'confirmed': confirmed, 'session_id': sessionId},
      options: Options(responseType: ResponseType.stream),
    );

    final stream = (response.data as ResponseBody).stream;

    yield* stream
        .map((uint8List) => uint8List.toList())
        .transform(utf8.decoder);
  }
}

@riverpod
ChatRepository chatRepository(Ref ref) {
  return ChatRepository(ref.watch(dioProvider));
}
