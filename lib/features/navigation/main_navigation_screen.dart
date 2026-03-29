import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../child/child_dashboard.dart';
import '../parent/parent_dashboard.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  static const _tabs = [
    _NavTab(icon: Icons.home_rounded, activeColor: Color(0xFF4ECDC4)),
    _NavTab(icon: Icons.grid_view_rounded, activeColor: Color(0xFFFF6B6B)),
    _NavTab(icon: Icons.person_rounded, activeColor: Color(0xFF6B7FFF)),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FF),
        extendBody: true,
        body: SafeArea(
          child: IndexedStack(
            index: _selectedIndex == 2 ? 1 : 0,
            children: const [ChildDashboard(), ParentDashboard()],
          ),
        ),
        bottomNavigationBar: _FloatingNav(
          selectedIndex: _selectedIndex,
          tabs: _tabs,
          onTap: (i) => setState(() => _selectedIndex = i),
        ),
      ),
    );
  }
}

class _NavTab {
  const _NavTab({required this.icon, required this.activeColor});
  final IconData icon;
  final Color activeColor;
}

class _FloatingNav extends StatelessWidget {
  const _FloatingNav({
    required this.selectedIndex,
    required this.tabs,
    required this.onTap,
  });

  final int selectedIndex;
  final List<_NavTab> tabs;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(56, 0, 56, 20),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: const Color(0xFF4ECDC4).withValues(alpha: 0.12),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: List.generate(tabs.length, (i) {
                final selected = i == selectedIndex;
                final tab = tabs[i];
                return Expanded(
                  child: GestureDetector(
                    onTap: () => onTap(i),
                    behavior: HitTestBehavior.opaque,
                    child: Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: selected ? tab.activeColor : Colors.transparent,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: AnimatedScale(
                          scale: selected ? 1.1 : 1.0,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOut,
                          child: Icon(
                            tab.icon,
                            size: 24,
                            color: selected ? Colors.white : Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
