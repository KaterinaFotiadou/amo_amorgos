class WelcomeSlide {
  final Map<String, String> title;
  final Map<String, String>subtitle;
  final Map<String, String> text;
  final String imageUrl;

  WelcomeSlide({
    required this.title,
    required this.subtitle,
    required this.text,
    required this.imageUrl,
  });

  // Factory aus JSON
  factory WelcomeSlide.fromJson(Map<String, dynamic> json) {
    return WelcomeSlide(
      title: Map<String, String>.from(json['title'] ?? {}),
      subtitle: Map<String, String>.from(json['subtitle'] ?? {}),
      text: Map<String, String>.from(json['text'] ?? {}),
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
