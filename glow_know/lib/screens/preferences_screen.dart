import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      appBar: AppBar(title: const Text('Product Preferences')),
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
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              options.map((option) {
                final isSelected = selected.contains(option);
                return FilterChip(
                  label: Text(
                    option,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: Colors.purple[400], // Purple color
                  backgroundColor: Colors.grey[300],
                  checkmarkColor: Colors.transparent,
                  elevation: 0,
                  pressElevation: 0,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
        const Text(
          'Vegan Friendly',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        Switch(
          value: _isVegan,
          activeColor: Colors.purple[400], // Purple color for switch
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
