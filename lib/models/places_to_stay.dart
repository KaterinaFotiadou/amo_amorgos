class PlacesToStay {
  final Map<String, String> name;
  final String imageUrl;
  final Map<String, String> description;
  final double latitude;
  final double longitude;
  final bool isMustDo;
  final String? affiliateLink;


  PlacesToStay({
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.isMustDo,
    this.affiliateLink//

  });

  // Factory zum Erzeugen aus JSON
  factory PlacesToStay.fromJson(Map<String, dynamic> json) {
    return PlacesToStay(
      name: Map<String, String>.from(json['name'] ?? {}),
      imageUrl: json['imageUrl'] ?? '',
      description: Map<String, String>.from(json['description'] ?? {}),
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      isMustDo: json['isMustDo'] == true,
      affiliateLink: json['affiliateLink'] ?? '',


    );
  }
}