class Beach {
  final Map<String, String> name;
  final Map<String, String> description;
  final double latitude;
  final double longitude;
  final String imageUrl;
  final bool isMustDo;

  Beach({
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    required this.isMustDo,
  });

  factory Beach.fromJson(Map<String, dynamic> json) {
    return Beach(
      name: Map<String, String>.from(json['name'] ?? {}),
      description: Map<String, String>.from(json['description'] ?? {}),
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'] ?? '',
      isMustDo: json['isMustDo'] == true,
    );
  }

  // 🔁 Επιστρέφει το μεταφρασμένο string
  String getName(String lang) => name[lang] ?? name['en'] ?? '';
  String getDescription(String lang) => description[lang] ?? description['en'] ?? '';
}

