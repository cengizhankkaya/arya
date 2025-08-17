import 'package:openfoodfacts/openfoodfacts.dart' as off;
import 'package:http/http.dart' as http;
import '../model/product_model.dart';

abstract class IProductRepository {
  Future<off.Status> saveProduct(
    ProductModel product,
    String username,
    String password,
  );
}

class ProductRepository implements IProductRepository {
  static const String _baseUrl = 'https://world.openfoodfacts.org';
  static const String _endpoint = '/cgi/product_jqm.pl';

  @override
  Future<off.Status> saveProduct(
    ProductModel product,
    String username,
    String password,
  ) async {
    final uri = Uri.parse('$_baseUrl$_endpoint');

    // Form data hazırla
    final body = <String, String>{
      ...product.toApiData(),
      'user_id': username,
      'password': password,
      'action': 'process',
      'json': '1',
      'type': 'product',
    };

    // Headers
    final headers = <String, String>{
      'User-Agent': 'Arya-Flutter-App/1.0 (https://github.com/your-repo)',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json, text/html, */*',
      'Accept-Language': 'en-US,en;q=0.9',
      'Origin': _baseUrl,
      'Referer': '$_baseUrl/',
    };

    try {
      final client = http.Client();
      final request = http.Request('POST', uri);
      request.headers.addAll(headers);
      request.bodyFields = body;

      print('DEBUG: Sending request to: $uri');
      print('DEBUG: Headers: $headers');
      print('DEBUG: Body: $body');

      final streamedResponse = await client.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      print('DEBUG: Response status: ${response.statusCode}');
      print('DEBUG: Response headers: ${response.headers}');
      print('DEBUG: Response body: ${response.body}');

      // Redirect'leri handle et
      if (response.statusCode >= 300 && response.statusCode < 400) {
        return await _handleRedirect(client, response, headers, body);
      } else if (response.statusCode == 200) {
        return _parseResponse(response.body);
      } else {
        return off.Status(
          status: -1,
          statusVerbose:
              'HTTP error: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      print('DEBUG: Exception occurred: $e');
      return off.Status(status: -1, statusVerbose: 'Network error: $e');
    }
  }

  Future<off.Status> _handleRedirect(
    http.Client client,
    http.Response response,
    Map<String, String> headers,
    Map<String, String> body,
  ) async {
    final location = response.headers['location'];
    if (location == null) {
      return off.Status(
        status: -1,
        statusVerbose:
            'Redirect error: ${response.statusCode} - no location header',
      );
    }

    print('DEBUG: Following redirect to: $location');

    try {
      final redirectUri = Uri.parse(location);
      final redirectRequest = http.Request('POST', redirectUri);
      redirectRequest.headers.addAll(headers);
      redirectRequest.bodyFields = body;

      final redirectResponse = await client.send(redirectRequest);
      final finalResponse = await http.Response.fromStream(redirectResponse);

      print('DEBUG: Redirect response status: ${finalResponse.statusCode}');
      print('DEBUG: Redirect response body: ${finalResponse.body}');

      if (finalResponse.statusCode == 200) {
        return _parseResponse(finalResponse.body);
      } else {
        return off.Status(
          status: -1,
          statusVerbose: 'Redirect failed: ${finalResponse.statusCode}',
        );
      }
    } catch (e) {
      return off.Status(status: -1, statusVerbose: 'Redirect error: $e');
    }
  }

  off.Status _parseResponse(String responseBody) {
    try {
      if (responseBody.contains('"status":1')) {
        return off.Status(
          status: 1,
          statusVerbose: 'Product saved successfully',
        );
      } else if (responseBody.contains('"status":0')) {
        return off.Status(status: 0, statusVerbose: 'Product not saved');
      } else {
        return off.Status(status: -1, statusVerbose: 'Unknown response');
      }
    } catch (e) {
      return off.Status(status: -1, statusVerbose: 'Parse error: $e');
    }
  }
}
