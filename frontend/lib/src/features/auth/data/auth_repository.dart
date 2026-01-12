import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/errors/failure.dart';
import '../../../core/networking/dio_provider.dart';
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
  final dynamic _storage; // Typed dynamically to avoid circular dependency issues in mock/test generation if not careful, but usually FlutterSecureStorage

  AuthRepository({required Dio dio, required dynamic storage}) 
      : _dio = dio, _storage = storage;

  Future<Either<Failure, UserPublic>> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/api/v1/auth/register',
        data: {
          'username': username,
          'email': email,
          'password': password,
        },
      );
      
      return Right(UserPublic.fromJson(response.data));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, Token>> login({
    required String username,
    required String password,
  }) async {
    try {
      // OAuth2 requires x-www-form-urlencoded
      final response = await _dio.post(
        '/api/v1/auth/login',
        data: {
          'username': username,
          'password': password,
          'grant_type': 'password',
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );
      
      final token = Token.fromJson(response.data);
      
      // Save token
      await _storage.write(key: StorageKeys.accessToken, value: token.accessToken);
      
      return Right(token);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, UserPublic>> getCurrentUser() async {
    try {
      final response = await _dio.get('/api/v1/users/me');
      return Right(UserPublic.fromJson(response.data));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, UserPublic>> updateUser(Map<String, dynamic> data) async {
    try {
      final response = await _dio.patch(
        '/api/v1/users/me',
        data: data,
      );
      return Right(UserPublic.fromJson(response.data));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  
  Future<void> logout() async {
      await _storage.delete(key: StorageKeys.accessToken);
  }

  Failure _handleDioError(DioException e) {
    if (e.response != null) {
      final data = e.response!.data;
      // Try to parse "detail" from FastAPI standard error
      if (data is Map<String, dynamic> && data.containsKey('detail')) {
         final detail = data['detail'];
         if (detail is String) return ServerFailure(detail, e.response?.statusCode);
         // If detail is a list (validation error), we simplify it for now
         return ServerFailure('Validation Error', e.response?.statusCode);
      }
      return ServerFailure('Server Error: ${e.response?.statusCode}', e.response?.statusCode);
    }
    return const NetworkFailure();
  }
}
