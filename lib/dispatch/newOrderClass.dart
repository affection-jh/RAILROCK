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
}
