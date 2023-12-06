import 'package:ecommerce/models/product.dart';
import 'package:http/http.dart' as http;

class ProductService {
  static var client = http.Client();

  // NOTE: not complete
  static Future<List<ProductModel>> getAllProducts() async {
    var url = Uri.parse('https://fakestoreapi.com/products');
    var response = await client.get(Uri.parse(''));

    if (response.statusCode == 200) {
      var jsonString = response.body;
      return [];
    } else {
      return [];
    }
  }


}
