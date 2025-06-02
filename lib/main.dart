import 'package:flutter/material.dart';
import 'package:spotify_clone/core/theme/theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spotify_clone/features/splash_screen/view/pages/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    authOptions: const FlutterAuthClientOptions(autoRefreshToken: true),
  );

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Spotify Clone',
      theme: AppTheme.darkThemeMode,
      home: const SplashScreen(),
    );
  }
}
