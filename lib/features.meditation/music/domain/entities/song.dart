class Song {
  final int id;
  final String title;
  final String artist;
  final String link;
  final String? image; // 👈 allow nullable

  const Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.link,
    this.image, // 👈 allow null
  });
}
