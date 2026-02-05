import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../storage/storage_provider.dart';
import 'auth_interceptor.dart';
import 'error_interceptor.dart';

part 'dio_provider.g.dart';

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final storage = ref.watch(secureStorageProvider);
  
  final dio = Dio(
    BaseOptions(
      // 10.0.2.2 is for Android Emulator to access localhost
      // For iOS Simulator use 127.0.0.1 or localhost
      // For real device, use your machine's local IP
      baseUrl: 'http://10.0.2.2:8000', 
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.add(AuthInterceptor(storage));
  dio.interceptors.add(ErrorInterceptor());
  dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true)); // Debug

  return dio;
}
