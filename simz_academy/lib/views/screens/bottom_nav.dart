import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:simz_academy/views/screens/course_screen.dart';
import 'package:simz_academy/views/screens/fee_screen.dart';
import 'package:simz_academy/views/screens/home_screen.dart';
import 'package:simz_academy/views/screens/music_library.dart';
import 'package:simz_academy/views/screens/profile_screen.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  DateTime? _lastBackPressedTime;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) return;

        final now = DateTime.now();
        final shouldExit = _lastBackPressedTime != null &&
            now.difference(_lastBackPressedTime!) < const Duration(seconds: 2);

        if (shouldExit) {
          SystemNavigator.pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Press back again to exit'),
              duration: Duration(seconds: 2),
            ),
          );
          _lastBackPressedTime = now;
        }
      },
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) => setState(() => _selectedIndex = index),
          children: const <Widget>[
            HomeScreen(),
            MusicLibraryScreen(),
            CourseScreen(),
            FeeScreen(),
            ProfileScreen(key: null),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: CurvedNavigationBar(
              height: isLargeScreen ? 70 : 60,
              animationDuration: const Duration(milliseconds: 450),
              index: _selectedIndex,
              color: const Color.fromRGBO(246, 235, 252, 1),
              backgroundColor: const Color.fromRGBO(236, 215, 247, 1),
              onTap: (index) {
                setState(() => _selectedIndex = index);
                _pageController.jumpToPage(index);
              },
              items: [
                _buildNavItem(context, Iconsax.home_2, 0, 'Home'),
                _buildNavItem(context, Iconsax.music_library_2, 1, 'Library'),
                _buildNavItem(context, Iconsax.book, 2, 'Courses'),
                _buildNavItem(context, Iconsax.empty_wallet, 3, 'Fee'),
                _buildNavItem(context, Iconsax.user, 4, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, int index, String label) {
    final isSelected = _selectedIndex == index;
    final isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color.fromRGBO(91, 40, 103, 1)
                : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isSelected ? Colors.white : const Color.fromRGBO(91, 40, 103, 1),
            size: isLargeScreen ? 28 : 24,
          ),
        ),
        if (isLargeScreen)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected
                    ? const Color.fromRGBO(91, 40, 103, 1)
                    : const Color.fromRGBO(91, 40, 103, 0.7),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
      ],
    );
  }
}