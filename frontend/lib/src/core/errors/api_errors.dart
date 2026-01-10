import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_errors.freezed.dart';
part 'api_errors.g.dart';

@freezed
class ValidationError with _$ValidationError {
  const factory ValidationError({
    required List<dynamic> loc,
    required String msg,
    required String type,
  }) = _ValidationError;

  factory ValidationError.fromJson(Map<String, dynamic> json) => _$ValidationErrorFromJson(json);
}

@freezed
class HTTPValidationError with _$HTTPValidationError {
  const factory HTTPValidationError({
    required List<ValidationError> detail,
  }) = _HTTPValidationError;

  factory HTTPValidationError.fromJson(Map<String, dynamic> json) => _$HTTPValidationErrorFromJson(json);
}
