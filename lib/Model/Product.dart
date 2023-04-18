class Product {
  int id;
  String tensp;
  String hinhanh;
  String mota;
  int loai;

  Product(this.id, this.tensp, this.hinhanh, this.mota, this.loai);

  Product.fromJson(Map<String, dynamic> json)
      : id = int.parse(json['id']),
        tensp = json['tensp'],
        hinhanh = json['hinhanh'],
        mota = json['mota'],
        loai = int.parse(json['loai']);

  Map<String, dynamic> toJson() => {
    'id': id.toString(),
    'tensp': tensp,
    'hinhanh': hinhanh,
    'mota': mota,
    'loai': loai.toString()
  };
}