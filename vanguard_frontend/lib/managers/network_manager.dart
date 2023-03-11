import 'dart:convert' as json;

import 'package:http/http.dart' as http;
import 'package:vanguard_frontend/serialized/competition.dart';
import 'package:vanguard_frontend/serialized/match.dart';

class NetworkManager {
  static const String _baseURL = '10.0.0.217:3000';

  static const String _statusEndpoint = '/status';
  static const String _competitionsEndpoint = '/getCompetitions';
  static const String _matchesEndpoint = '/getMatches';

  static Future<bool> isAlive() async {
    http.Response response = await http.get(
      Uri.http(_baseURL, _statusEndpoint),
    );
    return response.statusCode == 200;
  }

  static Future<List<Competition>> getCompetitions() async {
    http.Response response = await http.get(
      Uri.http(_baseURL, _competitionsEndpoint),
    );
    return (json.jsonDecode(response.body) as List)
        .map((data) => Competition.fromJson(data))
        .toList();
  }

  static Future<List<Match>> getMatches(String eventKey) async {
    http.Response response = await http.get(
      Uri.http(_baseURL, '$_competitionsEndpoint/$eventKey'),
    );
    return (json.jsonDecode(response.body) as List)
        .map((data) => Match.fromJson(data))
        .toList();
  }
}
