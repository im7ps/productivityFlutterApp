import 'package:dio/dio.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response != null) {
      final statusCode = err.response?.statusCode;
      final data = err.response?.data;

      // Handle 401 Unauthorized
      if (statusCode == 401) {
        // Here we could trigger a global event, but for now we just ensure
        // the error message is clear.
        // We will preserve the DioException but maybe update the message.
        return handler.next(
          err.copyWith(
            message: 'Session expired or unauthorized. Please login again.',
          ),
        );
      }

      // Handle 422 Validation Error (FastAPI)
      if (statusCode == 422 && data is Map<String, dynamic>) {
        if (data.containsKey('detail')) {
          final detail = data['detail'];
          String parsedMessage = 'Validation Error';

          if (detail is List) {
            // FastAPI standard: list of objects with loc, msg, type
            final messages = detail.map((e) {
              if (e is Map) {
                final loc = (e['loc'] as List?)?.last?.toString() ?? 'Field';
                final msg = e['msg']?.toString() ?? 'Invalid';
                return '$loc: $msg';
              }
              return e.toString();
            }).toList();
            parsedMessage = messages.join('\n');
          } else if (detail is String) {
            parsedMessage = detail;
          }

          // Return a new DioException with the parsed message
          return handler.next(
            DioException(
              requestOptions: err.requestOptions,
              response: err.response,
              type: err.type,
              error: parsedMessage, // We store the readable string in 'error'
              message: parsedMessage,
            ),
          );
        }
      }
      
      // Generic Server Message parsing if 'detail' is present for other codes
      if (data is Map<String, dynamic> && data.containsKey('detail')) {
         final detail = data['detail'];
         if (detail is String) {
             return handler.next(err.copyWith(message: detail, error: detail));
         }
      }
    }

    super.onError(err, handler);
  }
}
