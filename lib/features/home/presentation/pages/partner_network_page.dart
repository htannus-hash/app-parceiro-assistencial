import 'package:flutter/material.dart';
import 'package:parceiro_assistencial/core/theme/app_colors.dart';
import 'package:parceiro_assistencial/features/home/domain/entities/partner.dart';
import 'package:parceiro_assistencial/features/home/data/repositories/mock_partner_repository.dart';

class PartnerNetworkPage extends StatefulWidget {
  const PartnerNetworkPage({super.key});

  @override
  State<PartnerNetworkPage> createState() => _PartnerNetworkPageState();
}

class _PartnerNetworkPageState extends State<PartnerNetworkPage> {
  final _repository = MockPartnerRepository();
  final _searchController = TextEditingController();
  
  List<Partner> _allPartners = [];
  List<Partner> _filteredPartners = [];
  bool _isLoading = true;
  PartnerCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_filterList);
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final data = await _repository.getPartners();
    setState(() {
      _allPartners = data;
      _filteredPartners = data;
      _isLoading = false;
    });
  }

  void _filterList() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPartners = _allPartners.where((partner) {
        final matchesQuery = partner.name.toLowerCase().contains(query) || 
                            partner.city.toLowerCase().contains(query);
        final matchesCategory = _selectedCategory == null || partner.category == _selectedCategory;
        return matchesQuery && matchesCategory;
      }).toList();
    });
  }

  void _selectCategory(PartnerCategory? category) {
    setState(() {
      _selectedCategory = category;
    });
    _filterList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rede Credenciada'),
        backgroundColor: AppColors.navyBlue,
        foregroundColor: AppColors.white,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildCategoryFilters(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primaryOrange))
                : _filteredPartners.isEmpty
                    ? _buildEmptyState()
                    : _buildPartnerList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.navyBlue,
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Buscar por nome ou cidade...',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
          prefixIcon: const Icon(Icons.search, color: Colors.white),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _buildFilterChip('Todos', null),
          const SizedBox(width: 8),
          _buildFilterChip('Clínicas', PartnerCategory.clinic),
          const SizedBox(width: 8),
          _buildFilterChip('Laboratórios', PartnerCategory.laboratory),
          const SizedBox(width: 8),
          _buildFilterChip('Farmácias', PartnerCategory.pharmacy),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, PartnerCategory? category) {
    final isSelected = _selectedCategory == category;
    return GestureDetector(
      onTap: () => _selectCategory(category),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryOrange : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryOrange : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.navyBlue,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildPartnerList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredPartners.length,
      itemBuilder: (context, index) {
        final partner = _filteredPartners[index];
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getCategoryIcon(partner.category),
                    color: AppColors.primaryOrange,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        partner.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.navyBlue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 14, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text(
                            '${partner.city} - ${partner.address}',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.phone_outlined, color: AppColors.primaryOrange),
                      onPressed: () {},
                    ),
                    const Text('Ligar', style: TextStyle(fontSize: 10, color: AppColors.primaryOrange)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getCategoryIcon(PartnerCategory category) {
    switch (category) {
      case PartnerCategory.clinic: return Icons.local_hospital_outlined;
      case PartnerCategory.laboratory: return Icons.biotech_outlined;
      case PartnerCategory.pharmacy: return Icons.local_pharmacy_outlined;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text(
              'Oops! Nenhum parceiro encontrado',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.navyBlue),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tente ajustar sua busca ou filtro para encontrar o que procura.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
