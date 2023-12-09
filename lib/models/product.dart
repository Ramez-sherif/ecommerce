class MockProductModel {
  MockProductModel(
      {required this.id,
      required this.productName,
      required this.imageUrl,
      required this.productPrice,
      required this.productDescription});
  final String id;
  final String imageUrl;
  final String productName;
  final double productPrice;
  final String productDescription;
}
