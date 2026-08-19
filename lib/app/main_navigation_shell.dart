import 'package:flutter/material.dart';

import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/dashboard/presentation/dashboard_controller.dart';
import '../features/sales/presentation/pos_screen.dart';
import '../features/sales/presentation/pos_controller.dart';
import '../features/production/presentation/production_screen.dart';
import '../features/inventory/presentation/inventory_screen.dart';
import '../features/inventory/domain/cost_layer_repository.dart';
import '../features/customers/presentation/customer_screen.dart';
import '../features/customers/domain/customer_repository.dart';
import '../core/theme/theme_controller.dart';
import '../core/theme/app_theme.dart';

class MainNavigationShell extends StatefulWidget {
  final DashboardController dashboardController;
  final POSController posController;
  final CostLayerRepository costLayerRepository;
  final CustomerRepository customerRepository;
  final ThemeController themeController;

  const MainNavigationShell({
    super.key,
    required this.dashboardController,
    required this.posController,
    required this.costLayerRepository,
    required this.customerRepository,
    required this.themeController,
  });

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    // 3-Tier Breakpoints
    final isDesktop = width >= 1000;
    final isTablet = width >= 600 && width < 1000;
    // // final isMobile = width < 600;

    final pages = [
      DashboardScreen(controller: widget.dashboardController),
      POSScreen(controller: widget.posController),
      ProductionAndPortioningScreen(costLayerRepository: widget.costLayerRepository),
      InventoryScreen(costLayerRepository: widget.costLayerRepository),
      CustomerScreen(customerRepository: widget.customerRepository),
    ];

    final mobileAppBar = AppBar(
      title: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.orange.shade100,
            child: const Icon(Icons.local_dining, color: Colors.orange),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('SMART WARUNG', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text('Bumbu & Kasir', style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(widget.themeController.isDarkMode ? Icons.light_mode : Icons.dark_mode),
          onPressed: () => widget.themeController.toggleTheme(),
        ),
      ],
    );

    // 1. TAMPILAN DESKTOP/LAPTOP (Full Sidebar Kiri)
    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            Container(
              width: 250,
              color: AppTheme.sidebarDark,
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.orange.shade100,
                      child: const Icon(Icons.local_dining, color: Colors.orange),
                    ),
                    title: const Text('SMART WARUNG', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: const Text('Bumbu & Kasir', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView(
                      children: [
                        _buildSidebarItem(icon: Icons.dashboard, title: 'Dashboard', index: 0),
                        _buildSidebarItem(icon: Icons.point_of_sale, title: 'Penjualan / POS', index: 1),
                        _buildSidebarItem(icon: Icons.blender, title: 'Produksi Bumbu', index: 2),
                        _buildSidebarItem(icon: Icons.inventory_2, title: 'Inventory / Stok', index: 3),
                        _buildSidebarItem(icon: Icons.people, title: 'Pelanggan & CRM', index: 4),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.white24),
                  ListTile(
                    leading: Icon(widget.themeController.isDarkMode ? Icons.light_mode : Icons.dark_mode, color: Colors.white70),
                    title: const Text('Ganti Tema', style: TextStyle(color: Colors.white70)),
                    onTap: () => widget.themeController.toggleTheme(),
                  ),
                  const ListTile(
                    leading: CircleAvatar(child: Icon(Icons.person)),
                    title: Text('Pemilik Warung', style: TextStyle(color: Colors.white)),
                    subtitle: Text('Owner', style: TextStyle(color: Colors.white70)),
                    trailing: Icon(Icons.expand_more, color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            Expanded(
              child: Scaffold(
                appBar: AppBar(title: Text(_getPageTitle(_selectedIndex), style: const TextStyle(fontWeight: FontWeight.bold))),
                body: pages[_selectedIndex],
              ),
            ),
          ],
        ),
      );
    }

    // 2. TAMPILAN TABLET (Navigation Rail Tipis)
    if (isTablet) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              backgroundColor: AppTheme.sidebarDark,
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) => setState(() => _selectedIndex = index),
              selectedIconTheme: const IconThemeData(color: Colors.white),
              unselectedIconTheme: const IconThemeData(color: Colors.white70),
              useIndicator: true,
              indicatorColor: AppTheme.primaryBlue,
              destinations: const [
                NavigationRailDestination(icon: Icon(Icons.dashboard), label: Text('Dashboard')),
                NavigationRailDestination(icon: Icon(Icons.point_of_sale), label: Text('POS')),
                NavigationRailDestination(icon: Icon(Icons.blender), label: Text('Produksi')),
                NavigationRailDestination(icon: Icon(Icons.inventory_2), label: Text('Stok')),
                NavigationRailDestination(icon: Icon(Icons.people), label: Text('CRM')),
              ],
              trailing: Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: IconButton(
                      icon: Icon(widget.themeController.isDarkMode ? Icons.light_mode : Icons.dark_mode, color: Colors.white70),
                      onPressed: () => widget.themeController.toggleTheme(),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Scaffold(
                appBar: AppBar(title: Text(_getPageTitle(_selectedIndex), style: const TextStyle(fontWeight: FontWeight.bold))),
                body: pages[_selectedIndex],
              ),
            ),
          ],
        ),
      );
    }

    // 3. TAMPILAN MOBILE (Bottom Navigation Bar)
    return Scaffold(
      appBar: mobileAppBar,
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryBlue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.point_of_sale), label: 'Penjualan'),
          BottomNavigationBarItem(icon: Icon(Icons.blender), label: 'Produksi'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'Inventory'),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'Lainnya'),
        ],
      ),
    );
  }

  String _getPageTitle(int index) {
    switch (index) {
      case 0: return 'Selamat datang kembali 👋';
      case 1: return 'Kasir POS';
      case 2: return 'Produksi Bumbu';
      case 3: return 'Manajemen Stok (FIFO)';
      case 4: return 'Pelanggan & CRM';
      default: return '';
    }
  }

  Widget _buildSidebarItem({required IconData icon, required String title, required int index}) {
    final isSelected = _selectedIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.primaryBlue : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: isSelected ? Colors.white : Colors.white70),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: () => setState(() => _selectedIndex = index),
      ),
    );
  }
}
