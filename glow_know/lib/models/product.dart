class Product {
  final String productBarcode;
  final String productName;
  final double productScore;
  final double productEnvironmentScore;
  final String productType;
  final String ingredientsList;
  final String ingredientsListSummary;
  final String ingredientsListBreakdown;
  final String productImage;

  Product({
    required this.productBarcode,
    required this.productName,
    required this.productImage,
    required this.productScore,
    required this.productEnvironmentScore,
    required this.productType,
    required this.ingredientsList,
    required this.ingredientsListSummary,
    required this.ingredientsListBreakdown,
  });

  Map<String, dynamic> toJson() => {
    'productBarcode': productBarcode,
    'productName': productName,
    'productImage': productImage,
    'productScore': productScore,
    'productEnvironmentScore': productEnvironmentScore,
    'productType': productType,
    'ingredientsList': ingredientsList,
    'ingredientsListSummary': ingredientsListSummary,
    'ingredientsListBreakdown': ingredientsListBreakdown,
  };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    productBarcode: json['productBarcode'],
    productName: json['productName'],
    productImage: json['productImage'],
    productScore: json['productScore'],
    productEnvironmentScore: json['productEnvironmentScore'],
    productType: json['productType'],
    ingredientsList: json['ingredientsList'],
    ingredientsListSummary: json['ingredientsListSummary'],
    ingredientsListBreakdown: json['ingredientsListBreakdown'],
  );
}
