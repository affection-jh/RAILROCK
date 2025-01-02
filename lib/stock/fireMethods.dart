import 'package:firebase_storage/firebase_storage.dart';
import 'stockClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

void saveStockToFirestore(Stock stock) async {
  try {
    await FirebaseFirestore.instance
        .collection('stocks')
        .doc(stock.title)
        .set(stock.toMap());
    print("Stock added successfully!");
  } catch (e) {
    print("Error saving stock: $e");
  }
}

Future<void> updateStock(Stock stock) async {
  try {
    await FirebaseFirestore.instance
        .collection('stocks')
        .doc(stock.title)
        .update(stock.toMap());

    print("Stock updated successfully!");
    saveStockToFirestore(stock);
    var box = await Hive.openBox('stockBox');
    box.put(stock.title, stock);
  } catch (e) {
    print("Error updating stock: $e");
  }
}

Future<List<Stock>> initializeStocksList() async {
  try {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('stocks').get();

    List<Stock> stockList = snapshot.docs.map((doc) {
      return Stock.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();

    return stockList;
  } catch (e) {
    print("Error getting stocks: $e");
    return [];
  }
}

Future<void> deleteStock(Stock stock) async {
  try {
    if (stock.imageCode != '') {
      final storageRef = FirebaseStorage.instance.ref();
      await storageRef.child('post').child(stock.imageCode).delete();
    }
    await FirebaseFirestore.instance
        .collection('stocks')
        .doc(stock.title)
        .delete();

    print("Stock deleted successfully!");
  } catch (e) {
    print("Error deleting stock: $e");
  }
}

Future<void> deleteShippingCard(String title, int i) async {
  try {
    final docRef = FirebaseFirestore.instance.collection('stocks').doc(title);
    final snapshot = await docRef.get();
    if (snapshot.exists) {
      List<dynamic> trackingInfoList =
          snapshot.data()?['trackingInfoList'] ?? [];

      if (trackingInfoList.isNotEmpty) {
        trackingInfoList.removeAt(i);
      }

      await docRef.update({
        'trackingInfoList': trackingInfoList,
      });
    }
    print("Shipping card removed successfully.");
  } catch (e) {
    print("Failed to remove shipping card: $e");
  }
}
