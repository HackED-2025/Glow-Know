import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import the flutter_svg package
import 'package:glow_know/assets/svgs.dart';
import 'package:glow_know/models/product.dart';
import 'package:glow_know/utils/theme.dart';

class ProductInfoPage extends StatelessWidget {
  final Product product;
  
  final String leafSVG = '''<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" viewBox="0 0 100 100">
    <path d="M50 0c-27.61 0-50 22.39-50 50s22.39 50 50 50 50-22.39 50-50-22.39-50-50-50zm0 90c-22.06 0-40-17.94-40-40s17.94-40 40-40 40 17.94 40 40-17.94 40-40 40z"/>
    <path d="M50 20c-16.57 0-30 13.43-30 30s13.43 30 30 30 30-13.43 30-30-13.43-30-30-30zm0 50c-11.05 0-20-8.95-20-20s8.95-20 20-20 20 8.95 20 20-8.95 20-20 20z" fill="green"/>
  </svg>''';

  const ProductInfoPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Product Info',
          style: TextStyle(
            color: Colors.white, // Set the text color to white
          ),
        ),
        backgroundColor: AppColors.primary, // Keep your background color as is
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            Text(
              product.productName, // Displaying just the product name
              style: TextStyle(
                fontSize: 24, // Larger font size for title
                fontWeight: FontWeight.w700, // Bold text
                color: AppColors.primary, // Dark color for readability
              ),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                product.productImage,
                fit: BoxFit.fitHeight,
                width: 200,
                height: 200,
              ),
            ),
            const SizedBox(height: 10),
            
            // Suitability Score in a green circle with white text
            _scoreCircle(
              score: product.productScore,
              label: 'Suitability Score',
            ),
            const SizedBox(height: 10),
            
            // Health Score in a green circle with white text
            _scoreCircle(
              score: product.productHealthScore,
              label: 'Health Score',
            ),
            const SizedBox(height: 10),
            
            // Row for "Summary" title with SVG on the left
            Row(
              children: [
                SvgPicture.string(
                  leafSVG, 
                  height: 20, // Set the height of the SVG
                ),
                const SizedBox(width: 10), // Add spacing between SVG and title
                Text(
                  'Summary',
                  style: TextStyle(
                    fontSize: 20, // H2 size (or equivalent)
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary, // Set the text color
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            
            // Create a Table for the ingredient names and descriptions
            Table(
              border: TableBorder.all(
                color: const Color.fromARGB(255, 216, 218, 225), // Set the border color for the table
                width: 1, // Border width
              ),
              columnWidths: {
                0: FixedColumnWidth(150), // Set the width for the name column
                1: FlexColumnWidth(), // Set the description column to take up the remaining space
              },
              children: [
                for (var ingredient in product.ingredientsListSummary)
                  if (ingredient is List && ingredient.length == 2)
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            ingredient[0], // Ingredient name
                            style: TextStyle(
                              fontSize: 18, // Font size for the name
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 44, 95, 51), // Name color
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            ingredient[1], // Ingredient description
                            style: TextStyle(
                              fontSize: 16, 
                              color: const Color.fromARGB(255, 57, 123, 67),
                            ),
                          ),
                        ),
                      ],
                    ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back to Scanner'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to create a green circle with white text for scores
  Widget _scoreCircle({required double score, required String label}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: _getScoreColor(score), // Green background
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              score.toStringAsFixed(1), // Display score with 1 decimal place
              style: const TextStyle(
                color: Colors.white, // White text
                fontSize: 18, // Font size for the score
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10), // Space between circle and label
        Text(
          label, // Label for the score
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.primary, // Color for the label
          ),
        ),
      ],
    );
  }
}

Color _getScoreColor(double score) {
    final int roundedScore = score.round();
    if (roundedScore >= 8) return Colors.red;
    if (roundedScore >= 6) return Colors.orange;
    if (roundedScore >= 4) return Colors.yellow;
    return Colors.green;
  }