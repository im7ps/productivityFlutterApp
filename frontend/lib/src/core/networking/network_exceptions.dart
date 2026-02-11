import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_exceptions.freezed.dart';

@freezed
abstract class NetworkExceptions with _$NetworkExceptions {
  const factory NetworkExceptions.requestCancelled() = RequestCancelled;

  const factory NetworkExceptions.unauthorizedRequest(String reason) = UnauthorizedRequest;

  const factory NetworkExceptions.badRequest() = BadRequest;

  const factory NetworkExceptions.notFound(String reason) = NotFound;

  const factory NetworkExceptions.methodNotAllowed() = MethodNotAllowed;

  const factory NetworkExceptions.notAcceptable() = NotAcceptable;

  const factory NetworkExceptions.requestTimeout() = RequestTimeout;

  const factory NetworkExceptions.sendTimeout() = SendTimeout;

  const factory NetworkExceptions.conflict() = Conflict;

  const factory NetworkExceptions.internalServerError(String reason) = InternalServerError;

  const factory NetworkExceptions.notImplemented() = NotImplemented;

  const factory NetworkExceptions.serviceUnavailable() = ServiceUnavailable;

  const factory NetworkExceptions.noInternetConnection() = NoInternetConnection;

  const factory NetworkExceptions.formatException() = FormatException;

  const factory NetworkExceptions.unableToProcess() = UnableToProcess;

  const factory NetworkExceptions.defaultError(String error) = DefaultError;

  const factory NetworkExceptions.unexpectedError() = UnexpectedError;

  static NetworkExceptions fromDioException(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.cancel:
        return const NetworkExceptions.requestCancelled();
      case DioExceptionType.connectionTimeout:
        return const NetworkExceptions.requestTimeout();
      case DioExceptionType.sendTimeout:
        return const NetworkExceptions.sendTimeout();
      case DioExceptionType.receiveTimeout:
        return const NetworkExceptions.sendTimeout();
      case DioExceptionType.badResponse:
        switch (dioException.response?.statusCode) {
          case 400:
            return const NetworkExceptions.badRequest();
          case 401:
            return NetworkExceptions.unauthorizedRequest(
              dioException.response?.data['detail'] ?? "Unauthorized Request",
            );
          case 403:
            return NetworkExceptions.unauthorizedRequest(
              dioException.response?.data['detail'] ?? "Forbidden",
            );
          case 404:
            return NetworkExceptions.notFound(
              dioException.response?.data['detail'] ?? "Not Found",
            );
          case 409:
            return const NetworkExceptions.conflict();
          case 408:
            return const NetworkExceptions.requestTimeout();
          case 500:
            return NetworkExceptions.internalServerError(
              dioException.response?.data['detail'] ?? "Internal Server Error",
            );
          case 503:
            return const NetworkExceptions.serviceUnavailable();
          default:
            var responseCode = dioException.response?.statusCode;
            return NetworkExceptions.defaultError(
              "Received invalid status code: $responseCode",
            );
        }
      case DioExceptionType.unknown:
        if (dioException.message != null &&
            dioException.message!.contains("SocketException")) {
          return const NetworkExceptions.noInternetConnection();
        }
        return const NetworkExceptions.unexpectedError();
      case DioExceptionType.badCertificate:
        return const NetworkExceptions.defaultError("Bad Certificate");
      case DioExceptionType.connectionError:
        return const NetworkExceptions.noInternetConnection();
    }
  }
}