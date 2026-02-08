import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/network/storage_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final StorageService _storage = StorageService();
  bool _biometricsEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final enabled = await _storage.isBiometricsEnabled();
    setState(() {
      _biometricsEnabled = enabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Dados'),
        backgroundColor: AppColors.navyBlue,
        foregroundColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                   _buildInfoField('Nome Completo', 'Carlos Alberto Valente'),
                   const SizedBox(height: 16),
                   _buildInfoField('CPF', '123.456.789-00', isReadOnly: true),
                   const SizedBox(height: 16),
                   _buildSettingsTile(
                     title: 'Acesso por Biometria',
                     subtitle: 'Entrar usando digital ou FaceID',
                     value: _biometricsEnabled,
                     onChanged: (val) async {
                       await _storage.setBiometricsEnabled(val);
                       setState(() => _biometricsEnabled = val);
                     },
                   ),
                   const Divider(height: 32),
                   
                   SizedBox(
                     width: double.infinity,
                     child: ElevatedButton(
                       onPressed: () {},
                       style: ElevatedButton.styleFrom(
                         backgroundColor: AppColors.navyBlue,
                         foregroundColor: Colors.white,
                         padding: const EdgeInsets.symmetric(vertical: 16),
                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                       ),
                       child: const Text('ALTERAR SENHA', style: TextStyle(fontWeight: FontWeight.bold)),
                     ),
                   ),
                   
                   const SizedBox(height: 16),
                   
                   SizedBox(
                     width: double.infinity,
                     child: TextButton.icon(
                       onPressed: () async {
                         bool confirm = await _showLogoutConfirm();
                         if (confirm && mounted) {
                           await _storage.clearAll();
                           Navigator.pushReplacementNamed(context, '/login');
                         }
                       },
                       icon: const Icon(Icons.logout, color: Colors.red),
                       label: const Text('SAIR DA CONTA', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                       style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                     ),
                   ),
                   const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _showLogoutConfirm() async {
    return await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sair da conta'),
        content: const Text('Tem certeza que deseja sair? Você precisará informar seu CPF novamente ao entrar.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('CANCELAR')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('SAIR', style: TextStyle(color: Colors.red))),
        ],
      ),
    ) ?? false;
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: const BoxDecoration(
        color: AppColors.navyBlue,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.primaryOrange,
            child: Text('CV', style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 16),
          const Text('Carlos Alberto Valente', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const Text('Beneficiário Diamante', style: TextStyle(color: Colors.white70, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildInfoField(String label, String value, {bool isReadOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.navyBlue)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isReadOnly ? Colors.grey.shade100 : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(value, style: TextStyle(fontSize: 16, color: isReadOnly ? Colors.grey.shade600 : AppColors.textBody, fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }

  Widget _buildSettingsTile({required String title, required String subtitle, required bool value, required ValueChanged<bool> onChanged}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navyBlue)),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primaryOrange,
      ),
    );
  }
}
