import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import 'weather_card.dart';
import 'market_card.dart';
import 'risk_alert_card.dart';
import 'dashboard_provider.dart';
import '../authentication/auth_provider.dart';
import '../chatbot/chatbot_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  // Refresh dashboard data
                  ref.refresh(weatherProvider);
                  ref.refresh(riskAlertsProvider);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Dashboard refreshed'),
                      duration: Duration(milliseconds: 1500),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh all providers on pull-to-refresh
          ref.refresh(weatherProvider);
          ref.refresh(riskAlertsProvider);
          // Wait for at least one to complete
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Section
                _buildWelcomeSection(context),
                const SizedBox(height: AppTheme.paddingLarge),

                // Quick Stats Row (optional, for future expansion)
                _buildQuickStatsSection(context),
                const SizedBox(height: AppTheme.paddingLarge),

                // Weather Card
                _buildCardSection(context, 'Current Weather', [
                  const WeatherCard(),
                ]),
                const SizedBox(height: AppTheme.paddingMedium),

                // Market Prices Card
                _buildCardSection(context, 'Market Prices', [
                  const MarketCard(),
                ]),
                const SizedBox(height: AppTheme.paddingMedium),

                // Risk Alerts Card
                _buildCardSection(context, 'Risk Alerts', [
                  const RiskAlertCard(),
                ]),
                const SizedBox(height: AppTheme.paddingLarge),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final auth = ref.read(authProvider);
          final userId = auth.user_id ?? '';
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ChatbotScreen(userId: userId, contextData: null),
            ),
          );
        },
        child: const Icon(Icons.chat_bubble_outline),
        tooltip: 'Ask Farmzyy Assistant',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  /// Build welcome section with greeting
  Widget _buildWelcomeSection(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good Morning'
        : hour < 18
            ? 'Good Afternoon'
            : 'Good Evening';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          'Stay Updated With Your Farm',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }

  /// Build quick stats section (placeholder for future use)
  Widget _buildQuickStatsSection(BuildContext context) {
    return Row(
      children: [
        _buildStatCard(context, 'Crops', '3', Icons.agriculture),
        const SizedBox(width: AppTheme.paddingMedium),
        _buildStatCard(context, 'Land Area', '5 ha', Icons.landscape),
        const SizedBox(width: AppTheme.paddingMedium),
        _buildStatCard(
          context,
          'Yield Est.',
          '15 T',
          Icons.trending_up_outlined,
        ),
      ],
    );
  }

  /// Build individual stat card
  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.paddingSmall),
          child: Column(
            children: [
              Icon(
                icon,
                color: AppTheme.primaryColor,
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
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

  /// Build card section with label and cards
  Widget _buildCardSection(
    BuildContext context,
    String title,
    List<Widget> cards,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        ...cards,
      ],
    );
  }
}
