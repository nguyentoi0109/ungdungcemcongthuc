import 'package:flutter/material.dart';

class DetailForm extends StatefulWidget {
  const DetailForm({Key? key}) : super(key: key);

  @override
  State<DetailForm> createState() => _DetailFormState();
}

class _DetailFormState extends State<DetailForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Product'),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
              child: Scrollbar(
            thumbVisibility: true,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.only(top: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Ten san pham',
                      style: TextStyle(
                        fontSize: 30,
                      ),
                      maxLines: 2,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    child: Container(
                      height: 150.0,
                      width: 300.0,
                      child: Image.asset(
                        'assets/images/img.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.only(top: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Nguyên liệu',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.only(top: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '10 hoa đậu biếc khô' +
                          '\n'
                              '400 gạo nếp' +
                          '\n'
                              'Dừa nạo Đường' +
                          '\n'
                              'Đậu phộng Mè trắng',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.only(top: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Các bước làm',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Bước 1:',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '- Hoa đậu biếc khô bạn đem ngâm cùng nước sôi, trong khoảng 5 – 7 phút cho hoa ra hết màu. Sau đó, bạn vớt hoa ra và lấy phần nước màu xanh tím.' +
                          '\n'
                              '- Gạo nếp bạn đem vo sạch để ráo. Tiếp theo, bạn cho gạo nếp vào ngâm ngập trong nước hoa đậu biếc ít nhất từ 6 7 tiếng hoặc tốt nhất bạn nên ngâm qua đêm. Sau khi ngâm xong, bạn vớt gạo ra, cho ít muối vào rồi trộn đều lên, để gạo nghỉ 5 phút.' +
                          '\n'
                              '- Mè trắng bạn đem rang vàng rồi cho ra chén.' +
                          '\n'
                              '- Đậu phộng bạn đem rửa với nước, rồi để ráo. Sau đó, cho vào chảo rang vàng. Khi rang xong, bạn cho đậu ra , chà xát cho sạch vỏ rồi giã nhỏ đậu phộng cho vào chén.' +
                          '\n'
                              '- Dừa nào bạn cho ra thau, cho nước ấm vào nhào rồi vắt lấy nước cốt.',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Bước 2:',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '- Bạn cho nước vào nồi hấp rồi cho gạo đã ngấm vào xửng hấp, đặt nồi hấp lên bếp đun sôi nước. Bạn cho đường cùng một nửa nước cốt dừa vào xôi khi nước trong nồi hấp sôi lên khoảng 5 phút, đảo đều tay cho xôi ngấm.' +
                          '\n'
                              '- Hấp thêm khoảng 10 phút nữa thì bạn cho tiếp một nửa phần nước dừa vào, trộn đều. Tiếp theo, bạn đậy kín nắp nồi cho xôi chín. Khi xôi mềm dẻo không còn lõi ở giữa là đã chín rồi đấy!'
                              '\n',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Bước 3:',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '- Khi xôi chín, bạn cho xôi ra đĩa. Rắc ít mè rang lên trên. Đậu phộng và vừng bạn đem giã nhỏ rồi làm muối vừng để ăn kèm với xôi hoa đậu biếc. Hoặc bạn cũng có thể ăn kèm xôi hoa đậu biếc với ruốc, chả đều được.'
                      '\n'
                      '- Món xôi hoa đậu biếc khi hoàn thành có màu xanh đẹp mắt, thơm lừng hương nếp và có vị beo béo của nước cốt dừa. Cách làm món xôi này cũng đơn giản đúng không nào. Vậy còn chần chừ gì mà không bắt tay vào chế biến ngay để chiêu đãi cho cả gia đình thân yêu nào! Chúc bạn thành công.'
                      '\n',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          )),
        ));
  }
}
