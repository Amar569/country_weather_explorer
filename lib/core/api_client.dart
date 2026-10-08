import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'app_exception.dart';
import 'config.dart';

/// Single place for networking, timeouts and error translation.
class ApiClient {
  ApiClient([http.Client? client]) : _client = client ?? http.Client();
  final http.Client _client;

  Future<dynamic> getJson(Uri uri) async {
    final http.Response res;
    try {
      res = await _client.get(uri).timeout(AppConfig.requestTimeout);
    } on SocketException {
      throw const AppException('No internet connection. Check your network.');
    } on http.ClientException {
      throw const AppException('No internet connection. Check your network.');
    } on TimeoutException {
      throw const AppException('The request timed out. Please try again.');
    }

    if (res.statusCode == 404) {
      throw const AppException('No data found.');
    }
    if (res.statusCode != 200) {
      throw AppException('Server error (${res.statusCode}). Please try again.');
    }
    if (res.body.trim().isEmpty) {
      throw const AppException('The server returned an empty response.');
    }
    try {
      return jsonDecode(res.body);
    } on FormatException {
      throw const AppException('The server returned an invalid response.');
    }
  }
}
