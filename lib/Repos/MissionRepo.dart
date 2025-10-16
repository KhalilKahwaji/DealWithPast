// ignore_for_file: file_names, avoid_print, unused_import

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:interactive_map/Repos/UserRepo.dart';

class MissionRepo {

  /// Get nearby missions based on user location
  Future<dynamic> getNearbyMissions(double lat, double lng, {double radius = 10, String? token}) async {
    final headers = {
      "connection": "keep-alive",
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final response = await http.get(
      Uri.parse('https://dwp.world/wp-json/dwp/v1/missions/nearby?lat=$lat&lng=$lng&radius=$radius'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      print('Error getting nearby missions: ${response.statusCode}');
      return null;
    }
  }

  /// Get mission details by ID
  Future<dynamic> getMissionDetails(int missionId, String? token) async {
    final headers = {
      "connection": "keep-alive",
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final response = await http.get(
      Uri.parse('https://dwp.world/wp-json/dwp/v1/missions/$missionId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      print('Error getting mission details: ${response.statusCode}');
      return null;
    }
  }

  /// Create a new mission (user-generated)
  Future<dynamic> createMission(Map<String, dynamic> missionData, String username, String password) async {
    UserRepo userRepo = UserRepo();
    var token = await userRepo.AuthenticateOther(username, password);

    String url = 'https://dwp.world/wp-json/dwp/v1/missions/create';

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var request = http.Request('POST', Uri.parse(url));
    request.headers.addAll(requestHeaders);
    request.body = jsonEncode(missionData);

    var res = await request.send();
    var content = await res.stream.bytesToString();
    return content;
  }

  /// Start a mission
  Future<dynamic> startMission(int missionId, String token) async {
    String url = 'https://dwp.world/wp-json/dwp/v1/missions/start';

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var request = http.Request('POST', Uri.parse(url));
    request.headers.addAll(requestHeaders);
    request.body = jsonEncode({'mission_id': missionId});

    var res = await request.send();
    var content = await res.stream.bytesToString();
    return content;
  }

  /// Complete a mission
  Future<dynamic> completeMission(int missionId, String token, {List<String>? proofMedia}) async {
    String url = 'https://dwp.world/wp-json/dwp/v1/missions/complete';

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var body = {
      'mission_id': missionId,
      if (proofMedia != null) 'proof_media': proofMedia,
    };

    var request = http.Request('POST', Uri.parse(url));
    request.headers.addAll(requestHeaders);
    request.body = jsonEncode(body);

    var res = await request.send();
    var content = await res.stream.bytesToString();
    return content;
  }

  /// Get user's missions (active and completed)
  Future<dynamic> getMyMissions(String token) async {
    final response = await http.get(
      Uri.parse('https://dwp.world/wp-json/dwp/v1/missions/my-missions'),
      headers: {
        "connection": "keep-alive",
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      print('Error getting user missions: ${response.statusCode}');
      return null;
    }
  }
}
