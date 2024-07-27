import 'metas.dart';

class Song {
  late String audio;
  late Metas metas;

  Song.fromJson(Map<String, dynamic> data) {
    audio = data['audio'];
    metas = Metas.fromJson(data['metas']);
  }
}
