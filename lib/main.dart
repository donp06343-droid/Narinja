import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Naranja X Clone',
      theme: ThemeData(
        primaryColor: const Color(0xFF5B0697), // Morado Naranja X
        scaffoldBackgroundColor: const Color(0xFFF7F7F7),
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}

// VARIABLE GLOBAL DE SALDO
double saldoGlobal = 0.34;

// --- PANTALLA 1: INICIO ---
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(4)),
                        child: const Text('NX', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      const Text('Nos encanta verte,\nElias', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  const Icon(Icons.notifications_none, color: Color(0xFF5B0697)),
                ],
              ),
              const SizedBox(height: 20),
              
              // Cuenta en pesos (Modificar Saldo)
              GestureDetector(
                onTap: () async {
                  // Navegar a modificar saldo
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ModifyBalanceScreen()),
                  );
                  if (result != null) {
                    setState(() {
                      saldoGlobal = result;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('Cuenta en pesos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(10)),
                            child: const Text('+20%', style: TextStyle(color: Colors.green, fontSize: 12)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text('\$${saldoGlobal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Botones de acción
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionButton(context, Icons.arrow_upward, 'Agregar', () {}),
                  _buildActionButton(context, Icons.swap_horiz, 'Transferir', () {
                    // Navegar a la pantalla de transferencia
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const TransferScreen()));
                  }),
                  _buildActionButton(context, Icons.account_balance_wallet_outlined, 'Alias y CBU', () {}),
                ],
              ),
              const SizedBox(height: 30),

              // Atajos
              const Text('Tus atajos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  _buildShortcut(Icons.savings, 'Frascos', '22%'),
                  _buildShortcut(Icons.attach_money, 'Dólares', null),
                  _buildShortcut(Icons.receipt_long, 'Servicios', null),
                  _buildShortcut(Icons.flash_on, 'Recargas', null),
                  _buildShortcut(Icons.qr_code, 'QR transporte', null),
                  _buildShortcut(Icons.security, 'Seguros', null),
                  _buildShortcut(Icons.favorite, 'Donar', null),
                  _buildShortcut(Icons.card_travel, 'Viajes NX', null),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFF0E6F6), shape: BoxShape.circle),
            child: Icon(icon, color: const Color(0xFF5B0697)),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildShortcut(IconData icon, String label, String? badge) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: const Color(0xFF5B0697)),
              const SizedBox(height: 4),
              Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500)),
            ],
          ),
          if (badge != null)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(4)),
                child: Text(badge, style: const TextStyle(color: Colors.white, fontSize: 8)),
              ),
            ),
        ],
      ),
    );
  }
}

// --- PANTALLA MODIFICAR SALDO ---
class ModifyBalanceScreen extends StatefulWidget {
  const ModifyBalanceScreen({super.key});

  @override
  State<ModifyBalanceScreen> createState() => _ModifyBalanceScreenState();
}

class _ModifyBalanceScreenState extends State<ModifyBalanceScreen> {
  final TextEditingController _controller = TextEditingController(text: saldoGlobal.toString());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modificar saldo'), backgroundColor: const Color(0xFF5B0697), foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Nuevo saldo', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5B0697), minimumSize: const Size(double.infinity, 50)),
              onPressed: () {
                double newBalance = double.tryParse(_controller.text) ?? 0.0;
                Navigator.pop(context, newBalance);
              },
              child: const Text('Guardar', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

// --- PANTALLA 2: TRANSFERIR (LISTA DE CONTACTOS) ---
class TransferScreen extends StatelessWidget {
  const TransferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transferir', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Buscá por nombre o apodo',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
            ),
            const SizedBox(height: 20),
            // Contacto Carmena
            ListTile(
              leading: CircleAvatar(backgroundColor: const Color(0xFFF0E6F6), child: const Text('CG', style: TextStyle(color: Color(0xFF5B0697)))),
              title: const Text('Carmena Gutierrez Elias Rene Isaac', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Banco Nación'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navegar a la pantalla de monto (Imagen 4)
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AmountScreen()));
              },
            ),
            const Divider(),
            // Otros contactos de ejemplo
            ListTile(
              leading: CircleAvatar(backgroundColor: const Color(0xFFF0E6F6), child: const Text('CB', style: TextStyle(color: Color(0xFF5B0697)))),
              title: const Text('Cecilia Beatriz Colque'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

// --- PANTALLA 4: MONTO A TRANSFERIR ---
class AmountScreen extends StatefulWidget {
  const AmountScreen({super.key});

  @override
  State<AmountScreen> createState() => _AmountScreenState();
}

class _AmountScreenState extends State<AmountScreen> {
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              '¿Cuánto vas a transferir a Carmena Gutierrez Elias Rene Isaac?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                prefixText: '\$ ',
                hintText: '0',
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 10),
            Text('Dinero en cuenta \$${saldoGlobal.toStringAsFixed(2)}', style: const TextStyle(color: Colors.grey)),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5B0697),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                double amount = double.tryParse(_amountController.text) ?? 0.0;
                if (amount > 0 && amount <= saldoGlobal) {
                  saldoGlobal -= amount;
                  // Ir a pantalla de éxito (Imagen 6) y reproducir sonido
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SuccessScreen()));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saldo insuficiente o monto inválido')));
                }
              },
              child: const Text('Transferir', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

// --- PANTALLA 6: ÉXITO Y SONIDO ---
class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _playSound();
  }

  void _playSound() async {
    // Reproduce el sonido al transferir
    await _audioPlayer.play(AssetSource('audio/transfer_sound.mp3'));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Icon(Icons.check_circle, color: Colors.green, size: 80),
              const SizedBox(height: 20),
              const Text(
                'Transferiste \$ 0,10 a Carmena Gutierrez Elias Rene Isaac',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade200)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text('NX ', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                        Text('Con dinero de tu cuenta en pesos'),
                      ],
                    ),
                    const Divider(),
                    const Text('A su cuenta de:'),
                    const Text('• Banco Nación'),
                    const Text('• CBU: 0110169630016910970301'),
                    const Text('• CUIL: 20-49470022-1'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5B0697), minimumSize: const Size(double.infinity, 45)),
                      onPressed: () {},
                      child: const Text('Compartir comprobante', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text('Ir a Inicio', style: TextStyle(color: Color(0xFF5B0697))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
