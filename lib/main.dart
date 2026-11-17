// Material widgets. Flutter 3.50 replaced 'package:flutter/material.dart'
// (used in the labs) with this package. The widgets are the same.
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

import 'about_page.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

// App colours, taken from the app icon (Lab 5)
class AppColors {
  static const Color colorPrimary = Color(0xFF1565C0); // blue background
  static const Color colorOnPrimary = Colors.white; // text on top of blue
  static const Color colorSecondary = Color(0xFFFFA000); // orange "kg" badge
  static const Color colorOnSecondary = Colors.black; // text on top of orange
  static const Color colorBackground = Color(0xFFEFF4FB); // light blue-grey
}

// Pages in the navigation menu (Lab 3)
enum MenuAction { home, about }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baggage Fee Estimator',
      debugShowCheckedModeBanner: false, // hide the DEBUG banner
      theme: ThemeData(
        useMaterial3: true,
        // Build the colour scheme from our blue and keep our exact colours
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.colorPrimary)
            .copyWith(
              primary: AppColors.colorPrimary,
              onPrimary: AppColors.colorOnPrimary,
              secondary: AppColors.colorSecondary,
              onSecondary: AppColors.colorOnSecondary,
            ),
        // Light background so the white cards stand out
        scaffoldBackgroundColor: AppColors.colorBackground,
        // Same rounded look for every text field
        inputDecorationTheme: const InputDecorationThemeData(
          filled: true,
          fillColor: AppColors.colorBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      home: const MainPage(),
    );
  }
}

// Main screen: the app bar with the menu, and the selected page below it
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  MenuAction currentPage = MenuAction.home; // page shown on the screen

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    // Phone back button on the About page goes back to Home
    // instead of closing the app
    return PopScope<Object?>(
      canPop: currentPage == MenuAction.home,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          setState(() => currentPage = MenuAction.home);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Baggage Fee Estimator'), // app title
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          // White status bar icons so they can be read on the blue app bar
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light, // Android
            statusBarBrightness: Brightness.dark, // iOS
          ),
          actions: [
            // Navigation menu (three-dot menu) with Home and About
            PopupMenuButton<MenuAction>(
              tooltip: 'Menu',
              onSelected: (MenuAction page) {
                setState(() => currentPage = page); // show the chosen page
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: MenuAction.home,
                  child: ListTile(
                    leading: Icon(Icons.home),
                    title: Text('Home'),
                  ),
                ),
                PopupMenuItem(
                  value: MenuAction.about,
                  child: ListTile(
                    leading: Icon(Icons.info),
                    title: Text('About'),
                  ),
                ),
              ],
            ),
          ],
        ),
        // Show the Home page or the About page
        body: currentPage == MenuAction.home
            ? const HomePage()
            : const AboutPage(),
      ),
    );
  }
}
