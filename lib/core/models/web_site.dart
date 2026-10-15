class WebSite {
  final String id;
  final String title;
  final String url;

  const WebSite({required this.id, required this.title, required this.url});

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'url': url};
  }

  factory WebSite.fromJson(Map<String, dynamic> json) {
    return WebSite(id: json['id'], title: json['title'], url: json['url']);
  }
}
