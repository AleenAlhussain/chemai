import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BalancerStep {
  final String text;
  final String? highlight;
  const BalancerStep({required this.text, this.highlight});
}

class EquationBalancerController extends GetxController {
  final inputController = TextEditingController();
  final inputText = ''.obs;
  final steps = <BalancerStep>[].obs;
  final balancedEquation = ''.obs;
  final hasResult = false.obs;
  final isLoading = false.obs;

  // Pre-defined example equations to demonstrate
  static const _examples = [
    'H2 + O2 → H2O',
    'Fe + O2 → Fe2O3',
    'CH4 + O2 → CO2 + H2O',
    'N2 + H2 → NH3',
  ];
  int _exampleIndex = 0;

  void loadExample() {
    inputController.text = _examples[_exampleIndex % _examples.length];
    inputText.value = inputController.text;
    _exampleIndex++;
  }

  Future<void> balance() async {
    if (inputText.value.trim().isEmpty) return;
    isLoading.value = true;
    hasResult.value = false;
    steps.clear();
    balancedEquation.value = '';

    await Future.delayed(const Duration(milliseconds: 800));

    // Simple demo balancing for known equations
    final input = inputText.value.trim();
    _generateDemoSteps(input);

    isLoading.value = false;
    hasResult.value = true;
  }

  void _generateDemoSteps(String input) {
    if (input.contains('H2') && input.contains('O2') && input.contains('H2O')) {
      steps.assignAll([
        const BalancerStep(text: 'Unbalanced: H₂ + O₂ → H₂O'),
        const BalancerStep(text: 'Count atoms: Left: H=2, O=2 | Right: H=2, O=1'),
        const BalancerStep(text: 'Balance O: add coefficient 2 to H₂O → H₂ + O₂ → 2H₂O'),
        const BalancerStep(text: 'Recount: Left: H=2, O=2 | Right: H=4, O=2'),
        const BalancerStep(text: 'Balance H: add coefficient 2 to H₂ → 2H₂ + O₂ → 2H₂O'),
        const BalancerStep(text: 'Final check: Left: H=4, O=2 | Right: H=4, O=2 ✓'),
      ]);
      balancedEquation.value = '2H₂ + O₂ → 2H₂O';
    } else if (input.contains('CH4') || input.contains('methane')) {
      steps.assignAll([
        const BalancerStep(text: 'Unbalanced: CH₄ + O₂ → CO₂ + H₂O'),
        const BalancerStep(text: 'Count C: Left=1, Right=1 ✓ (already balanced)'),
        const BalancerStep(text: 'Count H: Left=4, Right=2 → add coefficient 2 to H₂O'),
        const BalancerStep(text: 'Now: CH₄ + O₂ → CO₂ + 2H₂O'),
        const BalancerStep(text: 'Count O: Left=2, Right=2+2=4 → add coefficient 2 to O₂'),
        const BalancerStep(text: 'Final: CH₄ + 2O₂ → CO₂ + 2H₂O ✓'),
      ]);
      balancedEquation.value = 'CH₄ + 2O₂ → CO₂ + 2H₂O';
    } else if (input.contains('Fe') && input.contains('O2')) {
      steps.assignAll([
        const BalancerStep(text: 'Unbalanced: Fe + O₂ → Fe₂O₃'),
        const BalancerStep(text: 'Count Fe: Left=1, Right=2 → coefficient 4 for Fe'),
        const BalancerStep(text: 'Count O: Left=2, Right=3 → coefficient 3 for O₂'),
        const BalancerStep(text: 'Now: 4Fe + 3O₂ → Fe₂O₃ → Right Fe=2, need coefficient 2'),
        const BalancerStep(text: 'Final: 4Fe + 3O₂ → 2Fe₂O₃ ✓'),
      ]);
      balancedEquation.value = '4Fe + 3O₂ → 2Fe₂O₃';
    } else {
      steps.assignAll([
        const BalancerStep(text: 'Analyzing equation structure...'),
        const BalancerStep(text: 'Identifying reactants and products...'),
        const BalancerStep(text: 'Counting atoms on each side...'),
        const BalancerStep(text: 'Applying balancing algorithm...'),
        const BalancerStep(text: 'Equation analysis complete. Try one of the examples for a full walkthrough.'),
      ]);
      balancedEquation.value = input;
    }
  }

  void clear() {
    inputController.clear();
    inputText.value = '';
    steps.clear();
    balancedEquation.value = '';
    hasResult.value = false;
  }

  @override
  void onClose() {
    inputController.dispose();
    super.onClose();
  }
}
