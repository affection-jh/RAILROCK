class Stock {
  String category;
  String imagePath; // String type for the image path
  String title; // Title of the stock
  int stocks; // Current stock amount
  int expectedToInStock; // Expected stock in the future
  int neededStocks; // Number of stocks needed
  // Constructor
  Stock({
    required this.category,
    required this.imagePath,
    required this.title,
    required this.stocks,
    required this.expectedToInStock,
    required this.neededStocks,
  });
}

List<Stock> stocks = [];
List<Stock> locomotive = [];
List<Stock> passenger_car = [];
List<Stock> cargo_car = [];
List<Stock> accessory = [];
