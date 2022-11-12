const emptyAlert = 'Empty Alert';

class FormValidator {
  static String? validUsername(String? username) {
    if (username == null || username.trim().isEmpty) {
      return 'Tên đăng nhập không được bỏ trống';
    } else if (username.contains(RegExp('[{}\$&#!]'))) {
      // return 'Username must not includes {,},\$,&,#,!';
      return 'Tên đăng nhập không chứa kí tự không hợp lệ';
    } else if (username.length > 20) {
      return 'Tên đăng nhập không dài hơn 20 kí tự';
    } else if (username.length < 6) {
      return 'Tên đăng nhập không ngắn hơn 6 kí tự';
    }
    return null;
  }

  static String? validPassword(String? password) {
    if (password == null || password.trim().isEmpty) {
      return 'Mật khẩu không được bỏ trống';
    } else if (password.length > 20) {
      return 'Mật khẩu không dài hơn 20 kí tự';
    } else if (password.length < 6) {
      return 'Mật khẩu không ngắn hơn 6 kí tự';
    }
    return null;
  }

  static String? validPasswordConfirm(
      String? password, String? passwordConfirm) {
    if (passwordConfirm != password) {
      return 'Xác nhận không khớp với mật khẩu';
    }
    return null;
  }

  static String? validEmail(String? email) {
    if (email!.isNotEmpty) {
      if (email.length > 255) {
        return 'Email không hợp lệ';
      }
      bool isValid =
          RegExp('^[\\w-.]+@([\\w-]+.)+[\\w-]{2,5}\$').hasMatch(email.trim());
      if (!isValid) {
        return 'Email không hợp lệ';
      }
    }
    return null;
  }
}
