import 'package:url_launcher/url_launcher.dart';

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

  static Future<String> validatePortfolio(String portfolio) async {
    if (await canLaunchUrl(Uri.parse(portfolio))) {
      return 'Ok';
    } else {
      return 'Enter a Valid Portfolio';
    }
  }

  static String validateName(String? value) {
    value = value?.trim();

    if (value == null || value.isEmpty) {
      return 'Please enter a name';
    }

    if (value.length < 3) {
      return 'Name is too short';
    }

    if (value.length > 50) {
      return 'Name is too long';
    }

    // Only letters, spaces, dots, apostrophes, and hyphens
    RegExp validChars = RegExp(r"^[a-zA-Z\s\.\'\-]+$");
    if (!validChars.hasMatch(value)) {
      return 'Name can only contain letters, spaces, dots, apostrophes, or hyphens';
    }

    // Avoid consecutive special characters
    RegExp repeatedSpecials = RegExp(r"[\.\'\-]{2,}");
    if (repeatedSpecials.hasMatch(value)) {
      return 'Name contains repeated special characters';
    }

    return "Ok";
  }

  static String validateServiceName(String? value) {
    value = value?.trim();

    if (value == null || value.isEmpty) {
      return 'Please enter a service name';
    }

    if (value.length < 3) {
      return 'Service name is too short';
    }

    if (value.length > 60) {
      return 'Service name is too long';
    }

    // Allow letters, numbers, spaces, and common service name characters
    RegExp validChars = RegExp(r"^[a-zA-Z0-9\s\.\'\-\&\#]+$");
    if (!validChars.hasMatch(value)) {
      return 'Service name contains invalid characters';
    }

    // Prevent repeated special characters
    RegExp repeatedSpecials = RegExp(r"[\'\.\-\&\#]{2,}");
    if (repeatedSpecials.hasMatch(value)) {
      return 'Service name has repeated special characters';
    }

    return "Ok";
  }

  static String validateDescription(String? value) {
    value = value?.trim();

    if (value == null || value.isEmpty) {
      return 'Please fill the Description';
    }

    if (value.length < 50 || value.length > 1100) {
      return 'Description must be between 50 and 1100 characters';
    }

    // Must contain at least one letter
    RegExp hasLetterRegExp = RegExp(r'[a-zA-Z]');
    if (!hasLetterRegExp.hasMatch(value)) {
      return 'Description must contain letters';
    }

    // Avoid descriptions with only symbols or numbers
    RegExp onlySymbolsOrNumbers = RegExp(r'^[^a-zA-Z]+$');
    if (onlySymbolsOrNumbers.hasMatch(value)) {
      return 'Description must contain meaningful text';
    }

    // Avoid excessive repeated characters (e.g., "aaaaaa")
    RegExp repeatedChar = RegExp(r'(.)\1{5,}');
    if (repeatedChar.hasMatch(value)) {
      return 'Description contains excessive repeated characters';
    }

    // Avoid spammy patterns like 'Lorem ipsum'
    if (value.toLowerCase().contains('lorem ipsum')) {
      return 'Description seems to be placeholder text';
    }

    // Basic profanity blacklist (example words)
    List<String> blacklist = ['shit', 'fuck', 'bitch', 'asshole'];
    for (String word in blacklist) {
      if (value.toLowerCase().contains(word)) {
        return 'Inappropriate content detected';
      }
    }

    // Too many newline characters
    if ('\n'.allMatches(value).length > 20) {
      return 'Description has too many newlines';
    }

    // Optional: avoid too many special characters
    RegExp excessiveSymbols =
        RegExp(r'[!@#\$%^&*()_+\-=\[\]{};:"\\|,.<>\/?]{10,}');
    if (excessiveSymbols.hasMatch(value)) {
      return 'Too many special characters in description';
    }

    return 'Ok';
  }

  static String validateIntFields(String? value) {
    value = value?.trim();

    if (value == null || value.isEmpty) {
      return 'Please enter a value';
    }

    RegExp regex = RegExp(r'[0-9]');
    if (!value.contains(regex)) {
      return 'Invalid Data';
    }

    return "Ok";
  }

  static String validateUsername(String? value) {
    value = value?.trim();

    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    } else if (value.contains(' ')) {
      return 'Username cannot contain spaces';
    } else if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Username can only contain letters, numbers and underscores';
    }
    return "Ok";
  }

  static Future<String> validateLink(String? value) async {
    value = value?.trim();

    if (value == null || value.isEmpty) {
      return 'Please enter a link';
    }

    // Basic format and characters check
    if (value.length < 5 || !value.contains('.')) {
      return 'Link seems too short or invalid';
    }

    Uri? uri;
    try {
      uri = Uri.parse(value);
    } catch (e) {
      return 'Link format is incorrect';
    }

    // Scheme check (http or https)
    if (!(uri.scheme == 'http' || uri.scheme == 'https')) {
      return 'Link must start with http:// or https://';
    }

    // Avoid javascript or other unsafe protocols
    if (uri.scheme.contains('javascript') ||
        value.toLowerCase().contains('javascript:')) {
      return 'Link contains unsafe content';
    }

    // URL launchable check
    if (!(await canLaunchUrl(uri))) {
      return 'Invalid or unreachable link';
    }

    return 'Ok';
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
