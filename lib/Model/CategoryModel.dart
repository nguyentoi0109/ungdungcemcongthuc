class CategoryModel {
  int id;
  String name;
  String image;

  CategoryModel(this.id, this.name, this.image);

  factory CategoryModel.fromJson(dynamic json) {
    return CategoryModel(
      int.tryParse(json['id'].toString())!,
      json['name'] as String,
      json['image'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'image': image,
        'id': id,
      };
}
