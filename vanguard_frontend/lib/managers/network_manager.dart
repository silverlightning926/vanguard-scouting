import 'dart:convert' as json;
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vanguard_frontend/serialized/competition.dart';
import 'package:vanguard_frontend/serialized/match.dart';
import 'package:vanguard_frontend/serialized/robot.dart';
import 'package:vanguard_frontend/serialized/team_stats.dart';

class NetworkManager {
  static const String _baseURL = '10.0.0.217:3000';

  static const String _statusEndpoint = '/status';
  static const String _competitionsEndpoint = '/getCompetitions';
  static const String _matchesEndpoint = '/getMatches';
  static const String _robotEndpoint = '/getTeam';
  static const String _startMatchEndpoint = '/startMatch';
  static const String _scoreGamePieceEndpoint = '/scoreGamePiece';
  static const String _pickUpGamePieceEndpoint = '/pickUpGamePiece';
  static const String _faultEndpoint = '/addFault';
  static const String _nonGamePieceScoringEndpoint = '/scoreNonGamePiece';
  static const String _endMatchEndpoint = '/endMatch';
  static const String _addNotesEndpoint = '/addNotes';
  static const String _getTeamsEndpoint = '/getTeams';
  static const String _getStats = '/getStats';

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
      Uri.http(_baseURL, '$_matchesEndpoint/$eventKey'),
    );
    return (json.jsonDecode(response.body) as List)
        .map((data) => Match.fromJson(data))
        .toList();
  }

  static Future<Robot> getRobot(
      String matchKey, String allianceStationID) async {
    http.Response response = await http.get(
      Uri.http(_baseURL, '$_robotEndpoint/$matchKey/$allianceStationID'),
    );
    return Robot.fromJson(json.jsonDecode(response.body));
  }

  static Future<int> startMatch(int robotInMatchID, String preloadPiece) async {
    http.Response response = await http.post(
      Uri.http(_baseURL, '$_startMatchEndpoint/$robotInMatchID/$preloadPiece'),
    );

    return response.body == 'null' ? -1 : jsonDecode(response.body)['scoutID'];
  }

  static Future<bool> scoreGamePiece(int scoutID, String matchPeriod,
      String gamepiece, String locationID) async {
    http.Response response = await http.post(
      Uri.http(
        _baseURL,
        '$_scoreGamePieceEndpoint/$scoutID/$matchPeriod/$gamepiece/$locationID',
      ),
    );

    return response.statusCode == 200;
  }

  static Future<bool> pickupGamePiece(int scoutID, String matchPeriod,
      String gamepiece, String locationID) async {
    http.Response response = await http.post(
      Uri.http(
        _baseURL,
        '$_pickUpGamePieceEndpoint/$scoutID/$matchPeriod/$gamepiece/$locationID',
      ),
    );

    return response.statusCode == 200;
  }

  static Future<bool> addFault(
      int scoutID, String matchPeriod, String faultTypeID) async {
    http.Response response = await http.post(
      Uri.http(
        _baseURL,
        '$_faultEndpoint/$scoutID/$matchPeriod/$faultTypeID',
      ),
    );

    return response.statusCode == 200;
  }

  static Future<bool> scoreNonGamePiece(
      int scoutID, String matchPeriod, String scoringType) async {
    http.Response response = await http.post(
      Uri.http(
        _baseURL,
        '$_nonGamePieceScoringEndpoint/$scoutID/$matchPeriod/$scoringType',
      ),
    );

    return response.statusCode == 200;
  }

  static Future<bool> endMatch(int scoutID) async {
    http.Response response = await http.post(
      Uri.http(
        _baseURL,
        '$_endMatchEndpoint/$scoutID',
      ),
    );

    return response.statusCode == 200;
  }

  static Future<bool> addNotes(int scoutID, String notes) async {
    http.Response response = await http.post(
      Uri.http(
        _baseURL,
        '$_addNotesEndpoint/$scoutID',
      ),
      body: {
        "notes": notes.replaceAll(
          RegExp('[^A-Za-z0-9]'),
          '',
        ),
      },
      encoding: Encoding.getByName("utf-8"),
    );

    return response.statusCode == 200;
  }

  static Future<List<Robot>> getTeams() async {
    http.Response response = await http.get(
      Uri.http(_baseURL, _getTeamsEndpoint),
    );
    return (json.jsonDecode(response.body) as List)
        .map((data) => Robot.fromJson(data))
        .toList();
  }

  static Future<List<TeamStats>> getStats() async {
    http.Response response = await http.get(
      Uri.http(_baseURL, _getStats),
    );
    return (json.jsonDecode(response.body) as List)
        .map((data) => TeamStats.fromJson(data))
        .toList();
  }
}
