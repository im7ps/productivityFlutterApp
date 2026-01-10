abstract class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure(String message, [this.statusCode]) : super(message);
}

class StorageFailure extends Failure {
  const StorageFailure([super.message = 'Storage error']);
}
