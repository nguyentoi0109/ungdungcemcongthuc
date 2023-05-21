class ProductModel {
  int id;
  String tensp;
  String hinhanh;
  String mota;
  int loai;

  ProductModel(this.id, this.tensp, this.hinhanh, this.mota, this.loai);

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
        int.tryParse(json['id'].toString())!,
        json['tensp'] as String,
        json['hinhanh'] as String,
        json['mota'] as String,
        int.tryParse(json['loai'].toString())!);
  }

  Map<String, dynamic> toJson() => {
    'id': id.toString(),
    'tensp': tensp,
    'hinhanh': hinhanh,
    'mota': mota,
    'loai': loai.toString()
  };
}