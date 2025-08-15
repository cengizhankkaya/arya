import 'package:http/http.dart' as http;
import 'package:openfoodfacts/openfoodfacts.dart' as off;

class ProductService {
  final _baseUri = Uri.parse(
    'https://world.openfoodfacts.org/cgi/product_jqm.pl',
  );

  Future<off.Status> saveProductToOpenFoodFacts(
    Map<String, String> body,
  ) async {
    final headers = {
      'User-Agent': 'Arya-Flutter-App/1.0 (https://github.com/your-repo)',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
    };

    try {
      final response = await http.post(_baseUri, headers: headers, body: body);
      if (response.statusCode == 200) {
        if (response.body.contains('"status":1')) {
          return off.Status(
            status: 1,
            statusVerbose: 'Product saved successfully',
          );
        } else {
          return off.Status(status: 0, statusVerbose: 'Product not saved');
        }
      } else {
        return off.Status(
          status: -1,
          statusVerbose: 'HTTP error: ${response.statusCode}',
        );
      }
    } catch (e) {
      return off.Status(status: -1, statusVerbose: 'Network error: $e');
    }
  }
}
