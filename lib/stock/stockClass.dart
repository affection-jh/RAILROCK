import 'package:railrock/stock/trackingInfoEnroll.dart';

class Stock {
  String category;
  String imageUrl;
  String imageCode; // String type for the image path
  String title; // Title of the stock
  List<TrackingInfo> trackingInfoList;
  int stocks; // Current stock amount
  int expectedToInStock; // Expected stock in the future
  int neededStocks;
  // Number of stocks needed
  // Constructor
  Stock({
    required this.category,
    required this.imageUrl,
    required this.imageCode,
    required this.title,
    required this.trackingInfoList,
    required this.stocks,
    required this.expectedToInStock,
    required this.neededStocks,
  });

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'imageUrl': imageUrl,
      'imageCode': imageCode,
      'title': title,
      'trackingInfoList': trackingInfoList.map((info) => info.toMap()).toList(),
      'stocks': stocks,
      'expectedToInStock': expectedToInStock,
      'neededStocks': neededStocks,
    };
  }

  factory Stock.fromMap(Map<String, dynamic> map) {
    return Stock(
      category: map['category'],
      imageUrl: map['imageUrl'],
      imageCode: map['imageCode'],
      title: map['title'],
      trackingInfoList: map['trackingInfoList'] != null
          ? List<TrackingInfo>.from(
              map['trackingInfoList'].map((item) => TrackingInfo.fromMap(item)))
          : [],
      stocks: map['stocks'],
      expectedToInStock: map['expectedToInStock'],
      neededStocks: map['neededStocks'],
    );
  }
}

List<Stock> allStocks = [];
List<Stock> locomotive = [];
List<Stock> passenger_car = [];
List<Stock> cargo_car = [];
List<Stock> accessory = [];

void categorizeFromlastElement() {
  int idx = allStocks.length - 1;
  switch (allStocks[idx].category) {
    case '기관차':
      locomotive.add(allStocks[idx]);
      break;
    case '객차':
      passenger_car.add(allStocks[idx]);
      break;
    case '화차':
      cargo_car.add(allStocks[idx]);
      break;
    default:
      accessory.add(allStocks[idx]);
  }
}

void categorizeFromAllStocks() {
  for (int i = 0; i < allStocks.length; i++) {
    switch (allStocks[i].category) {
      case '기관차':
        locomotive.add(allStocks[i]);
        break;
      case '객차':
        passenger_car.add(allStocks[i]);
        break;
      case '화차':
        cargo_car.add(allStocks[i]);
        break;
      default:
        accessory.add(allStocks[i]);
    }
  }
}

void clearAllLists() {
  allStocks.clear();
  locomotive.clear();
  passenger_car.clear();
  cargo_car.clear();
  accessory.clear();
}
