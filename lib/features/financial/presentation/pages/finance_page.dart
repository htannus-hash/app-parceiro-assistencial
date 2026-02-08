import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/boleto.dart';
import '../../data/repositories/mock_financial_repository.dart';

class FinancePage extends StatefulWidget {
  const FinancePage({super.key});

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  final _repository = MockFinancialRepository();
  List<Boleto>? _boletos;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final data = await _repository.getBoletos();
    setState(() {
      _boletos = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Pagamentos'),
        backgroundColor: AppColors.navyBlue,
        foregroundColor: AppColors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryOrange))
          : _boletos == null || _boletos!.isEmpty
              ? _buildEmptyState()
              : _buildList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey.shade400),
            ),
            const SizedBox(height: 24),
            const Text(
              'Nenhum boleto encontrado',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.navyBlue),
            ),
            const SizedBox(height: 12),
            const Text(
              'Você não possui cobranças registradas no momento. Tudo certinho por aqui!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _loadData,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text('ATUALIZAR'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    final currencyFormat = NumberFormat.simpleCurrency(locale: 'pt_BR');
    final dateFormat = DateFormat('dd/MM/yyyy');

    return RefreshIndicator(
      onRefresh: _loadData,
      color: AppColors.primaryOrange,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _boletos!.length,
        itemBuilder: (context, index) {
          final boleto = _boletos![index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          boleto.description,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.navyBlue),
                        ),
                      ),
                      _buildStatusBadge(boleto.status),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Vencimento', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          Text(dateFormat.format(boleto.dueDate), style: const TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Valor', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          Text(currencyFormat.format(boleto.value),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primaryOrange)),
                        ],
                      ),
                    ],
                  ),
                  if (boleto.status != BoletoStatus.paid) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.copy, size: 18),
                            label: const Text('PIX COPIA E COLA'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.navyBlue,
                              side: const BorderSide(color: AppColors.navyBlue),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.navyBlue,
                              foregroundColor: AppColors.white,
                            ),
                            child: const Text('BOLETO PDF'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusBadge(BoletoStatus status) {
    Color color;
    String label;

    switch (status) {
      case BoletoStatus.paid:
        color = AppColors.statusGreen;
        label = 'PAGO';
        break;
      case BoletoStatus.pending:
        color = AppColors.primaryOrange;
        label = 'PENDENTE';
        break;
      case BoletoStatus.expired:
        color = Colors.red;
        label = 'VENCIDO';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}
