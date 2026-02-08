import 'package:equatable/equatable.dart';

enum PartnerCategory { clinic, laboratory, pharmacy }

class Partner extends Equatable {
  final String id;
  final String name;
  final PartnerCategory category;
  final String city;
  final String address;
  final String phone;

  const Partner({
    required this.id,
    required this.name,
    required this.category,
    required this.city,
    required this.address,
    required this.phone,
  });

  @override
  List<Object?> get props => [id, name, category, city, address, phone];
}
