import 'package:equatable/equatable.dart';

enum BoletoStatus { paid, pending, expired }

class Boleto extends Equatable {
  final String id;
  final String description;
  final double value;
  final DateTime dueDate;
  final BoletoStatus status;
  final String? barCode;
  final String? pixCopyPaste;

  const Boleto({
    required this.id,
    required this.description,
    required this.value,
    required this.dueDate,
    required this.status,
    this.barCode,
    this.pixCopyPaste,
  });

  @override
  List<Object?> get props => [id, description, value, dueDate, status, barCode, pixCopyPaste];
}
