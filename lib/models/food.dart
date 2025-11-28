class Food {
  final Map<String, String> name;
  final String imageUrl;
  final Map<String, String> description;
  final double latitude;
  final double longitude;
  final bool isMustDo;
  final bool hasOffer;
  final Map<String,String> offerDescription;
  final Map<String, String>? localizedImageUrl; //
  final String? affiliateLink;



  Food({
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.isMustDo,
    required this.hasOffer,
    required this.offerDescription,
    required this.localizedImageUrl,
    this.affiliateLink//

  });

  // Factory zum Erzeugen aus JSON
  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      name: Map<String, String>.from(json['name'] ?? {}),
      imageUrl: json['imageUrl'] ?? '',
      description: Map<String, String>.from(json['description'] ?? {}),
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      isMustDo: json['isMustDo'] == true,
      hasOffer: json['hasOffer'] == true,
      offerDescription: Map<String, String>.from(json['offerDescription'] ?? {}),
        localizedImageUrl: json['localizedImageUrl'] != null
    ? Map<String, String>.from(json['localizedImageUrl'])
        : null, // ✅ parsing
      affiliateLink: json['affiliateLink'] ?? '',
    );
  }
}
