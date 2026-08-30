import 'package:flutter/material.dart';

import '../core/security/auth_service.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/theme_controller.dart';
import '../features/customers/domain/customer_repository.dart';
import '../features/customers/presentation/customer_screen.dart';
import '../features/dashboard/presentation/dashboard_controller.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/inventory/domain/cost_layer_repository.dart';
import '../features/inventory/presentation/inventory_screen.dart';
import '../features/production/application/execute_production_use_case.dart';
import '../features/production/presentation/production_screen.dart';
import '../features/products/application/product_use_cases.dart';
import '../features/products/domain/product_repository.dart';
import '../features/products/presentation/product_screen.dart';
import '../features/recipes/application/recipe_use_cases.dart';
import '../features/recipes/domain/recipe_repository.dart';
import '../features/recipes/presentation/recipe_screen.dart';
import '../features/sync/application/auto_sync_worker.dart';
import '../features/sync/application/sync_enqueue_service.dart';
import '../features/sync/domain/auth_repository.dart';
import '../features/sync/infrastructure/remote_auth_repository.dart';
import '../features/sync/presentation/sync_login_controller.dart';
import '../features/sync/presentation/sync_login_screen.dart';
import '../features/sync/presentation/sync_status_indicator.dart';
import '../features/purchasing/domain/purchase_repository.dart';
import '../features/purchasing/presentation/purchasing_screen.dart';
import '../features/receiving/application/receive_goods_use_case.dart';
import '../features/receiving/domain/receiving_repository.dart';
import '../features/receiving/presentation/receiving_screen.dart';
import '../features/sales/presentation/pos_controller.dart';
import '../features/sales/presentation/pos_screen.dart';

/// Representasi satu item navigasi.
class _NavItem {
  final IconData icon;
  final String title;
  final String label;
  final Widget page;

  const _NavItem({
    required this.icon,
    required this.title,
    required this.label,
    required this.page,
  });
}

class MainNavigationShell extends StatefulWidget {
  final DashboardController dashboardController;
  final POSController posController;
  final CostLayerRepository costLayerRepository;
  final CustomerRepository customerRepository;
  final ThemeController themeController;
  final AuthService authService;
  final PurchaseRepository purchaseRepository;
  final ProductRepository productRepository;
  final ProductUseCases productUseCases;
  final RecipeUseCases recipeUseCases;
  final ReceivingRepository receivingRepository;
  final ReceiveGoodsUseCase receiveGoodsUseCase;
  final ExecuteProductionUseCase executeProductionUseCase;
  final RecipeRepository recipeRepository;
  final SyncEnqueueService syncEnqueueService;
  final AuthRepository authRepository;
  final RemoteAuthRepository remoteAuthRepository;
  final AutoSyncWorker autoSyncWorker;

  const MainNavigationShell({
    super.key,
    required this.dashboardController,
    required this.posController,
    required this.costLayerRepository,
    required this.customerRepository,
    required this.themeController,
    required this.authService,
    required this.purchaseRepository,
    required this.productRepository,
    required this.productUseCases,
    required this.recipeUseCases,
    required this.receivingRepository,
    required this.receiveGoodsUseCase,
    required this.executeProductionUseCase,
    required this.recipeRepository,
    required this.syncEnqueueService,
    required this.authRepository,
    required this.remoteAuthRepository,
    required this.autoSyncWorker,
  });

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _selectedIndex = 0;

  /// Daftar tab yang diizinkan berdasarkan peran pengguna.
  List<_NavItem> get _navItems {
    final isOwner = widget.authService.isOwner;

    return [
      _NavItem(
        icon: Icons.dashboard,
        title: 'Selamat datang kembali 👋',
        label: 'Beranda',
        page: DashboardScreen(controller: widget.dashboardController),
      ),
      _NavItem(
        icon: Icons.point_of_sale,
        title: 'Kasir POS',
        label: 'Penjualan',
        page: POSScreen(controller: widget.posController),
      ),
      if (isOwner)
        _NavItem(
          icon: Icons.blender,
          title: 'Produksi Bumbu',
          label: 'Produksi',
          page: ProductionAndPortioningScreen(
            costLayerRepository: widget.costLayerRepository,
            executeProductionUseCase: widget.executeProductionUseCase,
            recipeRepository: widget.recipeRepository,
            productRepository: widget.productRepository,
          ),
        ),
      _NavItem(
        icon: Icons.inventory_2,
        title: 'Manajemen Stok (FIFO)',
        label: 'Inventory',
        page: InventoryScreen(
            costLayerRepository: widget.costLayerRepository,
            productRepository: widget.productRepository),
      ),
      _NavItem(
        icon: Icons.people,
        title: 'Pelanggan & CRM',
        label: 'Pelanggan',
        page: CustomerScreen(
            customerRepository: widget.customerRepository,
            syncEnqueueService: widget.syncEnqueueService),
      ),
      // Tab eksklusif Owner
      if (isOwner)
        _NavItem(
          icon: Icons.shopping_bag,
          title: 'Pembelian (PO)',
          label: 'Pembelian',
          page: PurchasingScreen(
            purchaseRepository: widget.purchaseRepository,
            productRepository: widget.productRepository,
            syncEnqueueService: widget.syncEnqueueService,
          ),
        ),
      if (isOwner)
        _NavItem(
          icon: Icons.move_to_inbox,
          title: 'Penerimaan Barang',
          label: 'Penerimaan',
          page: ReceivingScreen(
            receivingRepository: widget.receivingRepository,
            purchaseRepository: widget.purchaseRepository,
            productRepository: widget.productRepository,
            receiveGoodsUseCase: widget.receiveGoodsUseCase,
          ),
        ),
      if (isOwner)
        _NavItem(
          icon: Icons.category,
          title: 'Kelola Produk',
          label: 'Produk',
          page: ProductScreen(productUseCases: widget.productUseCases),
        ),
      if (isOwner)
        _NavItem(
          icon: Icons.book,
          title: 'Resep Produksi',
          label: 'Resep',
          page: RecipeScreen(
            recipeUseCases: widget.recipeUseCases,
            productRepository: widget.productRepository,
          ),
        ),
    ];
  }

  /// Aksi AppBar: indikator status sinkronisasi + sync manual + login.
  List<Widget> get _syncAppBarActions => [
        SyncStatusIndicator(worker: widget.autoSyncWorker),
        SyncNowButton(worker: widget.autoSyncWorker),
        IconButton(
          tooltip: 'Akun Sinkronisasi',
          icon: const Icon(Icons.login),
          onPressed: _openSyncLogin,
        ),
      ];

  void _openSyncLogin() {
    final controller = SyncLoginController(
      remoteAuthRepository: widget.remoteAuthRepository,
      localAuthRepository: widget.authRepository,
    );
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SyncLoginScreen(controller: controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 1000;
    final isTablet = width >= 600 && width < 1000;

    final items = _navItems;
    final safeIndex = _selectedIndex.clamp(0, items.length - 1);
    if (safeIndex != _selectedIndex) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => setState(() => _selectedIndex = safeIndex));
    }

    final currentPage = items[safeIndex].page;
    final currentTitle = items[safeIndex].title;
    final roleLabel = widget.authService.isOwner ? 'Owner' : 'Kasir';

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
              Text('SMART WARUNG',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              Text('Bumbu & Kasir',
                  style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.normal)),
            ],
          ),
        ],
      ),
      actions: [
        ..._syncAppBarActions,
        IconButton(
          icon: Icon(widget.themeController.isDarkMode
              ? Icons.light_mode
              : Icons.dark_mode),
          onPressed: () => widget.themeController.toggleTheme(),
        ),
      ],
    );

    // 1. DESKTOP: Full Sidebar
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
                      child: const Icon(Icons.local_dining,
                          color: Colors.orange),
                    ),
                    title: const Text('SMART WARUNG',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    subtitle: const Text('Bumbu & Kasir',
                        style: TextStyle(
                            color: Colors.white70, fontSize: 12)),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView(
                      children: [
                        for (var i = 0; i < items.length; i++)
                          _buildSidebarItem(
                              icon: items[i].icon,
                              title: items[i].label,
                              index: i),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.white24),
                  ListTile(
                    leading: Icon(
                        widget.themeController.isDarkMode
                            ? Icons.light_mode
                            : Icons.dark_mode,
                        color: Colors.white70),
                    title: const Text('Ganti Tema',
                        style: TextStyle(color: Colors.white70)),
                    onTap: () => widget.themeController.toggleTheme(),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: widget.authService.isOwner
                          ? Colors.orange.shade200
                          : Colors.blue.shade200,
                      child: Icon(
                        widget.authService.isOwner
                            ? Icons.admin_panel_settings
                            : Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    title: const Text('Pengguna Aktif',
                        style: TextStyle(color: Colors.white)),
                    subtitle: Text(roleLabel,
                        style: const TextStyle(color: Colors.white70)),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            Expanded(
              child: Scaffold(
                appBar: AppBar(
                    title: Text(currentTitle,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold)),
                    actions: _syncAppBarActions),
                body: currentPage,
              ),
            ),
          ],
        ),
      );
    }

    // 2. TABLET: Navigation Rail
    if (isTablet) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              backgroundColor: AppTheme.sidebarDark,
              selectedIndex: safeIndex,
              onDestinationSelected: (int index) =>
                  setState(() => _selectedIndex = index),
              selectedIconTheme:
                  const IconThemeData(color: Colors.white),
              unselectedIconTheme:
                  const IconThemeData(color: Colors.white70),
              useIndicator: true,
              indicatorColor: AppTheme.primaryBlue,
              destinations: [
                for (final item in items)
                  NavigationRailDestination(
                    icon: Icon(item.icon),
                    label: Text(item.label),
                  ),
              ],
              trailing: Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: IconButton(
                      icon: Icon(
                          widget.themeController.isDarkMode
                              ? Icons.light_mode
                              : Icons.dark_mode,
                          color: Colors.white70),
                      onPressed: () =>
                          widget.themeController.toggleTheme(),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Scaffold(
                appBar: AppBar(
                    title: Text(currentTitle,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold)),
                    actions: _syncAppBarActions),
                body: currentPage,
              ),
            ),
          ],
        ),
      );
    }

    // 3. MOBILE: Bottom Navigation Bar
    return Scaffold(
      appBar: mobileAppBar,
      body: currentPage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: safeIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryBlue,
        unselectedItemColor: Colors.grey,
        items: [
          for (final item in items)
            BottomNavigationBarItem(
              icon: Icon(item.icon),
              label: item.label,
            ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(
      {required IconData icon,
      required String title,
      required int index}) {
    final isSelected = _selectedIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.primaryBlue : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading:
            Icon(icon, color: isSelected ? Colors.white : Colors.white70),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight:
                isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: () => setState(() => _selectedIndex = index),
      ),
    );
  }
}
