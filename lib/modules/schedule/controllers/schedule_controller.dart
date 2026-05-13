import 'package:get/get.dart';

import '../../../data/models/schedule_model.dart';

class ScheduleController extends GetxController {
  final currentMonth = DateTime(2023, 10).obs;
  final selectedDay = 12.obs;

  final sessions = ScheduleSession.defaults;

  final completed = 12;
  final upcoming = 4;
  final missed = 81;

  final efficiency = 0.78;
  final efficiencyLabel = 'Optimal';

  void previousMonth() {
    final d = currentMonth.value;
    currentMonth.value = DateTime(d.year, d.month - 1);
  }

  void nextMonth() {
    final d = currentMonth.value;
    currentMonth.value = DateTime(d.year, d.month + 1);
  }

  void selectDay(int day) => selectedDay.value = day;

  int daysInMonth(DateTime m) =>
      DateTime(m.year, m.month + 1, 0).day;

  int firstWeekday(DateTime m) {
    // 1=Mon ... 7=Sun, adjust so Mon=0
    final wd = DateTime(m.year, m.month, 1).weekday;
    return wd - 1;
  }

  String monthName(DateTime m) {
    const names = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${names[m.month]} ${m.year}';
  }
}
