class ProductModel {
  String? id;
  String? name;
  String? category;
  num price;
  String? productImageUrl;
  String? description;

  ProductModel(
      {this.id,
      this.name,
      this.category,
      this.price = 0.0,
      this.productImageUrl,
      this.description});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      'id' : id,
      'name' : name,
      'description' : description,
      'image' : productImageUrl,
      'price' : price,
      'category' : category,
    };
    return map;
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) => ProductModel(
    id: map['id'],
    name: map['name'],
    description: map['description'],
    price: map['price'],
    productImageUrl: map['image'],
    category: map['category'],
  );
}