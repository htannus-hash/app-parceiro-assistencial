import '../domain/entities/boleto.dart';

class MockFinancialRepository {
  Future<List<Boleto>> getBoletos() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    return [
      Boleto(
        id: '1',
        description: 'Mensalidade - Fevereiro 2026',
        value: 149.90,
        dueDate: DateTime(2026, 2, 10),
        status: BoletoStatus.pending,
        barCode: '00190.12345 67890.123456 78901.234567 1 96230000014990',
        pixCopyPaste: '00020126580014br.gov.bcb.pix0136example-key-asaas-1234567890',
      ),
      Boleto(
        id: '2',
        description: 'Mensalidade - Janeiro 2026',
        value: 149.90,
        dueDate: DateTime(2026, 1, 10),
        status: BoletoStatus.paid,
      ),
      Boleto(
        id: '3',
        description: 'Taxa Administrativa (Vencida)',
        value: 45.00,
        dueDate: DateTime(2025, 12, 15),
        status: BoletoStatus.expired,
        barCode: '00190.11111 22222.333333 44444.555555 1 96230000004500',
      ),
    ];
  }
}
