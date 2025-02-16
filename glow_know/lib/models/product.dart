class Product {
  final String productName;
  final double productScore;
  final double productEnvironmentScore;
  final String productType;
  final String ingredientsList;
  final String ingredientsListSummary;
  final String ingredientsListBreakdown;

  Product({
    required this.productName,
    required this.productScore,
    required this.productEnvironmentScore,
    required this.productType,
    required this.ingredientsList,
    required this.ingredientsListSummary,
    required this.ingredientsListBreakdown,
  });

  Map<String, dynamic> toJson() => {
    'productName': productName,
    'productScore': productScore,
    'productEnvironmentScore': productEnvironmentScore,
    'productType': productType,
    'ingredientsList': ingredientsList,
    'ingredientsListSummary': ingredientsListSummary,
    'ingredientsListBreakdown': ingredientsListBreakdown,
  };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    productName: json['productName'],
    productScore: json['productScore'],
    productEnvironmentScore: json['productEnvironmentScore'],
    productType: json['productType'],
    ingredientsList: json['ingredientsList'],
    ingredientsListSummary: json['ingredientsListSummary'],
    ingredientsListBreakdown: json['ingredientsListBreakdown'],
  );
}
