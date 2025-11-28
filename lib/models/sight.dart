class Sight {
  final Map<String, String> name;
  final String imageUrl;
  final Map<String, String> description;
  final double latitude;
  final double longitude;
  final bool isMustDo;

  Sight({
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.isMustDo,
  });

  // Factory zum Erzeugen aus JSON
  factory Sight.fromJson(Map<String, dynamic> json) {
    return Sight(
      name: Map<String, String>.from(json['name'] ?? {}),
      imageUrl: json['imageUrl'] ?? '',
      description: Map<String, String>.from(json['description'] ?? {}),
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      isMustDo: json['isMustDo'] == true,

    );
  }
}
