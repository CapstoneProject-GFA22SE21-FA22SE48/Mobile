import 'dart:ui';

class ImageUtil {
  // down or up scale with the origin (the origin is 1)

  // static Image? reScale(double scaleOfOrigin) {}

  static String? getNetworkImagePathFromUrl(String url, double? zoom) {
    String local = '';
    List<String> sParts = url.split('sign-collection');
    String sName = url.split("%2F")[2].split(".png")[0];
    String ext = url.split('.').last;
    String folderScale = zoom! > 17 ? 'x05' : 'x025';
    String scale = zoom > 17 ? '0_50x' : '0_25x';
    String newUrl =
        '${sParts.first}sign-collection%2F$folderScale%2F$sName-standard-scale-$scale.$ext';

    return local.isNotEmpty ? local : null;
  }

  static String? getLocalImagePathFromUrl(String url, double? zoom) {
    String sName = url.split("%2F").last.split('?').first;
    String folderScale = getFolderByScale(zoom!);

    return 'assets/gps/$folderScale/$sName';
  }

  static String getFolderByScale(double zoom) {
    String folder = 'x0125';

    if (zoom >= 19) {
      return 'x036';
    } else if (zoom >= 17) {
      return 'x025';
    } else if (zoom >= 15) {
      return 'x0125';
    } else {
      return folder;
    }
  }

  static var zoomMap = {17.0: 'x036', 19: 'x025', 22: 'x0125'};
}
