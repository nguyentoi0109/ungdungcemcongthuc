class DetailModel {
  int id;
  String name;
  String nguyenlieu;
  String mota;

  DetailModel(this.id, this.name, this.nguyenlieu, this.mota);

  DetailModel.fromJson(Map<String, dynamic> json)
      : id = int.parse(json['id']),
        name = json['name'],
        nguyenlieu = json['nguyenlieu'],
        mota = json['mota'];

  Map<String, dynamic> toJson() => {
        'id': id.toString(),
        'name': name,
        'nguyenlieu': nguyenlieu,
        'mota': mota,
      };
}
