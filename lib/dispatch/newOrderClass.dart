import 'package:cloud_firestore/cloud_firestore.dart';

class NewOrder {
  final String name;
  final String productName;
  final int qty;
  final String tel;
  final String date;
  final String paid;
  final String adress;
  final String msg;
  final String bookCode;
  late String tn;
  bool isChecked;

  NewOrder(
      {required this.name,
      required this.productName,
      required this.qty,
      required this.tel,
      required this.date,
      required this.paid,
      required this.adress,
      required this.msg,
      required this.bookCode,
      this.isChecked = false,
      required this.tn});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'productName': productName,
      'qty': qty,
      'tel': tel,
      'date': date,
      'paid': paid,
      'adress': adress,
      'msg': msg,
      'bookCode': bookCode,
      'tn': tn,
      'isChecked': isChecked,
    };
  }

  factory NewOrder.fromMap(Map<String, dynamic> map) {
    return NewOrder(
      name: map['name'],
      productName: map['productName'],
      qty: map['qty'],
      tel: map['tel'],
      date: map['date'],
      paid: map['paid'],
      adress: map['adress'],
      msg: map['msg'],
      bookCode: map['bookCode'],
      tn: map['tn'],
      isChecked: map['isChecked'] ?? false,
    );
  }
}

void saveOrdersToFirebase(NewOrder newOrder) async {
  try {
    FirebaseFirestore.instance
        .collection('orders')
        .doc(newOrder.name)
        .set(newOrder.toMap());
  } catch (e) {
    print("error ${{e}}");
  }
}

void updateOrderFirebase(NewOrder newOrder) async {
  try {
    FirebaseFirestore.instance
        .collection('order')
        .doc(newOrder.name)
        .update(newOrder.toMap());
  } catch (e) {
    print("error ${{e}}");
  }
}

Future<List<NewOrder>> deriveOrdersFromFirebase() async {
  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot;
    querySnapshot = await FirebaseFirestore.instance.collection('orders').get();
    return querySnapshot.docs
        .map((doc) => NewOrder.fromMap(doc.data()))
        .toList();
  } catch (e) {
    throw Exception("Failed to load orders: $e");
  }
}
