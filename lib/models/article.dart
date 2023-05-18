class Article {
  String id;
  String name;
  int quantity;
  String idCat;
  String marque;

  Article({
    required this.id,
    required this.name,
    required this.quantity,
    required this.idCat,
    required this.marque,
  });

  // Convert Article object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'idCat': idCat,
      'marque': marque,
    };
  }

  // Create Article object from JSON
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      idCat: json['idCat'],
      marque: json['marque'],
    );
  }
}
