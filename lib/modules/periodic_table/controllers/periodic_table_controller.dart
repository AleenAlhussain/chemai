import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ElementData {
  final String symbol;
  final String name;
  final int number;
  final double mass;
  final String config;
  final String category;
  final Color color;
  final double meltingPoint;
  final double density;
  final String state;
  final String kimoTip;

  const ElementData({
    required this.symbol,
    required this.name,
    required this.number,
    required this.mass,
    required this.config,
    required this.category,
    required this.color,
    required this.meltingPoint,
    required this.density,
    required this.state,
    required this.kimoTip,
  });
}

class PeriodicTableController extends GetxController {
  final elements = <ElementData>[].obs;
  final selected = Rxn<ElementData>();
  final searchQuery = ''.obs;
  final stateFilter = 'all'.obs;

  List<ElementData> get filteredElements {
    final q = searchQuery.value.toLowerCase();
    final sf = stateFilter.value;
    return elements.where((e) {
      final matchesSearch = q.isEmpty ||
          e.symbol.toLowerCase().contains(q) ||
          e.name.toLowerCase().contains(q) ||
          e.number.toString().contains(q);
      final matchesState = sf == 'all' || e.state == sf;
      return matchesSearch && matchesState;
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    _loadElements();
  }

  void _loadElements() {
    elements.assignAll([
      const ElementData(
        symbol: 'H',
        name: 'Hydrogen',
        number: 1,
        mass: 1.008,
        config: '1s¹',
        category: 'Non-metal',
        color: Color(0xFF34D399),
        meltingPoint: -259.0,
        density: 0.00009,
        state: 'gas',
        kimoTip: 'Hydrogen is the most abundant element in the universe',
      ),
      const ElementData(
        symbol: 'He',
        name: 'Helium',
        number: 2,
        mass: 4.003,
        config: '1s²',
        category: 'Noble Gas',
        color: Color(0xFF22D3EE),
        meltingPoint: -272.0,
        density: 0.00018,
        state: 'gas',
        kimoTip: 'Helium never solidifies under normal pressure',
      ),
      const ElementData(
        symbol: 'Li',
        name: 'Lithium',
        number: 3,
        mass: 6.941,
        config: '[He] 2s¹',
        category: 'Alkali Metal',
        color: Color(0xFFEF4444),
        meltingPoint: 180.5,
        density: 0.534,
        state: 'solid',
        kimoTip: 'Lithium is the lightest metal on Earth',
      ),
      const ElementData(
        symbol: 'Be',
        name: 'Beryllium',
        number: 4,
        mass: 9.012,
        config: '[He] 2s²',
        category: 'Alkaline Earth',
        color: Color(0xFFF97316),
        meltingPoint: 1287.0,
        density: 1.85,
        state: 'solid',
        kimoTip: 'Beryllium is extremely toxic',
      ),
      const ElementData(
        symbol: 'C',
        name: 'Carbon',
        number: 6,
        mass: 12.011,
        config: '[He] 2s² 2p²',
        category: 'Non-metal',
        color: Color(0xFF34D399),
        meltingPoint: 3550.0,
        density: 2.267,
        state: 'solid',
        kimoTip: 'Carbon is the basis of all known life',
      ),
      const ElementData(
        symbol: 'N',
        name: 'Nitrogen',
        number: 7,
        mass: 14.007,
        config: '[He] 2s² 2p³',
        category: 'Non-metal',
        color: Color(0xFF34D399),
        meltingPoint: -210.0,
        density: 0.00125,
        state: 'gas',
        kimoTip: 'Nitrogen makes up 78% of Earth\'s atmosphere',
      ),
      const ElementData(
        symbol: 'O',
        name: 'Oxygen',
        number: 8,
        mass: 15.999,
        config: '[He] 2s² 2p⁴',
        category: 'Non-metal',
        color: Color(0xFF34D399),
        meltingPoint: -219.0,
        density: 0.00143,
        state: 'gas',
        kimoTip: 'Oxygen is essential for combustion and respiration',
      ),
      const ElementData(
        symbol: 'Na',
        name: 'Sodium',
        number: 11,
        mass: 22.990,
        config: '[Ne] 3s¹',
        category: 'Alkali Metal',
        color: Color(0xFFEF4444),
        meltingPoint: 97.8,
        density: 0.97,
        state: 'solid',
        kimoTip: 'Sodium explodes violently when it contacts water',
      ),
      const ElementData(
        symbol: 'Cl',
        name: 'Chlorine',
        number: 17,
        mass: 35.453,
        config: '[Ne] 3s² 3p⁵',
        category: 'Halogen',
        color: Color(0xFFA3E635),
        meltingPoint: -101.0,
        density: 0.00321,
        state: 'gas',
        kimoTip: 'Chlorine is a powerful disinfectant',
      ),
      const ElementData(
        symbol: 'Au',
        name: 'Gold',
        number: 79,
        mass: 196.967,
        config: '[Xe] 4f¹⁴ 5d¹⁰ 6s¹',
        category: 'Transition Metal',
        color: Color(0xFF8B7DF8),
        meltingPoint: 1064.0,
        density: 19.3,
        state: 'solid',
        kimoTip: 'Gold never tarnishes or corrodes',
      ),
      const ElementData(
        symbol: 'Fe',
        name: 'Iron',
        number: 26,
        mass: 55.845,
        config: '[Ar] 3d⁶ 4s²',
        category: 'Transition Metal',
        color: Color(0xFF8B7DF8),
        meltingPoint: 1538.0,
        density: 7.874,
        state: 'solid',
        kimoTip: 'Iron is the most abundant element on Earth by mass',
      ),
    ]);
  }

  void selectElement(ElementData e) {
    selected.value = e;
  }

  void clearSelection() {
    selected.value = null;
  }

  void updateSearch(String q) {
    searchQuery.value = q;
  }

  void updateStateFilter(String s) {
    stateFilter.value = s;
  }
}
