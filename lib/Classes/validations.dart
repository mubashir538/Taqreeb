class Validations {
  static String validateEmail(String? value) {
    value = value!.trim();

    if (value.isEmpty) {
      return 'Please enter an email address';
    } else if (!value.contains('@')) {
      return 'Please enter a valid email address';
    }

    return "Ok";
  }

  static String validatePassword(String? value) {
    value = value?.trim();

    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    } else if (value.length < 8) {
      return 'Password must be at least 8 characters';
    } else if (!RegExp(r'\d').hasMatch(value)) {
      return 'Password must contain at least one number';
    } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    return "Ok";
  }

  static String validateCNIC(String value) {
    if (value.isEmpty) {
      return 'Please enter a CNIC';
    } else if (value.length != 13) {
      return 'CNIC must be 13 digits';
    } else if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value) ||
        RegExp(r'[A-Z]').hasMatch(value) ||
        RegExp(r'[a-z]').hasMatch(value)) {
      return 'Enter a Valid CNIC Number';
    }

    return "Ok";
  }

  static String validateContact(String value) {
    if (value.isEmpty) {
      return 'Please enter a Contact Number';
    } else if (value.length != 11) {
      return 'Contact Number must be 11 digits';
    } else if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value) ||
        RegExp(r'[A-Z]').hasMatch(value) ||
        RegExp(r'[a-z]').hasMatch(value)) {
      return 'Enter a Valid Contact Number';
    }

    return "Ok";
  }
}
