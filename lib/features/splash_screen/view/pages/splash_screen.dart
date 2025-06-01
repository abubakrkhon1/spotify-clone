import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify_clone/core/providers/current_user_notifier.dart';
import 'package:spotify_clone/core/widgets/loader.dart';
import 'package:spotify_clone/features/auth/view/pages/login_page.dart';
import 'package:spotify_clone/features/auth/viewmodel/auth_viewmodel.dart';
// import 'package:spotify_clone/features/home/view/home_page.dart';
import 'package:spotify_clone/features/home/view/upload_song_page.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authViewModelProvider, (previous, next) {
      next.when(
        data: (user) {
          if (user != null) {
            ref.read(currentUserNotifierProvider.notifier).addUser(user);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const UploadSongPage()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
          }
        },
        error: (err, _) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
          );
        },
        loading: () {},
      );
    });

    Future.microtask(() {
      ref.read(authViewModelProvider.notifier).checkSession();
    });

    return const Scaffold(body: Loader());
  }
}
