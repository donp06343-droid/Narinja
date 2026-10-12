import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bank_account.dart';

class BankAccountService {
  static const String _key = 'bank_accounts';

  static Future<void> saveAccounts(List<BankAccount> accounts) async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(
      accounts.map((a) => a.toJson()).toList(),
    );
    await prefs.setString(_key, jsonString);
  }

  static Future<List<BankAccount>> loadAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_key);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((j) => BankAccount.fromJson(j)).toList();
  }

  static Future<List<BankAccount>> addAccount(BankAccount account) async {
    final accounts = await loadAccounts();
    accounts.add(account);
    await saveAccounts(accounts);
    return accounts;
  }
}
