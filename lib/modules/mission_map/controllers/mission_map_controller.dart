import 'package:get/get.dart';

enum SectorStatus { completed, active, locked }
enum NodeStatus { completed, active, locked }

class MissionNode {
  final String id;
  final String title;
  final NodeStatus status;
  final double progress;
  const MissionNode({required this.id, required this.title, required this.status, this.progress = 0});
}

class MissionSector {
  final int number;
  final String title;
  final SectorStatus status;
  final List<MissionNode> nodes;
  const MissionSector({required this.number, required this.title, required this.status, required this.nodes});
}

class MissionMapController extends GetxController {
  final xp = 2450.obs;
  final planetsConquered = 4.obs;
  final nodesSynced = '12/24'.obs;
  final currentRank = 'SGT-V'.obs;
  final showTransmission = true.obs;
  final transmissionText = '"Commander, we\'re approaching the Valence Shell. Prepare for extraction!"'.obs;

  final sectors = <MissionSector>[
    const MissionSector(
      number: 1, title: 'ATOMIC FOUNDATIONS', status: SectorStatus.completed,
      nodes: [
        MissionNode(id: '01', title: 'Subatomic Particles', status: NodeStatus.completed),
        MissionNode(id: '02', title: 'Electron Shells', status: NodeStatus.completed),
      ],
    ),
    const MissionSector(
      number: 2, title: 'MOLECULAR BONDS', status: SectorStatus.active,
      nodes: [
        MissionNode(id: '03', title: 'Covalent Extraction', status: NodeStatus.active, progress: 0.6),
        MissionNode(id: '04', title: 'Ionic Matrix', status: NodeStatus.locked),
      ],
    ),
    const MissionSector(
      number: 3, title: 'STOICHIOMETRY', status: SectorStatus.locked,
      nodes: [
        MissionNode(id: '05', title: 'Mole Concept', status: NodeStatus.locked),
        MissionNode(id: '06', title: 'Reaction Ratios', status: NodeStatus.locked),
      ],
    ),
  ].obs;

  void dismissTransmission() => showTransmission.value = false;
}
