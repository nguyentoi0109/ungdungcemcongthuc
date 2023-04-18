import 'package:app/Model/Product.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';

import '../DatabaseHandler/DataManager.dart';

class ProductWidget extends StatefulWidget {
  final Product product;

  const ProductWidget({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    var isFav = DataManager().checkFavourite(widget.product.id);
    return Container(
      decoration: BoxDecoration(color: Colors.black12,borderRadius: BorderRadius.circular(8.0)),
        margin: EdgeInsets.all(3.0),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: SizedBox(
                height: 90.0,
                width: 90.0,
                child: Image.network(
                  "${widget.product.hinhanh}",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "${widget.product.tensp}",
                        style: TextStyle(fontSize: 20),
                        maxLines: 1,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: Text(
                      "${widget.product.mota}",
                      style: TextStyle(fontSize: 15),
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
            ),
          ),
          StarButton(isStarred: isFav, valueChanged: _onFavChange),
        ]));
  }

  void _onFavChange(bool fav) async {
    // print('_onFavChange ${widget.product.id} -> $fav');
    if (fav) {
      await DataManager().addFavourite(widget.product);
    } else {
      await DataManager().removeFavourite(widget.product.id);
    }
    setState(() {});
  }
}
