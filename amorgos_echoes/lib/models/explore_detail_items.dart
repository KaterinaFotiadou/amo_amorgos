class ExploreDetailItem {
  final Map<String, String> category;
  final Map<String, String> title;
  final Map<String, String> name;
  final Map<String, String> description;
  final String imageUrl;
  final double? latitude;
  final double? longitude;
  final String? affiliateLink;
  final bool isMustDo;
  final Map<String, String>? offerDescription;
  final Map<String, String>? localizedImageUrl;


  ExploreDetailItem({
    required this.category,
    required this.title,
    required this.name,
    required this.description,
    required this.imageUrl,
    this.latitude,
    this.longitude,
    this.affiliateLink,
    required this.isMustDo,
    this.offerDescription,
    this.localizedImageUrl
  });

  factory ExploreDetailItem.fromJson(Map<String, dynamic> json) {
    Map<String, String> _safeMap(dynamic raw) {
      if (raw is Map) return Map<String, String>.from(raw);
      return {};
    }

    return ExploreDetailItem(
      category: _safeMap(json['category']),
      title: _safeMap(json['title']),
      name: _safeMap(json['name']),
      description: _safeMap(json['description']),
      imageUrl: json['imageUrl'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      affiliateLink: json['affiliateLink'] ?? '',
      isMustDo: json['isMustDo'] == true,
      offerDescription: json['offerDescription'] != null ? _safeMap(json['offerDescription']) : null,
      localizedImageUrl: json['localizedImageUrl'] != null ? _safeMap(json['localizedImageUrl']) : null,

    );
  }
}
