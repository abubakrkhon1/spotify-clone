import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify_clone/core/providers/current_user_notifier.dart';
import 'package:spotify_clone/core/theme/app_pallette.dart';
import 'package:spotify_clone/core/widgets/loader.dart';
import 'package:spotify_clone/features/auth/view/pages/login_page.dart';
import 'package:spotify_clone/features/home/view/pages/library_page.dart';
import 'package:spotify_clone/features/home/view/pages/songs_page.dart';
import 'package:spotify_clone/features/home/view/widgets/music_slab.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int selectedIndex = 0;

  final pages = const [SongsPage(), LibraryPage()];

  @override
  Widget build(BuildContext context) {
    final user = ref.read(currentUserNotifierProvider);

    if (user == null) {
      Future.microtask(() {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => LoginPage()),
          (_) => false,
        );
      });
      return Loader();
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(child: pages[selectedIndex]),
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0), // 👈 Adds spacing everywhere
            child: MusicSlab(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              selectedIndex == 0
                  ? 'assets/images/home_filled.png'
                  : 'assets/images/home_unfilled.png',
              color:
                  selectedIndex == 0
                      ? Pallete.whiteColor
                      : Pallete.inactiveBottomBarItemColor,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/library.png',
              color:
                  selectedIndex == 1
                      ? Pallete.whiteColor
                      : Pallete.inactiveBottomBarItemColor,
            ),
            label: 'Library',
          ),
        ],
      ),
    );
  }
}
