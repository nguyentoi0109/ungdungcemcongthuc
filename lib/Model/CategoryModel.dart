class CategoryModel {
  int id;
  String name;
  String image;

  CategoryModel(this.id, this.name, this.image);

  CategoryModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        image = json['image'],
        id = int.parse(json['id']);

  Map<String, dynamic> toJson() => {
    'name': name,
    'image': image,
    'id': id,
  };
}