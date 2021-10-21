class ItemModal {
  final String id;
  final String title;
  String unit;
  final double quantity;
  double amount;
  final double weight;

  DateTime expiryDate;
  ItemModal({
    required this.id,
    
    required this.title,
    required this.amount,
    required this.weight,
    required this.unit,
    required this.quantity,
    required this.expiryDate,
  });
}
