import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../../utils/extensions.dart';
import '../auth/login_screen.dart';

/// Home screen - main dashboard
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FarmZyy'),
        centerTitle: false,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: _showProfileMenu,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Welcome banner
            _buildWelcomeBanner(context),
            const SizedBox(height: AppConstants.paddingLarge),

            // Quick stats
            _buildQuickStats(context),
            const SizedBox(height: AppConstants.paddingLarge),

            // Feature cards
            _buildFeatureCards(context),
            const SizedBox(height: AppConstants.paddingLarge),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  /// Build welcome banner
  Widget _buildWelcomeBanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppConstants.paddingMedium),
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppConstants.primaryColor,
            AppConstants.primaryColor.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Good Morning!',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Let\'s grow together',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
          ),
        ],
      ),
    );
  }

  /// Build quick stats section
  Widget _buildQuickStats(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
      child: Row(
        children: [
          _buildStatCard(
            context,
            title: 'My Crops',
            value: '0',
            icon: Icons.grass,
          ),
          const SizedBox(width: AppConstants.paddingMedium),
          _buildStatCard(
            context,
            title: 'Predictions',
            value: '0',
            icon: Icons.insights,
          ),
          const SizedBox(width: AppConstants.paddingMedium),
          _buildStatCard(
            context,
            title: 'Alerts',
            value: '0',
            icon: Icons.notifications,
          ),
        ],
      ),
    );
  }

  /// Build individual stat card
  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: AppConstants.primaryColor, size: 28),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build feature cards section
  Widget _buildFeatureCards(BuildContext context) {
    final features = [
      {
        'title': 'AI Chatbot',
        'description': 'Get instant farming advice',
        'icon': Icons.chat,
        'route': 'chatbot'
      },
      {
        'title': 'Crop Recommendation',
        'description': 'Find best crops for your land',
        'icon': Icons.eco,
        'route': 'crop'
      },
      {
        'title': 'Predictions',
        'description': 'Yield & pest risk analysis',
        'icon': Icons.trending_up,
        'route': 'predictions'
      },
      {
        'title': 'Weather',
        'description': 'Real-time weather updates',
        'icon': Icons.cloud,
        'route': 'weather'
      },
      {
        'title': 'Market Prices',
        'description': 'Check crop prices',
        'icon': Icons.store,
        'route': 'market'
      },
      {
        'title': 'Expert Support',
        'description': 'Connect with experts',
        'icon': Icons.support_agent,
        'route': 'support'
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: AppConstants.paddingMedium,
          crossAxisSpacing: AppConstants.paddingMedium,
          childAspectRatio: 1.2,
        ),
        itemCount: features.length,
        itemBuilder: (context, index) {
          final feature = features[index];
          return Card(
            child: InkWell(
              onTap: () {
                // TODO: Navigate to feature screen
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${feature['title']} - Coming soon')),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      feature['icon'] as IconData,
                      color: AppConstants.primaryColor,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      feature['title'] as String,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      feature['description'] as String,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Build bottom navigation bar
  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) => setState(() => _selectedIndex = index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chatbot',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.eco),
          label: 'Crops',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }

  /// Show profile menu
  void _showProfileMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile - Coming soon')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings - Coming soon')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: AppConstants.errorColor),
              title: const Text('Logout', style: TextStyle(color: AppConstants.errorColor)),
              onTap: () async {
                Navigator.pop(context);
                final authProvider = context.read<AuthProvider>();
                await authProvider.logout();
                if (mounted) {
                  context.navigateAndReplace(const LoginScreen());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
