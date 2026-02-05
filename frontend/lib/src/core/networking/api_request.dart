import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import '../errors/failure.dart';

/// A helper function to wrap API calls with robust error handling using TaskEither.
Future<Either<Failure, T>> makeRequest<T>(
  Future<Response> Function() request,
  T Function(dynamic data) decoder,
) {
  return TaskEither<Failure, T>.tryCatch(
    () async {
      final response = await request();
      return decoder(response.data);
    },
    (error, stackTrace) {
      if (error is DioException) {
        return _handleDioError(error);
      }
      return Failure.unknown(error.toString());
    },
  ).run();
}

Failure _handleDioError(DioException e) {
  // 1. Network / Connection Errors
  if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.sendTimeout ||
      e.type == DioExceptionType.receiveTimeout ||
      e.type == DioExceptionType.connectionError) {
    return const Failure.network();
  }

  if (e.response != null) {
    final statusCode = e.response?.statusCode;
    final data = e.response?.data;

    // 2. Validation Errors (422)
    if (statusCode == 422 && data is Map<String, dynamic>) {
      if (data.containsKey('detail')) {
        final detail = data['detail'];
        if (detail is List) {
          // Parse FastAPI Pydantic errors into a Map<Field, Message>
          final Map<String, String> errorMap = {};
          
          for (var item in detail) {
            if (item is Map) {
              // "loc": ["body", "username"] -> key: "username"
              final locList = item['loc'] as List?;
              final field = locList?.isNotEmpty == true 
                  ? locList!.last.toString() 
                  : 'global';
              
              final msg = item['msg']?.toString() ?? 'Invalid value';
              errorMap[field] = msg;
            }
          }
          return Failure.validation(errorMap, 'Please check your input.');
        }
      }
    }

    // 3. Other Server Errors
    // Use the error message processed by ErrorInterceptor if available,
    // otherwise fallback to parsing 'detail' or 'message' manually.
    final msg = e.error?.toString() ?? _parseErrorMessage(data) ?? e.message ?? 'Server Error';
    return Failure.server(msg, statusCode);
  }

  // 4. Fallback
  return Failure.server(e.message ?? 'Unknown Dio Error');
}

String? _parseErrorMessage(dynamic data) {
  if (data is Map<String, dynamic>) {
    if (data.containsKey('detail') && data['detail'] is String) {
      return data['detail'];
    }
    if (data.containsKey('message') && data['message'] is String) {
      return data['message'];
    }
  }
  return null;
}
