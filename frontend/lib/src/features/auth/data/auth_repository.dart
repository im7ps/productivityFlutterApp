import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/errors/failure.dart';
import '../../../core/networking/dio_provider.dart';
import '../../../core/networking/api_request.dart';
import '../../../core/storage/storage_provider.dart';
import 'models/token.dart';
import 'models/user.dart';

part 'auth_repository.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository(
    dio: ref.watch(dioProvider),
    storage: ref.watch(secureStorageProvider),
  );
}

class AuthRepository {
  final Dio _dio;
  final dynamic _storage; 

  AuthRepository({required Dio dio, required dynamic storage}) 
      : _dio = dio, _storage = storage;

  Future<Either<Failure, UserPublic>> signUp({
    required String username,
    required String email,
    required String password,
  }) {
    return makeRequest(
      () => _dio.post(
        '/api/v1/auth/register',
        data: {
          'username': username,
          'email': email,
          'password': password,
        },
      ),
      (data) => UserPublic.fromJson(data),
    );
  }

  Future<Either<Failure, Token>> login({
    required String username,
    required String password,
  }) {
    return makeRequest(
      () => _dio.post(
        '/api/v1/auth/login',
        data: {
          'username': username,
          'password': password,
          'grant_type': 'password',
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      ),
      (data) {
        final token = Token.fromJson(data);
        // Side effect: Save token. 
        // Note: Ideally, storage should be handled in the Service/Notifier layer, 
        // but keeping it here for continuity with previous implementation 
        // is acceptable for now, though it mixes concerns slightly.
        // We make it sync here since makeRequest expects a pure decoder.
        // If storage is async, we might need to chain tasks.
        _storage.write(key: StorageKeys.accessToken, value: token.accessToken);
        return token;
      },
    );
  }

  Future<Either<Failure, UserPublic>> getCurrentUser() {
    return makeRequest(
      () => _dio.get('/api/v1/users/me'),
      (data) => UserPublic.fromJson(data),
    );
  }

  Future<Either<Failure, UserPublic>> updateUser(UserUpdate data) {
    return makeRequest(
      () => _dio.patch(
        '/api/v1/users/me',
        data: data.toJson(),
      ),
      (data) => UserPublic.fromJson(data),
    );
  }
  
  Future<void> logout() async {
      await _storage.delete(key: StorageKeys.accessToken);
  }
}
