class BankAccount {
  final String id;
  final String bankName;
  final String accountHolder;
  final String cbu;
  final String alias;
  final String accountType;
  final double balance;

  BankAccount({
    required this.id,
    required this.bankName,
    required this.accountHolder,
    required this.cbu,
    required this.alias,
    required this.accountType,
    this.balance = 0.0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'bankName': bankName,
        'accountHolder': accountHolder,
        'cbu': cbu,
        'alias': alias,
        'accountType': accountType,
        'balance': balance,
      };

  factory BankAccount.fromJson(Map<String, dynamic> json) => BankAccount(
        id: json['id'],
        bankName: json['bankName'],
        accountHolder: json['accountHolder'],
        cbu: json['cbu'],
        alias: json['alias'],
        accountType: json['accountType'],
        balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      );
}
