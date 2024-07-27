class Metas {
  late String title;
  late String artist;
  late String image;

  Metas.fromJson(Map<String, dynamic> data) {
    title = data['title'];
    artist = data['artist'];
    image = data['image'];
  }
}
