import 'package:http/http.dart' as http;

class NetworkManager {
  static const String _baseURL = '10.0.2.2:3000';
  static const String _statusEndpoint = '/status';

  static Future<bool> isAlive() async {
    http.Response response =
        await http.get(Uri.http(_baseURL, _statusEndpoint));
    return response.statusCode == 200;
  }
}
