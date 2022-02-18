class FormatTime {
  static String _twoDigits(int n) => n.toString().padLeft(2, '0');
  static String formatTime(Duration duration) {
    final hours = _twoDigits(duration.inHours);
    final minutes = _twoDigits(duration.inMinutes.remainder(60));
    final seconds = _twoDigits(duration.inSeconds.remainder(60));
    return " $hours:$minutes:$seconds ";
  }

  static String formatDate(DateTime now) =>
      "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
}
