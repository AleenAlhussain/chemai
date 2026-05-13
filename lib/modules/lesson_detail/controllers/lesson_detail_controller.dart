import 'package:get/get.dart';

class LessonDetailController extends GetxController {
  final chapterLabel = 'Chapter 2: Covalent Bonds';
  final title = 'Sharing is Caring: How Atoms Bond';
  final description =
      'Dive into the quantum mechanics of electron sharing. See how overlap creates stability in the molecular world. #Chemistry #STEM';
  final difficulty = 'Hard';
  final likes = 42900;
  final comments = 1200;

  final currentSeconds = 225.obs; // 3:45
  final totalSeconds = 300;       // 5:00
  final isLiked = false.obs;

  double get progress => currentSeconds.value / totalSeconds;

  String timeLabel(int secs) {
    final m = secs ~/ 60;
    final s = secs % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String get currentTime => timeLabel(currentSeconds.value);
  String get totalTime => timeLabel(totalSeconds);

  String formatCount(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return '$n';
  }

  void toggleLike() => isLiked.value = !isLiked.value;
}
