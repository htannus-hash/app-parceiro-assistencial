import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/network/storage_service.dart';
import '../../../../core/utils/launcher_utils.dart';
import '../widgets/smart_card.dart';
import '../../../telemedicine/presentation/pages/webview_page.dart';
import '../../../financial/presentation/pages/finance_page.dart';
import 'partner_network_page.dart';
import 'profile_page.dart';
import 'notifications_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final StorageService _storage = StorageService();
  final Connectivity _connectivity = Connectivity();
  
  Map<String, dynamic>? _userData;
  String? _lastUpdate;
  bool _isOffline = false;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _checkConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _isOffline = result == ConnectivityResult.none;
      });
    });
  }

  Future<void> _checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    setState(() {
      _isOffline = result == ConnectivityResult.none;
    });
  }

  Future<void> _loadUserData() async {
    final user = await _storage.getUser();
    final update = await _storage.getLastUpdate();
    setState(() {
      _userData = user;
      if (update != null) {
        _lastUpdate = DateFormat('dd/MM HH:mm').format(DateTime.parse(update));
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parceiro Assistencial'),
        backgroundColor: AppColors.navyBlue,
        foregroundColor: AppColors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationsPage()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => LauncherUtils.openWhatsApp(message: 'Olá! Preciso de ajuda.'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_isOffline)
              Container(
                width: double.infinity,
                color: Colors.red.shade400,
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off, size: 14, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      'Modo Offline - Dados de $_lastUpdate',
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SmartCard(
                    userName: _userData?['name'] ?? 'Carregando...',
                    cardNumber: _userData?['cardNumber'] ?? '0000 0000 0000 0000',
                    planType: _userData?['planType'] ?? 'DIAMANTE',
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Principais Serviços',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.navyBlue),
                  ),
                  const SizedBox(height: 16),
                  _buildServiceGrid(context),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => LauncherUtils.openWhatsApp(message: 'Suporte Parceiro'),
        backgroundColor: Colors.green,
        child: const Icon(Icons.message, color: Colors.white),
      ),
    );
  }

  Widget _buildServiceGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _ServiceCard(
          title: 'Telemedicina',
          icon: Icons.medical_services_outlined,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const WebViewPage(
                title: 'Telemedicina',
                url: 'https://telemed.parceiroassistencial.com.br',
                token: 'JWT_TOKEN_PLACEHOLDER',
              ),
            ),
          ),
        ),
        _ServiceCard(
          title: 'Telepsicologia',
          icon: Icons.psychology_outlined,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const WebViewPage(
                title: 'Telepsicologia',
                url: 'https://psychology.parceiroassistencial.com.br',
                token: 'JWT_TOKEN_PLACEHOLDER',
              ),
            ),
          ),
        ),
        _ServiceCard(
          title: 'Pagamentos',
          icon: Icons.payments_outlined,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FinancePage()),
          ),
        ),
        _ServiceCard(
          title: 'Rede Credenciada',
          icon: Icons.local_hospital_outlined,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PartnerNetworkPage()),
          ),
        ),
      ],
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _ServiceCard({required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: AppColors.primaryOrange),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.navyBlue)),
          ],
        ),
      ),
    );
  }
}
