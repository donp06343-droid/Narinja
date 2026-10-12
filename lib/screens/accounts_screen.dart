import 'package:flutter/material.dart';
import '../models/bank_account.dart';
import '../services/bank_account_service.dart';
import '../widgets/add_bank_account_sheet.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  static const Color naranjaX = Color(0xFFFF6900);
  List<BankAccount> _accounts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    final accounts = await BankAccountService.loadAccounts();
    if (mounted) {
      setState(() {
        _accounts = accounts;
        _loading = false;
      });
    }
  }

  void _showAddAccountSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => AddBankAccountSheet(
        onAccountAdded: (account) {
          setState(() => _accounts.add(account));
        },
      ),
    );
  }

  Future<void> _deleteAccount(BankAccount account) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar cuenta'),
        content: Text('¿Querés eliminar la cuenta de ${account.bankName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      setState(() => _accounts.remove(account));
      await BankAccountService.saveAccounts(_accounts);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: naranjaX,
        foregroundColor: Colors.white,
        title: const Text('Mis cuentas'),
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: naranjaX))
          : _accounts.isEmpty
              ? _buildEmptyState()
              : _buildAccountsList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddAccountSheet,
        backgroundColor: naranjaX,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Agregar cuenta'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance_wallet_outlined,
                size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No tenés cuentas agregadas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tocá el botón de abajo para agregar tu primera cuenta bancaria.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _accounts.length,
      itemBuilder: (context, index) {
        final account = _accounts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: naranjaX.withOpacity(0.15),
              child: const Icon(Icons.account_balance, color: naranjaX),
            ),
            title: Text(
              account.bankName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(account.accountHolder),
                Text(
                  '${account.accountType} • ${_maskCbu(account.cbu)}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                if (account.alias.isNotEmpty)
                  Text(
                    'Alias: ${account.alias}',
                    style:
                        TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _deleteAccount(account),
            ),
          ),
        );
      },
    );
  }

  String _maskCbu(String cbu) {
    if (cbu.length < 8) return cbu;
    return '${cbu.substring(0, 4)}****${cbu.substring(cbu.length - 4)}';
  }
}
