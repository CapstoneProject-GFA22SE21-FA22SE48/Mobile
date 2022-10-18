import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:vnrdn_tai/shared/snippets.dart';

class FutureBuilderUtil {
  static AsyncSnapshot<T> wrapper<T>(Future<T> t) {
    AsyncSnapshot<T> s = const AsyncSnapshot.nothing();
    FutureBuilder<T>(
      key: UniqueKey(),
      future: t,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.data == null) {
          return loadingScreen();
        } else {
          s = snapshot;
          if (snapshot.hasError) {
            Future.delayed(
                Duration.zero,
                () => {
                      handleError(snapshot.error
                          ?.toString()
                          .replaceFirst('Exception:', ''))
                    });
            throw Exception(snapshot.error);
          } else {
            return Container();
          }
        }
      },
      initialData: s.data,
    );
    return s;
  }
}
