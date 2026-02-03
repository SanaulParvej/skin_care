class AuthValidator {
  AuthValidator._();

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email required';
    }
    if (!value.contains('@')) {
      return 'Enter valid email';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.trim().length < 6) {
      return 'Minimum 6 characters';
    }
    return null;
  }
}
