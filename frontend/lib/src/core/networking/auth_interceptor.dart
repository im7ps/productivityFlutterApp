import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../storage/storage_provider.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage;
  final VoidCallback? onUnauthorized;

  AuthInterceptor(this._storage, {this.onUnauthorized});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.read(key: StorageKeys.accessToken);
    
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Token scaduto o non valido.
      // Triggeriamo la callback di logout se fornita.
      onUnauthorized?.call();
    }
    super.onError(err, handler);
  }
}

// Typedef per pulizia
typedef VoidCallback = void Function();
