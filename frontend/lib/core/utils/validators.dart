class Validators {
  static String? required(String? value, [String? label]) {
    if (value == null || value.trim().isEmpty) {
      return '${label ?? 'This field'} is required';
    }
    return null;
  }

  static String? number(String? value, [String? label]) {
    if (value == null || value.trim().isEmpty) {
      return '${label ?? 'This field'} is required';
    }
    if (double.tryParse(value) == null) {
      return '${label ?? 'This field'} must be a number';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }
}
