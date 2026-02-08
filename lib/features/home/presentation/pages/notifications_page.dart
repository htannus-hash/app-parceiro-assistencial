import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificações'),
        backgroundColor: AppColors.navyBlue,
        foregroundColor: AppColors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildNotificationCard(
            title: 'Bem-vindo ao Parceiro!',
            message: 'Aproveite todos os benefícios e explore nossa rede credenciada em Itaperuna e região.',
            time: 'Agora',
            icon: Icons.celebration_outlined,
          ),
          const SizedBox(height: 12),
          _buildNotificationCard(
            title: 'Dica de Saúde',
            message: 'Manter seus exames preventivos em dia é a melhor forma de cuidar do seu futuro.',
            time: '2 horas atrás',
            icon: Icons.favorite_outline,
            isNew: false,
          ),
          const SizedBox(height: 12),
          _buildNotificationCard(
            title: 'Boleto Disponível',
            message: 'O boleto da mensalidade de Fevereiro já está disponível para pagamento no app.',
            time: 'Ontem',
            icon: Icons.receipt_long_outlined,
            isNew: false,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required String title,
    required String message,
    required String time,
    required IconData icon,
    bool isNew = true,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isNew ? AppColors.primaryOrange.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isNew ? AppColors.primaryOrange.withOpacity(0.2) : Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isNew ? AppColors.primaryOrange : Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: isNew ? Colors.white : Colors.grey, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navyBlue, fontSize: 15)),
                    Text(time, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(message, style: TextStyle(color: Colors.grey.shade700, height: 1.4, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
