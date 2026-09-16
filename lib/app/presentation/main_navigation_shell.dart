import 'package:flutter/material.dart';
import 'package:stravo/app/theme/stravo_colors.dart';
import 'package:stravo/features/activity_history/presentation/screens/activity_list_screen.dart';
import 'package:stravo/features/dashboard/presentation/screens/analytics_dashboard_screen.dart';
import 'package:stravo/features/map_3d/presentation/screens/explore_map_screen.dart';
import 'package:stravo/features/profile/presentation/screens/profile_screen.dart';
import 'package:stravo/features/recording/presentation/screens/recording_screen.dart';

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    ActivityListScreen(),
    ExploreMapScreen(),
    AnalyticsDashboardScreen(),
    ProfileScreen(),
  ];

  void _onRecordPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const RecordingScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StravoColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 62,
        width: 62,
        margin: const EdgeInsets.only(top: 14),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: StravoColors.primaryGradient,
          boxShadow: [
            BoxShadow(
              color: StravoColors.orangePrimary.withValues(alpha: 0.5),
              blurRadius: 18,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _onRecordPressed,
            customBorder: const CircleBorder(),
            child: const Icon(
              Icons.fiber_manual_record,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: StravoColors.surface,
          border: Border(
            top: BorderSide(
              color: StravoColors.glassBorder,
              width: 1.0,
            ),
          ),
        ),
        child: BottomAppBar(
          color: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          shape: const CircularNotchedRectangle(),
          notchMargin: 8.0,
          height: 66,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(index: 0, icon: Icons.pedal_bike_outlined, activeIcon: Icons.pedal_bike, label: 'Aktivitas'),
              _buildNavItem(index: 1, icon: Icons.explore_outlined, activeIcon: Icons.explore, label: 'Explore'),
              const SizedBox(width: 48), // Space for center FAB
              _buildNavItem(index: 2, icon: Icons.bar_chart_outlined, activeIcon: Icons.bar_chart, label: 'Analitik'),
              _buildNavItem(index: 3, icon: Icons.person_outline, activeIcon: Icons.person, label: 'Profil'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? StravoColors.orangePrimary : StravoColors.textTertiary;

    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: color,
              size: 22,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
