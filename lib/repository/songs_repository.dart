import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/song.dart';

class SongsRepository {
  Future<List<Song>> getSongs() async {
    try {
      var result = await rootBundle.loadString('assets/data/songs.json');
      print('JSON result: $result'); // Debug output
      var response = jsonDecode(result);
      var songs = List<Song>.from(
          response['songs'].map((e) => Song.fromJson(e)).toList());
      return songs;
    } on Exception catch (e) {
      print('Error loading songs: $e'); // Debug output
      rethrow;
    }
  }
}
