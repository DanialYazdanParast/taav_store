class RegexpUtil {
  static final password = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^\w\s]).{8,60}$',
  );

  static final RegExp validUsername = RegExp(r'^[a-zA-Z0-9._]+$');
  static final RegExp allowedPasswordChars = RegExp(r'^[\x20-\x7E]+$');
}
