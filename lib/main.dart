import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart'; 
import 'features/viewmodel/authen_viewmodel.dart';
import 'features/viewmodel/user_manager_viewmodel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/theme/theme_viewmodel.dart';
import "core/theme/app_theme.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:caonientruongson/features/users/screens/splash_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAuth.instance.signOut();
  await dotenv.load();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenViewModel()),
        ChangeNotifierProvider(create: (_) => UserManagerViewModel()),
        ChangeNotifierProvider(create: (_) => ThemeViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeVM = Provider.of<ThemeViewModel>(context);

    return MaterialApp(
      title: 'EngNews',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme.copyWith(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: AppTheme.lightTheme.colorScheme.copyWith(
          background: Colors.white,
          surface: Colors.white,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),

      darkTheme: AppTheme.darkTheme.copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData.dark().textTheme,
        ),
      ),
      themeMode: themeVM.isDarkMode ? ThemeMode.dark : ThemeMode.light,

      home: const SplashScreen(),
    );
  }
}
