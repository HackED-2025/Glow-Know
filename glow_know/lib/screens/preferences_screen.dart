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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 80,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.fontPrimary,
                  size: 14, // Smaller icon
                ),
                const SizedBox(width: 2),
                Text(
                  'Back',
                  style: TextStyle(
                    color: AppColors.fontPrimary,
                    fontSize: 12, // Smaller text
                    height: 1.2, // Tighter line height
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCategory('Skin Type', [
              'Oily',
              'Dry',
              'Normal',
              'Sensitive',
            ], _selectedSkinTypes),

            const Divider(height: 40, thickness: 1, color: Color(0xFFE0E0E0)),

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

            const Divider(height: 40, thickness: 1, color: Color(0xFFE0E0E0)),

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
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.fontPrimary,
          ),
        ),
        const SizedBox(height: 16),
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
                      color:
                          isSelected
                              ? AppColors.background
                              : AppColors.fontPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  selected: isSelected,
                  backgroundColor: AppColors.background,
                  selectedColor: AppColors.primary,
                  side: BorderSide(
                    color: AppColors.fontPrimary.withOpacity(0.2),
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  showCheckmark: false,
                  pressElevation: 0,
                  onSelected: (_) => _toggleSelection(selected, option),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildVeganToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            'Vegan Friendly',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.fontPrimary,
            ),
          ),
          const Spacer(),
          Switch(
            value: _isVegan,
            activeColor: AppColors.primary,
            activeTrackColor: AppColors.primary.withOpacity(0.2),
            onChanged: (value) {
              setState(() {
                _isVegan = value;
                _savePreferences();
              });
            },
          ),
        ],
      ),
    );
  }
}
