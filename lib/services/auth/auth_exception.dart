// login exceptions
class InvalidCredentialsAuthException implements Exception {}

// register and reset exceptions
class EmailInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

class WeakPasswordAuthException implements Exception {}

class UserNotFoundAuthException implements Exception {}

// generic exceptions
class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}

class CouldNotDeleteUserException implements Exception {}
