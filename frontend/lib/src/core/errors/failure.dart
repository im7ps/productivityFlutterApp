import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

@freezed
sealed class Failure with _$Failure {
  const Failure._(); // Private constructor for custom methods/getters if needed

  /// Generic server error (500, 404, or unhandled 4xx)
  const factory Failure.server(String message, [int? statusCode]) = ServerFailure;

  /// Network connectivity issues
  const factory Failure.network([@Default('No internet connection') String message]) = NetworkFailure;

  /// Validation errors (422) containing field-specific messages
  const factory Failure.validation(Map<String, String> errors, [String? message]) = ValidationFailure;
  
  /// Local storage errors
  const factory Failure.storage([@Default('Storage error') String message]) = StorageFailure;

  /// Unknown or unexpected errors
  const factory Failure.unknown(String message) = UnknownFailure;

  // Helper getter to always get a displayable message
  String get displayMessage {
    return map(
      server: (f) => f.message,
      network: (f) => f.message,
      validation: (f) => f.message ?? 'Validation Error',
      storage: (f) => f.message,
      unknown: (f) => f.message,
    );
  }
}
