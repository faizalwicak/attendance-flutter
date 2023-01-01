class Link {
  final int? id;
  final String? title;
  final String? link;

  Link({
    this.id,
    this.title,
    this.link,
  });

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      id: json['id'],
      title: json['title'],
      link: json['link'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'link': link,
    };
  }
}
