import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/theme.dart';

class PreferencesPage extends StatefulWidget {
  const PreferencesPage({super.key});

  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  List<String> _selectedSkinTypes = [];
  List<String> _selectedHairTypes = [];
  bool _isVegan = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedSkinTypes = List<String>.from(
        prefs.getStringList('skinTypes') ?? [],
      );
      _selectedHairTypes = List<String>.from(
        prefs.getStringList('hairTypes') ?? [],
      );
      _isVegan = prefs.getBool('isVegan') ?? false;
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('skinTypes', _selectedSkinTypes);
    await prefs.setStringList('hairTypes', _selectedHairTypes);
    await prefs.setBool('isVegan', _isVegan);
  }

  void _toggleSelection(List<String> list, String value) {
    setState(() {
      list.contains(value) ? list.remove(value) : list.add(value);
      _savePreferences();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Preferences'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCategory('Skin Type', [
              'Oily',
              'Dry',
              'Normal',
              'Sensitive',
            ], _selectedSkinTypes),
            const SizedBox(height: 24),
            _buildCategory('Hair Type', [
              'Straight',
              'Wavy',
              'Curly',
              'Coily',
              'Oily',
              'Dry',
              'Frizzy',
              'Fine',
              'Medium',
              'Coarse',
            ], _selectedHairTypes),
            const SizedBox(height: 24),
            _buildVeganToggle(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategory(
    String title,
    List<String> options,
    List<String> selected,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              options.map((option) {
                final isSelected = selected.contains(option);
                return ChoiceChip(
                  label: Text(
                    option,
                    style: TextStyle(
                      color: isSelected ? AppColors.white : AppColors.primary,
                    ),
                  ),
                  selected: isSelected,
                  backgroundColor: AppColors.white,
                  selectedColor: AppColors.secondary.withOpacity(0.3),
                  side: BorderSide(color: AppColors.secondary, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  onSelected: (_) => _toggleSelection(selected, option),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildVeganToggle() {
    return Row(
      children: [
        Text(
          'Vegan Friendly',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const Spacer(),
        Switch(
          value: _isVegan,
          activeColor: AppColors.secondary,
          activeTrackColor: AppColors.secondary.withOpacity(0.4),
          onChanged: (value) {
            setState(() {
              _isVegan = value;
              _savePreferences();
            });
          },
        ),
      ],
    );
  }
}
