class APIException implements Exception {
  final int _statusCode;
  final String _errorMessage;

  APIException(this._statusCode, this._errorMessage);

  int get code => _statusCode;
  String get message => _errorMessage;

  @override
  String toString() {
    return '$_statusCode: $_errorMessage';
  }
}
