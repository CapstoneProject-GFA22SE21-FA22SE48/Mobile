const emptyAlert = 'Empty Alert';

class FormValidator {
  static String? validUsername(String? username) {
    if (username == null || username.trim().isEmpty) {
      return 'Username can not be empty';
    } else if (username.contains(RegExp('[{}\$&#!]'))) {
      // return 'Username must not includes {,},\$,&,#,!';
      return 'Username can not contains special characters';
    } else if (username.length > 255) {
      return 'Username can not be longer than 255 characters';
    }
    return null;
  }

  static String? validPassword(String? password) {
    if (password == null || password.trim().isEmpty) {
      return 'Password can not be empty';
    }
    // else if (password.contains(RegExp('[{}\$&#!\\/]'))) {
    //   return 'Password must not includes {,},\$,&,#,!,\\,/';
    // }
    else if (password.length > 255) {
      return 'Password can not be longer than 255 characters';
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
    if (passwordConfirm == null || passwordConfirm.isEmpty) {
      return 'Confirm password can not be empty';
    } else if (passwordConfirm != password) {
      return 'Confirm password must match the above one';
    }
    return null;
  }

  static String? validEmail(String? email) {
    if (email!.isNotEmpty) {
      bool isValid =
          RegExp('^[\\w-.]+@([\\w-]+.)+[\\w-]{2,5}\$').hasMatch(email!.trim());
      if (!isValid) {
        return 'Email is invalid';
      }
    } else {
      return null;
    }
    return null;
  }
}
