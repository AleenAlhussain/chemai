import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ElementContribution {
  final String symbol;
  final int count;
  final double atomicMass;
  double get totalMass => count * atomicMass;
  const ElementContribution({required this.symbol, required this.count, required this.atomicMass});
}

class MolarMassController extends GetxController {
  final inputController = TextEditingController();
  final formula = ''.obs;
  final totalMolarMass = 0.0.obs;
  final contributions = <ElementContribution>[].obs;
  final hasResult = false.obs;

  static const Map<String, double> _masses = {
    'H': 1.008, 'He': 4.003, 'Li': 6.941, 'Be': 9.012, 'B': 10.811, 'C': 12.011,
    'N': 14.007, 'O': 15.999, 'F': 18.998, 'Ne': 20.180, 'Na': 22.990, 'Mg': 24.305,
    'Al': 26.982, 'Si': 28.086, 'P': 30.974, 'S': 32.065, 'Cl': 35.453, 'K': 39.098,
    'Ca': 40.078, 'Fe': 55.845, 'Cu': 63.546, 'Zn': 65.38, 'Br': 79.904, 'Ag': 107.868,
    'I': 126.904, 'Au': 196.967, 'Hg': 200.59, 'Pb': 207.2,
  };

  static const _examples = ['H2O', 'NaCl', 'H2SO4', 'C6H12O6', 'CaCO3', 'NH3', 'CO2'];
  int _exampleIndex = 0;

  void loadExample() {
    final ex = _examples[_exampleIndex % _examples.length];
    inputController.text = ex;
    formula.value = ex;
    _exampleIndex++;
  }

  void calculate() {
    final f = formula.value.trim();
    if (f.isEmpty) return;

    final parsed = _parseFormula(f);
    if (parsed.isEmpty) return;

    final contribs = <ElementContribution>[];
    double total = 0;
    for (final entry in parsed.entries) {
      final mass = _masses[entry.key] ?? 0;
      contribs.add(ElementContribution(symbol: entry.key, count: entry.value, atomicMass: mass));
      total += mass * entry.value;
    }
    contributions.assignAll(contribs);
    totalMolarMass.value = double.parse(total.toStringAsFixed(3));
    hasResult.value = true;
  }

  Map<String, int> _parseFormula(String formula) {
    final result = <String, int>{};
    final re = RegExp(r'([A-Z][a-z]?)(\d*)');
    for (final m in re.allMatches(formula)) {
      final sym = m.group(1)!;
      final cnt = int.tryParse(m.group(2) ?? '') ?? 1;
      result[sym] = (result[sym] ?? 0) + cnt;
    }
    return result;
  }

  void clear() {
    inputController.clear();
    formula.value = '';
    contributions.clear();
    totalMolarMass.value = 0;
    hasResult.value = false;
  }

  @override
  void onClose() {
    inputController.dispose();
    super.onClose();
  }
}
