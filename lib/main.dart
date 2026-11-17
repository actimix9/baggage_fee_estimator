import 'package:material_ui/material_ui.dart';

import 'app_info.dart';
import 'pages/about_page.dart';
import 'pages/home_page.dart';

/// Entry point of the app. Starts the app by running [BaggageFeeApp].
void main() {
  runApp(const BaggageFeeApp());
}

class BaggageFeeApp extends StatelessWidget {
  const BaggageFeeApp({super.key});

  /// Builds the MaterialApp: sets the app title, the colour theme based on
  /// the brand colour, hides the debug banner and opens [MainShell] first.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppInfo.appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppInfo.brandColor),
      ),
      home: const MainShell(),
    );
  }
}

/// Holds the app bar, the navigation drawer (Home / About) and the pages.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  /// Creates the state object that remembers which page is selected.
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedIndex = 0; // 0 = Home, 1 = About

  /// Shows the page at [index] (0 = Home, 1 = About) and closes the drawer.
  void _selectPage(int index) {
    setState(() => _selectedIndex = index);
    _scaffoldKey.currentState?.closeDrawer();
  }

  // Android back button: close the drawer, or go from About back to Home.
  void _handleBack(bool didPop, Object? result) {
    if (didPop) {
      return;
    }
    final ScaffoldState? scaffold = _scaffoldKey.currentState;
    if (scaffold != null && scaffold.isDrawerOpen) {
      scaffold.closeDrawer();
    } else {
      setState(() => _selectedIndex = 0);
    }
  }

  /// Builds the main screen: the app bar with the app title, the navigation
  /// drawer with Home and About, and the selected page. PopScope sends the
  /// Android back button to [_handleBack] when not on the Home page.
  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return PopScope<Object?>(
      canPop: _selectedIndex == 0,
      onPopInvokedWithResult: _handleBack,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text(AppInfo.appTitle),
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: scheme.primary),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        AppInfo.iconAsset,
                        width: 56,
                        height: 56,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.luggage,
                          size: 56,
                          color: scheme.onPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      AppInfo.appTitle,
                      style: TextStyle(
                        color: scheme.onPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                key: const Key('navHome'),
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                selected: _selectedIndex == 0,
                onTap: () => _selectPage(0),
              ),
              ListTile(
                key: const Key('navAbout'),
                leading: const Icon(Icons.info),
                title: const Text('About'),
                selected: _selectedIndex == 1,
                onTap: () => _selectPage(1),
              ),
            ],
          ),
        ),
        // IndexedStack keeps the Home inputs when you visit About and return.
        body: IndexedStack(
          key: const Key('pageStack'),
          index: _selectedIndex,
          children: const [
            HomePage(),
            AboutPage(),
          ],
        ),
      ),
    );
  }
}
