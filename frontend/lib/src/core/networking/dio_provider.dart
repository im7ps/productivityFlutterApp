import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Preparazione per step successivo
import '../../features/auth/presentation/auth_state_provider.dart';
import '../storage/storage_provider.dart';
import 'auth_interceptor.dart';
import 'error_interceptor.dart';

part 'dio_provider.g.dart';

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final storage = ref.watch(secureStorageProvider);
  
  // Base URL da .env (fallback per sicurezza durante dev)
  final baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://10.0.2.2:8000';

  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.add(
    AuthInterceptor(
      storage,
      onUnauthorized: () async {
        // 1. Cancella il token
        await storage.delete(key: StorageKeys.accessToken);
        // 2. Invalida lo stato di Auth (che triggera il Router redirect)
        ref.invalidate(authStateProvider);
      },
    ),
  );
  
  dio.interceptors.add(ErrorInterceptor());
  
  // Loggare solo in debug mode
  assert(() {
    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
    return true;
  }());

  return dio;
}
