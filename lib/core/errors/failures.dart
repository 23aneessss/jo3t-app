abstract class Failure {
  const Failure(this.message);
  final String message;
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error']);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Not found']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class PermissionFailure extends Failure {
  const PermissionFailure([super.message = 'Permission denied']);
}
