import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'screens/accounts_screen.dart'; // 🆕

const kPurple = Color(0xFF500080);
const kLilac = Color(0xFFF1E8F7);
const kBg = Color(0xFFFAFAFA);
const kText = Color(0xFF333333);
const kGrey = Color(0xFF6E6E6E);
const kOrange = Color(0xFFFF5A1F);
const kBadge = Color(0xFFC8400A);

// ✅ Ahora es mutable para poder editar el nombre del destinatario
String kNombre = 'Carmena Gutierrez Elias Rene Isaac';
const kCuil = '20-49470022-1';
const kCbu = '0110169630016910970301';

double saldoGlobal = 0.34;

String fmtInt(int n) {
  final s = n.toString();
  final b = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
    b.write(s[i]);
  }
  return b.toString();
}

String fmtMoney(double v) {
  final cents = (v * 100).round();
  final ent = cents ~/ 100;
  final dec = (cents % 100).toString().padLeft(2, '0');
  return '${fmtInt(ent)},$dec';
}

Widget bigMoney(String ent, String dec, {double size = 36, Color color = kText}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.only(top: size * 0.35),
        child: Text('\$ ', style: TextStyle(fontSize: size * 0.5, fontWeight: FontWeight.bold, color: color)),
      ),
      Text(ent, style: TextStyle(fontSize: size, fontWeight: FontWeight.bold, color: color, height: 1.1)),
      Padding(
        padding: const EdgeInsets.only(left: 2),
        child: Text(dec, style: TextStyle(fontSize: size * 0.45, fontWeight: FontWeight.bold, color: color)),
      ),
    ],
  );
}

Widget nxLogo({double size = 22}) => Text(
      'NX',
      style: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.w900,
        color: kOrange,
        letterSpacing: -1,
      ),
    );

Widget backArrow(BuildContext context) => IconButton(
      icon: const Icon(Icons.arrow_back, color: kPurple),
      onPressed: () => Navigator.pop(context),
    );

Widget purpleButton(String text, VoidCallback? onTap) {
  return SizedBox(
    width: double.infinity,
    height: 52,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: kPurple,
        disabledBackgroundColor: const Color(0xFFE6E6E6),
        foregroundColor: Colors.white,
        disabledForegroundColor: kGrey,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      onPressed: onTap,
      child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
    ),
  );
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Naranja X',
      theme: ThemeData(
        useMaterial3: false,
        primaryColor: kPurple,
        scaffoldBackgroundColor: kBg,
        fontFamily: 'Roboto',
        textTheme: ThemeData.light().textTheme.apply(bodyColor: kText, displayColor: kText),
      ),
      home: const HomeScreen(),
    );
  }
}

// ---------------- INICIO ----------------
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool ocultar = false;

  @override
  Widget build(BuildContext context) {
    final cents = (saldoGlobal * 100).round();
    final ent = fmtInt(cents ~/ 100);
    final dec = (cents % 100).toString().padLeft(2, '0');

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                          child: nxLogo(size: 18),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(child: Text('Nos encanta verte,\nElias', style: TextStyle(fontSize: 14))),
                        const Icon(Icons.notifications_none, color: kPurple),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(color: kLilac, borderRadius: BorderRadius.circular(14)),
                          child: const Row(
                            children: [
                              Icon(Icons.help_outline, color: kPurple, size: 18),
                              SizedBox(width: 4),
                              Text('Ayuda', style: TextStyle(color: kPurple, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 6, offset: Offset(0, 2))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final r = await Navigator.push(
                                  context, MaterialPageRoute(builder: (_) => const ModifyBalanceScreen()));
                              if (r != null) setState(() => saldoGlobal = r);
                            },
                            child: Row(
                              children: [
                                const Text('Cuenta en pesos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFDDF3DF), borderRadius: BorderRadius.circular(8)),
                                  child: const Text('+20%', style: TextStyle(color: Color(0xFF1B7A2B), fontSize: 12)),
                                ),
                                const Spacer(),
                                const Icon(Icons.chevron_right, color: kPurple),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              ocultar
                                  ? const Text('\$ ••••', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))
                                  : bigMoney(ent, dec, size: 34),
                              const SizedBox(width: 12),
                              GestureDetector(
                                onTap: () => setState(() => ocultar = !ocultar),
                                child: Icon(ocultar ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                    color: kPurple, size: 22),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _action(Icons.vertical_align_top, 'Agregar', () {}),
                              _action(Icons.swap_horiz, 'Transferir', () async {
                                await Navigator.push(
                                    context, MaterialPageRoute(builder: (_) => const TransferScreen()));
                                setState(() {});
                              }),
                              _action(Icons.notes, 'Alias y CBU', () {}),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Text('Tus atajos', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    GridView.count(
                      crossAxisCount: 4,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1.45,
                      children: [
                        _shortcut(const Icon(Icons.savings_outlined, color: kPurple, size: 22), 'Frascos', '22%'),
                        _shortcut(const Text('U\$D', style: TextStyle(color: kPurple, fontWeight: FontWeight.bold, fontSize: 12)), 'Dólares', null),
                        _shortcut(const Icon(Icons.receipt_long_outlined, color: kPurple, size: 22), 'Servicios', null),
                        _shortcut(const Icon(Icons.flash_on_outlined, color: kPurple, size: 22), 'Recargas', null),
                        _shortcut(const Icon(Icons.directions_bus_outlined, color: kPurple, size: 22), 'QR transporte', null),
                        _shortcut(const Icon(Icons.verified_user_outlined, color: kPurple, size: 22), 'Seguros', null),
                        _shortcut(const Icon(Icons.card_giftcard_outlined, color: kPurple, size: 22), 'Donar', null),
                        _shortcut(const Icon(Icons.luggage_outlined, color: kPurple, size: 22), 'Viajes NX', null),
                      ],
                    ),
                    const SizedBox(height: 22),
                    const Text('Promos especiales', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFFFFF1EA), Color(0xFFFDE3D8)]),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Cinemark', style: TextStyle(color: kBadge, fontWeight: FontWeight.w600)),
                                Text('2x1', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
                                Text('Con tarjetas de crédito y débito.'),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            child: const Text('CINEMARK',
                                style: TextStyle(color: Color(0xFFD0021B), fontSize: 9, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _nav(Icons.home_outlined, 'Inicio', true),
                  // 🆕 "Cuentas" ahora navega a la pantalla de cuentas bancarias
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AccountsScreen()),
                      );
                    },
                    child: _nav(Icons.bar_chart, 'Cuentas', false),
                  ),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: const BoxDecoration(color: kPurple, shape: BoxShape.circle),
                    child: const Icon(Icons.qr_code_scanner, color: Colors.white),
                  ),
                  _nav(Icons.credit_card, 'Tarjetas', false),
                  _nav(Icons.grid_view, 'Más', false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nav(IconData i, String t, bool sel) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(i, color: sel ? kPurple : kGrey),
          Text(t, style: TextStyle(fontSize: 11, color: sel ? kPurple : kGrey, fontWeight: sel ? FontWeight.w600 : FontWeight.normal)),
        ],
      );

  Widget _action(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(color: kLilac, shape: BoxShape.circle),
            child: Icon(icon, color: kPurple),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _shortcut(Widget icon, String label, String? badge) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE3E3E3), width: 1.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(color: kLilac, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: icon,
              ),
              const SizedBox(height: 4),
              Text(label, style: const TextStyle(fontSize: 10), textAlign: TextAlign.center),
            ],
          ),
        ),
        if (badge != null)
          Positioned(
            top: -8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: kBadge, borderRadius: BorderRadius.circular(8)),
              child: Text(badge, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ),
      ],
    );
  }
}

// ---------------- MODIFICAR SALDO ----------------
class ModifyBalanceScreen extends StatefulWidget {
  const ModifyBalanceScreen({super.key});

  @override
  State<ModifyBalanceScreen> createState() => _ModifyBalanceScreenState();
}

class _ModifyBalanceScreenState extends State<ModifyBalanceScreen> {
  final _c = TextEditingController(text: saldoGlobal.toStringAsFixed(2).replaceAll('.', ','));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modificar saldo'),
        backgroundColor: kPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _c,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]'))],
              decoration: const InputDecoration(labelText: 'Nuevo saldo', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            purpleButton('Guardar', () {
              final v = double.tryParse(_c.text.replaceAll(',', '.')) ?? 0.0;
              Navigator.pop(context, v);
            }),
          ],
        ),
      ),
    );
  }
}

// ---------------- TRANSFERIR (CONTACTOS) ----------------
class TransferScreen extends StatelessWidget {
  const TransferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                backArrow(context),
                const Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Icon(Icons.help_outline, color: kPurple),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: kPurple, width: 2))),
                    child: const Center(
                        child: Text('Transferir', style: TextStyle(color: kPurple, fontWeight: FontWeight.w600, fontSize: 16))),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Color(0xFFE3E3E3), width: 1))),
                    child: const Center(
                        child: Text('Actividad', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16))),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 6, offset: Offset(0, 2))],
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.person_add_alt, color: kPurple),
                        SizedBox(width: 14),
                        Expanded(child: Text('A una nueva cuenta', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                        Icon(Icons.chevron_right, color: kPurple),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: const Color(0xFF9E9E9E)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search, color: kGrey),
                        SizedBox(width: 8),
                        Text('Buscá por nombre o apodo', style: TextStyle(color: kGrey, fontSize: 16)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _chip('Sugeridos', true),
                      const SizedBox(width: 10),
                      _chip('Favoritos', false),
                      const SizedBox(width: 10),
                      _chip('Grupos', false),
                    ],
                  ),
                ],
              ),
            ),
            _contact(context, 'CG', kNombre, true, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AmountScreen()));
            }),
            _contact(context, 'CB', 'Cecilia Beatriz Colque', false, () {}),
            _contact(context, 'BN', 'Braian Nahuel Navarrete Vizcarra', false, () {}),
            _contact(context, 'CS', 'Condori Sergio Ruben', false, () {}),
          ],
        ),
      ),
    );
  }

  Widget _chip(String t, bool sel) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          color: sel ? kLilac : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: sel ? kPurple : kText, width: 1.5),
        ),
        child: Text(t, style: TextStyle(fontWeight: FontWeight.w600, color: sel ? kPurple : kText)),
      );

  Widget _contact(BuildContext context, String ini, String name, bool tag, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFE6E6E6)))),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: kLilac, borderRadius: BorderRadius.circular(10)),
              alignment: Alignment.center,
              child: Text(ini, style: const TextStyle(color: kPurple, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(width: 14),
            Expanded(child: Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
            if (tag)
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: kPurple, borderRadius: BorderRadius.circular(12)),
                child: const Text('Tus cuentas', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            const Icon(Icons.chevron_right, color: kPurple),
          ],
        ),
      ),
    );
  }
}

// ---------------- MONTO ----------------
class _AmountFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue old, TextEditingValue neu) {
    final t = neu.text.replaceAll('.', ',');
    if (!RegExp(r'^[0-9]*,?[0-9]{0,2}$').hasMatch(t)) return old;
    if (t.length > 12) return old;
    return neu.copyWith(text: t, selection: TextSelection.collapsed(offset: t.length));
  }
}

class AmountScreen extends StatefulWidget {
  const AmountScreen({super.key});

  @override
  State<AmountScreen> createState() => _AmountScreenState();
}

class _AmountScreenState extends State<AmountScreen> {
  final _c = TextEditingController();
  final _f = FocusNode();
  bool programar = false;

  double get valor => double.tryParse(_c.text.replaceAll(',', '.')) ?? 0;

  @override
  void initState() {
    super.initState();
    _c.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _c.dispose();
    _f.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final parts = _c.text.split(',');
    final entRaw = parts[0].isEmpty ? 0 : int.parse(parts[0]);
    final ent = fmtInt(entRaw);
    final dec = parts.length > 1 ? parts[1].padRight(2, '0') : '00';
    final insuf = valor > saldoGlobal;
    final ok = valor > 0 && !insuf;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              backArrow(context),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Text('¿Cuánto vas a transferir a $kNombre?',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () => _f.requestFocus(),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.only(bottom: 4),
                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: kPurple, width: 2))),
                  width: double.infinity,
                  child: Center(child: bigMoney(ent, dec, size: 42)),
                ),
              ),
              SizedBox(
                height: 1,
                child: Opacity(
                  opacity: 0,
                  child: TextField(
                    controller: _c,
                    focusNode: _f,
                    autofocus: true,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [_AmountFormatter()],
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  insuf ? 'No tenés saldo suficiente' : 'Dinero en cuenta \$ ${fmtMoney(saldoGlobal)}',
                  style: TextStyle(color: insuf ? Colors.red : kGrey, fontSize: 15),
                ),
              ),
              const SizedBox(height: 22),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: Row(
                  children: [
                    const Expanded(child: Text('Programar para otro día', style: TextStyle(fontSize: 16))),
                    Switch(
                      value: programar,
                      activeColor: kPurple,
                      onChanged: (v) => setState(() => programar = v),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text.rich(TextSpan(children: [
                  TextSpan(text: 'Motivo: ', style: TextStyle(fontSize: 15)),
                  TextSpan(text: 'Varios', style: TextStyle(fontSize: 15, color: kPurple, fontWeight: FontWeight.w600)),
                  WidgetSpan(child: Icon(Icons.keyboard_arrow_down, color: kPurple, size: 22)),
                ])),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: purpleButton('Continuar', ok
                    ? () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => ConfirmScreen(monto: valor)))
                    : null),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- CONFIRMAR ----------------
class ConfirmScreen extends StatefulWidget {
  final double monto;
  const ConfirmScreen({super.key, required this.monto});

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  Future<void> _editarNombre() async {
    final nuevo = await showDialog<String>(
      context: context,
      builder: (_) => const _EditNameDialog(),
    );
    if (nuevo != null && nuevo.trim().isNotEmpty) {
      setState(() => kNombre = nuevo.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final monto = widget.monto;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            backArrow(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    margin: const EdgeInsets.only(top: 6),
                    decoration: BoxDecoration(color: const Color(0xFF0E7C8F), borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.account_balance, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Vas a transferir a', style: TextStyle(color: kGrey, fontSize: 15)),
                        // ✅ Nombre tocable para editar
                        GestureDetector(
                          onTap: _editarNombre,
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  kNombre,
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.edit, color: kPurple, size: 16),
                            ],
                          ),
                        ),
                        const Text('CUIL: $kCuil', style: TextStyle(color: kGrey, fontSize: 15)),
                        const Text('CBU: $kCbu', style: TextStyle(fontSize: 15)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('\$ ${fmtMoney(monto)}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: Container(
                width: 256,
                height: 350,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFF7F2FA), Color(0xFFEBDDF5)]),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [BoxShadow(color: Color(0x44000000), blurRadius: 8, offset: Offset(0, 4))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    nxLogo(size: 30),
                    const Spacer(),
                    const Text('Dinero en cuenta', style: TextStyle(fontSize: 15)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text('\$ ${fmtMoney(saldoGlobal)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        const Spacer(),
                        const Icon(Icons.visibility_outlined, color: kPurple, size: 20),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: purpleButton('Transferir', () {
                saldoGlobal -= monto;
                if (saldoGlobal < 0) saldoGlobal = 0;
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => SuccessScreen(monto: monto)));
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- ÉXITO ----------------
class SuccessScreen extends StatefulWidget {
  final double monto;
  const SuccessScreen({super.key, required this.monto});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  final AudioPlayer _player = AudioPlayer();
  late final String codigo;

  @override
  void initState() {
    super.initState();
    final r = Random();
    String h(int n) => List.generate(n, (_) => r.nextInt(16).toRadixString(16)).join();
    codigo = '${h(8)}-${h(4)}-${h(4)}-${h(4)}-${h(12)}';
    _play();
  }

  void _play() async {
    try {
      await _player.play(AssetSource('audio/transfer_sound.mp3'));
    } catch (_) {}
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.topCenter,
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 44),
                          padding: const EdgeInsets.fromLTRB(16, 62, 16, 20),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: const Color(0xFFE6E6E6)),
                          ),
                          child: Column(
                            children: [
                              Text('Transferiste \$ ${fmtMoney(widget.monto)} a $kNombre',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 20),
                              const Divider(height: 1),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: const Color(0xFFDDDDDD)),
                                        borderRadius: BorderRadius.circular(6)),
                                    child: nxLogo(size: 18),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text('Con dinero de tu cuenta en pesos', style: TextStyle(fontSize: 16)),
                                ],
                              ),
                              const SizedBox(height: 14),
                              const Divider(height: 1),
                              const SizedBox(height: 14),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.info, color: Color(0xFF1155AA), size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text('Código de transacción: $codigo',
                                        style: const TextStyle(fontSize: 14, color: kGrey)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('A su cuenta de:', style: TextStyle(fontSize: 16)),
                                    SizedBox(height: 6),
                                    Text('●  Banco Nación', style: TextStyle(fontSize: 16)),
                                    SizedBox(height: 4),
                                    Text('●  CBU: $kCbu', style: TextStyle(fontSize: 16)),
                                    SizedBox(height: 4),
                                    Text('●  CUIL: $kCuil', style: TextStyle(fontSize: 16)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 18),
                              purpleButton('Compartir comprobante', () {}),
                            ],
                          ),
                        ),
                        Container(
                          width: 88,
                          height: 88,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Color(0xFF45C27A), Color(0xFF2FA55F)]),
                          ),
                          child: const Icon(Icons.check, color: Colors.white, size: 56),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 6, offset: Offset(0, 2))],
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.touch_app_outlined, size: 34),
                          SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Categorizá este movimiento',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                Text('Dale seguimiento a tus gastos.', style: TextStyle(color: kGrey)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              color: Colors.white,
              child: TextButton(
                style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 18)),
                onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
                child: const Text('Ir a Inicio',
                    style: TextStyle(color: kPurple, fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- DIÁLOGO EDITAR NOMBRE ----------------
class _EditNameDialog extends StatefulWidget {
  const _EditNameDialog();

  @override
  State<_EditNameDialog> createState() => _EditNameDialogState();
}

class _EditNameDialogState extends State<_EditNameDialog> {
  late final TextEditingController _c = TextEditingController(text: kNombre);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cambiar nombre'),
      content: TextField(
        controller: _c,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        decoration: const InputDecoration(
          labelText: 'Nombre del destinatario',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, _c.text),
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
