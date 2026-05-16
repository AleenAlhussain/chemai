import 'dart:async';
import 'package:get/get.dart';

class ReelItem {
  final String title;
  final String description;
  final String chapter;
  final int durationSeconds;
  final int likes;
  final bool isBookmarked;
  ReelItem({required this.title, required this.description, required this.chapter, required this.durationSeconds, required this.likes, this.isBookmarked = false});
}

class ReelsController extends GetxController {
  final currentIndex = 0.obs;
  final isLiked = false.obs;
  final isSaved = false.obs;
  final currentSeconds = 0.obs;
  Timer? _timer;

  final reels = [
    ReelItem(title: 'How does covalent bonding form?', description: 'Watch closely — the electrons here are sharing with each other to reach stability!', chapter: 'Chapter 1', durationSeconds: 30, likes: 1200),
    ReelItem(title: 'What is oxidation?', description: 'Oxidation is the loss of electrons. Remember: OIL RIG!', chapter: 'Chapter 3', durationSeconds: 45, likes: 890),
    ReelItem(title: 'The periodic table explained', description: 'Each row is a period, each column is a group. Elements in the same group have similar properties.', chapter: 'Chapter 1', durationSeconds: 60, likes: 2300),
  ];

  ReelItem get current => reels[currentIndex.value];

  @override
  void onInit() { super.onInit(); _startTimer(); }

  void _startTimer() {
    _timer?.cancel();
    currentSeconds.value = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (currentSeconds.value < current.durationSeconds) {
        currentSeconds.value++;
      }
    });
  }

  void nextReel() {
    if (currentIndex.value < reels.length - 1) {
      currentIndex.value++;
      isLiked.value = false;
      isSaved.value = false;
      _startTimer();
    }
  }

  void previousReel() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
      isLiked.value = false;
      isSaved.value = false;
      _startTimer();
    }
  }

  void toggleLike() => isLiked.value = !isLiked.value;
  void toggleSave() => isSaved.value = !isSaved.value;

  double get progress => currentSeconds.value / current.durationSeconds;
  String get timeLabel => '${current.durationSeconds - currentSeconds.value} sec';

  @override
  void onClose() { _timer?.cancel(); super.onClose(); }
}
