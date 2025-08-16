
class Utils {
  Utils._();
  static String formatDate(DateTime date) {
    final months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];
    final days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    return "${days[date.weekday - 1]}, ${date.day} ${months[date.month -
        1]} ${date.year}";
  }

  static String formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  static String formatLockTime(Duration duration) {
    if (duration.inHours > 0) {
      final minutes = duration.inMinutes.remainder(60);
      return minutes > 0
          ? '${duration.inHours}h ${minutes}m'
          : '${duration.inHours}h';
    }
    return '${duration.inMinutes}m';
  }

  static String getReturnTime(String startTime) {
    final time = startTime.split(' ');
    final hour = int.parse(time[0].split(':')[0]);
    return '${hour + 9}${time[0].substring(2)} ${time[1]}';
  }

  static String getHourAndMinuteFromSeconds(int seconds) {
    final hours = (seconds / 3600).floor();
    final minutes = ((seconds % 3600) / 60).floor();
    return '${hours.toString().padLeft(2, '0')}h ${minutes.toString().padLeft(2, '0')}m';
  }
}