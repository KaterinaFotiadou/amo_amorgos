class ExploreItem {
  final Map<String, String> title;
  final String imageUrl;

  ExploreItem({
    required this.title,
    required this.imageUrl,
  });

  // Factory aus JSON
  factory ExploreItem.fromJson(Map<String, dynamic> json) {
    return ExploreItem(
      title: Map<String, String>.from(json['title'] ?? {}),
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
