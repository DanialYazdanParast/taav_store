class SellerSalesStatModel {
  final String productId;
  final String title;
  final String image;
  final int totalQuantitySold;
  final int totalRevenue;

  SellerSalesStatModel({
    required this.productId,
    required this.title,
    required this.image,
    required this.totalQuantitySold,
    required this.totalRevenue,
  });
}