import 'dart:convert';
import 'dart:developer';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List> apiResponse(query) async {
  String apiKey = 'D0H1102ESxdfYd4MOO3lzccHeAuPIcfkqfzuivLLu_M';
  var client = http.Client();

  try {
    final response = await client.get(Uri.parse(
        'https://api.unsplash.com/search/photos?per_page=30&client_id=$apiKey&query=$query'));
    final jsonData = json.decode(response.body);
    return (jsonData["results"] as List);
  } catch (e) {
    debugPrint(e.toString());
    return [];
  }
}
