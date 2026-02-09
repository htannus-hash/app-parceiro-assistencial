import 'package:parceiro_assistencial/features/home/domain/entities/partner.dart';

class MockPartnerRepository {
  final List<Partner> _allPartners = [
    const Partner(
      id: '1',
      name: 'Hospital São José do Avaí',
      category: PartnerCategory.clinic,
      city: 'Itaperuna',
      address: 'Rua Cel. Ramos, 159 - Centro',
      phone: '2238249200',
    ),
    const Partner(
      id: '2',
      name: 'Laboratório Vitalle',
      category: PartnerCategory.laboratory,
      city: 'Itaperuna',
      address: 'Av. Cardoso Moreira, 450',
      phone: '2238221010',
    ),
    const Partner(
      id: '3',
      name: 'Farmácia do Povo',
      category: PartnerCategory.pharmacy,
      city: 'Bom Jesus do Itabapoana',
      address: 'Praça Governador Portela, 12',
      phone: '2238311515',
    ),
    const Partner(
      id: '4',
      name: 'Clínica Santa Lúcia',
      category: PartnerCategory.clinic,
      city: 'Santo Antônio de Pádua',
      address: 'Rua Dr. Ferreira da Luz, 88',
      phone: '2238510022',
    ),
    const Partner(
      id: '5',
      name: 'Laboratório Prev-Exame',
      category: PartnerCategory.laboratory,
      city: 'Bom Jesus do Itabapoana',
      address: 'Rua Expedicionários, 45',
      phone: '2238312020',
    ),
    const Partner(
      id: '6',
      name: 'Drogaria Ultra Popular',
      category: PartnerCategory.pharmacy,
      city: 'Itaperuna',
      address: 'Rua Rui Barbosa, 102',
      phone: '2238241515',
    ),
    const Partner(
      id: '7',
      name: 'Centro Médico Pádua',
      category: PartnerCategory.clinic,
      city: 'Santo Antônio de Pádua',
      address: 'Av. João Jasbik, 200',
      phone: '2238515050',
    ),
    const Partner(
      id: '8',
      name: 'Lab. Itaperuna de Análises',
      category: PartnerCategory.laboratory,
      city: 'Itaperuna',
      address: 'Rua Buarque de Nazereth, 33',
      phone: '2238220011',
    ),
  ];

  Future<List<Partner>> getPartners() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _allPartners;
  }
}
