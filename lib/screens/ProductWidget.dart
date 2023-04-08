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
    return ListTile(
        // onTap: () {
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (_) =>
        //               DetailForm(id: _foundUser[index].id)));
        // },
        title: Container(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black12, borderRadius: BorderRadius.circular(5)),
        padding: const EdgeInsets.all(1.0),
        child: Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 3),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Container(
                      height: 100.0,
                      width: 100.0,
                      child: Image.network(
                        "${widget.product.hinhanh}",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${widget.product.tensp}",
                          style: TextStyle(fontSize: 20),
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Text(
                      "${widget.product.mota}",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ]),
              ),
              StarButton(isStarred: isFav, valueChanged: _onFavChange),
            ]),
      ),
    ));
  }

  void _onFavChange(bool fav) async{
    print('_onFavChange ${widget.product.id} -> $fav');
    if (fav) {
     await DataManager().addFavourite(widget.product.id);
    } else {
     await DataManager().removeFavourite(widget.product.id);
    }
    setState(() {});
  }
}
