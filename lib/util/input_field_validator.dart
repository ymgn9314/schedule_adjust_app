mixin NameValidator {
  static String? Function(String?) validate = (value) {
    if (value!.isEmpty) {
      return '値が未設定です';
    } else if (value.length < 3) {
      return '3文字以上にしてください';
    } else if (value.length > 10) {
      return '10文字以下にしてください';
    }
    return null;
  };
}
