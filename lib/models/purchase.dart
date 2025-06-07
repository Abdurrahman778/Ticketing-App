class Purchase {
  final String id;
  final String ticketId;
  final String ticketName;
  final String ticketCategory;
  final int amount;
  final String paymentMethod;
  final DateTime purchaseDate;
  final String status;

  Purchase({
    required this.id,
    required this.ticketId,
    required this.ticketName,
    required this.ticketCategory,
    required this.amount,
    required this.paymentMethod,
    required this.purchaseDate,
    required this.status,
  });

  factory Purchase.fromMap(Map<String, dynamic> map, String id) {
    return Purchase(
      id: id,
      ticketId: map['ticketId'] ?? '',
      ticketName: map['ticketName'] ?? '',
      ticketCategory: map['ticketCategory'] ?? '',
      amount: map['amount'] ?? 0,
      paymentMethod: map['paymentMethod'] ?? '',
      purchaseDate: DateTime.fromMillisecondsSinceEpoch(map['purchaseDate'] ?? 0),
      status: map['status'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ticketId': ticketId,
      'ticketName': ticketName,
      'ticketCategory': ticketCategory,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'purchaseDate': purchaseDate.millisecondsSinceEpoch,
      'status': status,
    };
  }
}
