class MeditationTechnique {
  final int id;
  final String title;
  final String description;
  final String imageUrl;

  MeditationTechnique({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,

  });

  factory MeditationTechnique.fromJson(Map<String,dynamic>json){
    return MeditationTechnique(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        imageUrl: json['imageUrl']
    );
  }
}