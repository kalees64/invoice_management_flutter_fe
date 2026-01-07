class PaymentModel {
  final String id;
  final String invoiceId;
  final String invoiceNo;
  final String paymentNo;
  final double amount;
  final DateTime date;
  final String? transactionId;
  final String paymentStatus; // PAID | PARTIALLY_PAID
  final String paymentMode; // CASH | UPI | CARD | BANK_TRANSFER | CHEQUE

  PaymentModel({
    required this.id,
    required this.invoiceId,
    required this.invoiceNo,
    required this.paymentNo,
    required this.amount,
    required this.date,
    required this.transactionId,
    required this.paymentStatus,
    required this.paymentMode,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      invoiceId: json['invoiceId'],
      invoiceNo: json['invoiceNo'],
      paymentNo: json['paymentNo'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      transactionId: json['transactionId'],
      paymentStatus: json['paymentStatus'],
      paymentMode: json['paymentMode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoiceId': invoiceId,
      'invoiceNo': invoiceNo,
      'paymentNo': paymentNo,
      'amount': amount,
      'date': date.toIso8601String(),
      'transactionId': transactionId,
      'paymentStatus': paymentStatus,
      'paymentMode': paymentMode,
    };
  }

  @override
  String toString() {
    return 'PaymentModel{id: $id, invoiceId: $invoiceId, invoiceNo: $invoiceNo, paymentNo: $paymentNo, amount: $amount, date: $date, transactionId: $transactionId, paymentStatus: $paymentStatus}, paymentMode: $paymentMode}';
  }
}
