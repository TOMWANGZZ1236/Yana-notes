// login exceptions
class InvalidCredentialsAuthException implements Exception {}

// register exceptions
class EmailInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

class WeakPasswordAuthException implements Exception {}

// generic exceptions
class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}
