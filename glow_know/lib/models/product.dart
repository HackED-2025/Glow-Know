class Product {
  final String productName;
  final double productScore;
  final double productHealthScore;
  final String productType;
  final String ingredientsList;
  final String ingredientsListSummary;
  final String ingredientsListBreakdown;
  final String productImage;

  Product({
    required this.productName,
    required this.productImage,
    required this.productScore,
    required this.productHealthScore,
    required this.productType,
    required this.ingredientsList,
    required this.ingredientsListSummary,
    required this.ingredientsListBreakdown,
  });

  Map<String, dynamic> toJson() => {
    'productName': productName,
    'productImage': productImage,
    'productScore': productScore,
    'productHealthScore': productHealthScore,
    'productType': productType,
    'ingredientsList': ingredientsList,
    'ingredientsListSummary': ingredientsListSummary,
    'ingredientsListBreakdown': ingredientsListBreakdown,
  };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    productName: json['productName'],
    productImage: json['productImage'],
    productScore: json['productScore'],
    productHealthScore: json['productHealthScore'],
    productType: json['productType'],
    ingredientsList: json['ingredientsList'],
    ingredientsListSummary: json['ingredientsListSummary'],
    ingredientsListBreakdown: json['ingredientsListBreakdown'],
  );
}
