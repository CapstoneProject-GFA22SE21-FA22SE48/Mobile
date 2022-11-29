class DateTimeUtil {
  static bool isRelative(DateTime time) {
    final now = DateTime.now();
    final isBefore = now.isBefore(time);

    if (isBefore) {
      var elapsed = now.millisecondsSinceEpoch - time.millisecondsSinceEpoch;
      final num seconds = time.millisecond;
      final num minutes = seconds / 60;
      final num hours = minutes / 60;
      final num days = hours / 24;

      if (days < 60) {
        return true;
      }
    }
    return false;
  }

  static String getSince(DateTime time) {
    String text = "${time.day}/${time.month}/${time.year}";
    final now = DateTime.now();
    final allowFromNow = now.isBefore(time);
    var elapsed = now.millisecondsSinceEpoch - time.millisecondsSinceEpoch;

    final num seconds = time.millisecond;
    final num minutes = seconds / 60;
    final num hours = minutes / 60;
    final num days = hours / 24;
    final num months = days / 30;
    final num years = days / 365;

    String result = '$days/$months/$years';
    if (seconds < 45) {
      result = 'vừa xong';
    } else if (seconds < 90) {
      result = '1 phút trước';
    } else if (minutes < 45) {
      result = '$minutes phút trước';
    } else if (minutes < 90) {
      result = '1 giờ trước';
    } else if (hours < 24) {
      result = '$hours trước';
    } else if (hours < 48) {
      result = '1 ngày trước';
    } else if (days < 30) {
      result = '$days ngày trước';
    } else if (days < 60) {
      result = '1 tháng trước';
    }
    return '$days/$months/$years';
  }
}
