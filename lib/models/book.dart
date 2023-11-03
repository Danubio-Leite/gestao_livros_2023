class Book {
  String id;
  String title;
  String author;

  Book({required this.id, required this.title, required this.author});

  Book.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        title = map["title"],
        author = map["author"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "author": author,
    };
  }
}
