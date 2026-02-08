import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/network/storage_service.dart';
import '../../../core/utils/biometric_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _cpfController = TextEditingController();
  final StorageService _storage = StorageService();
  final BiometricService _biometric = BiometricService();
  
  bool _isLoading = false;
  bool _isCpfValid = false;
  bool _hasCheckedBiometrics = false;

  final _cpfMask = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  @override
  void initState() {
    super.initState();
    _cpfController.addListener(_validateCpf);
    _checkAutoBiometrics();
  }

  void _validateCpf() {
    final text = _cpfMask.getUnmaskedText();
    setState(() {
      _isCpfValid = text.length == 11;
    });
  }

  Future<void> _checkAutoBiometrics() async {
    if (_hasCheckedBiometrics) return;
    
    final bool isBioEnabled = await _storage.isBiometricsEnabled();
    final bool canBio = await _biometric.canCheckBiometrics();
    
    if (isBioEnabled && canBio) {
      final bool authenticated = await _biometric.authenticate();
      if (authenticated && mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
    _hasCheckedBiometrics = true;
  }

  @override
  void dispose() {
    _cpfController.removeListener(_validateCpf);
    _cpfController.dispose();
    super.dispose();
  }

  void _handleLoginFlow() async {
    if (!_isCpfValid) return;

    setState(() => _isLoading = true);

    // Simulated API call
    await Future.delayed(const Duration(seconds: 1));

    // Persist Mock User Data for Offline Mode
    final mockUser = {
      'name': 'Carlos Alberto Valente',
      'cpf': _cpfMask.getUnmaskedText(),
      'cardNumber': '4521 8890 2341 0012',
      'planType': 'DIAMANTE',
    };
    await _storage.saveUser(mockUser);

    setState(() => _isLoading = false);

    if (mounted) {
      final bool canBio = await _biometric.canCheckBiometrics();
      final bool bioEnabled = await _storage.isBiometricsEnabled();

      if (canBio && !bioEnabled) {
        _showBiometricOffer();
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  void _showBiometricOffer() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.fingerprint, size: 64, color: AppColors.primaryOrange),
            const SizedBox(height: 24),
            const Text(
              'Acesso Biométrico',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.navyBlue),
            ),
            const SizedBox(height: 12),
            const Text(
              'Deseja ativar o acesso por biometria para entrar mais rápido nas próximas vezes?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await _storage.setBiometricsEnabled(true);
                  if (mounted) {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/home');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('ATIVAR AGORA', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: const Text('AGORA NÃO', style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              const Icon(Icons.security, size: 80, color: AppColors.primaryOrange),
              const SizedBox(height: 32),
              const Text(
                'Acesse sua conta',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.navyBlue),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Informe seu CPF para realizar o login.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              TextField(
                controller: _cpfController,
                inputFormatters: [_cpfMask],
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  labelText: 'CPF',
                  hintText: '000.000.000-00',
                  prefixIcon: const Icon(Icons.badge_outlined, color: AppColors.primaryOrange),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: (_isCpfValid && !_isLoading) ? _handleLoginFlow : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _isLoading 
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                    : const Text('CONTINUAR', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
