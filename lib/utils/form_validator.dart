const emptyAlert = 'Empty Alert';

class FormValidator {
  static String? validUsername(String? username) {
    if (username == null || username.trim().isEmpty) {
      return 'Tên đăng nhập không được bỏ trống';
    } else if (username.contains(RegExp('[{}\$&#!]'))) {
      // return 'Username must not includes {,},\$,&,#,!';
      return 'Tên đăng nhập không chứa kí tự không hợp lệ';
    } else if (username.length > 255) {
      return 'Tên đăng nhập không dài hơn 255 kí tự';
    }
    return null;
  }

  static String? validPassword(String? password) {
    if (password == null || password.trim().isEmpty) {
      return 'Mật khẩu không được bỏ trống';
    }
    // else if (password.contains(RegExp('[{}\$&#!\\/]'))) {
    //   return 'Password must not includes {,},\$,&,#,!,\\,/';
    // }
    else if (password.length > 40) {
      return 'Mật khẩu không dài hơn 40 kí tự';
    }
    // else {
    //   int iOpenBracket = password.indexOf('{');
    //   int iOpen = password.indexOf('{');
    //   if (iOpenBracket > 0 && password.indexOf('}') > iOpenBracket) {
    //     return 'Password contains characters not allowed';
    //   }
    // }
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
