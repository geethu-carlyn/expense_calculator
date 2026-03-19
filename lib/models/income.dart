class Income {
  final String id;
  final double amount;
  final DateTime date;

  Income({
    required this.id,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }

  factory Income.fromJson(Map<String, dynamic> json) {
    return Income(
      id: json['id'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
    );
  }
}
