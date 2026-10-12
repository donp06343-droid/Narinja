import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/bank_account.dart';
import '../services/bank_account_service.dart';

class AddBankAccountSheet extends StatefulWidget {
  final Function(BankAccount) onAccountAdded;
  const AddBankAccountSheet({super.key, required this.onAccountAdded});

  @override
  State<AddBankAccountSheet> createState() => _AddBankAccountSheetState();
}

class _AddBankAccountSheetState extends State<AddBankAccountSheet> {
  static const Color naranjaX = Color(0xFFFF6900);

  final _formKey = GlobalKey<FormState>();
  final _bankNameController = TextEditingController();
  final _holderController = TextEditingController();
  final _cbuController = TextEditingController();
  final _aliasController = TextEditingController();
  String _accountType = 'Caja de ahorro';

  @override
  void dispose() {
    _bankNameController.dispose();
    _holderController.dispose();
    _cbuController.dispose();
    _aliasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Agregar cuenta bancaria',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _bankNameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del banco',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.account_balance),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Ingresá el banco' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _holderController,
                decoration: const InputDecoration(
                  labelText: 'Titular de la cuenta',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Ingresá el titular'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _cbuController,
                keyboardType: TextInputType.number,
                maxLength: 22,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'CBU / CVU (22 dígitos)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.numbers),
                  counterText: '',
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Ingresá el CBU';
                  if (v.length != 22) return 'Debe tener 22 dígitos';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _aliasController,
                decoration: const InputDecoration(
                  labelText: 'Alias (opcional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.alternate_email),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _accountType,
                decoration: const InputDecoration(
                  labelText: 'Tipo de cuenta',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                      value: 'Caja de ahorro', child: Text('Caja de ahorro')),
                  DropdownMenuItem(
                      value: 'Cuenta corriente',
                      child: Text('Cuenta corriente')),
                ],
                onChanged: (v) => setState(() => _accountType = v!),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: naranjaX),
                        foregroundColor: naranjaX,
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: naranjaX,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Agregar'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final newAccount = BankAccount(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      bankName: _bankNameController.text.trim(),
      accountHolder: _holderController.text.trim(),
      cbu: _cbuController.text.trim(),
      alias: _aliasController.text.trim(),
      accountType: _accountType,
    );

    await BankAccountService.addAccount(newAccount);
    widget.onAccountAdded(newAccount);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Cuenta agregada exitosamente!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
