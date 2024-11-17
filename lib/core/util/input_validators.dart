String? emailValidator(String? email) {
  RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

  String? baseIssue = baseValidator(email);
  if (baseIssue != null) {
    return baseIssue;
  }
  if (!emailRegex.hasMatch(email!.trim())) {
    return 'Email is not valid';
  }

  return null;
}

String? phoneValidator(String? phone) {
  // RegExp phoneRegex = RegExp(
  //     r"/(\+\d{1,3}\s?)?((\(\d{3}\)\s?)|(\d{3})(\s|-?))(\d{3}(\s|-?))(\d{4})(\s?(([E|e]xt[:|.|]?)|x|X)(\s?\d+))?/g");

  String? baseIssue = baseValidator(phone);
  if (baseIssue != null) {
    return baseIssue;
  }
  // if (!phoneRegex.hasMatch(phone!.trim())) {
  //   return 'Phone number is not valid';
  // }

  return null;
}

String? passwordValidator(String? password) {
  if (baseValidator(password) != null) {
    return baseValidator(password);
  }
  if ((password!.trim()).length < 6) {
    return 'Password is too short';
  }

  return null;
}

String? baseValidator(String? input) {
  if ((input?.trim() ?? '').isEmpty) {
    return 'Field cannot be empty';
  }

  return null;
}
