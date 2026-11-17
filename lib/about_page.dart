import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const String githubUrl =
      'https://github.com/actimix9/baggage_fee_estimator';

  // Open the GitHub link in the phone's browser
  Future<void> openGitHub(BuildContext context) async {
    bool opened = false;
    try {
      opened = await launchUrl(
        Uri.parse(githubUrl),
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      debugPrint('Could not open link: $e'); // shows in the Debug Console
    }

    // Error message if the link could not be opened
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the GitHub link.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header: blue card with the app icon and name
            Card(
              color: colors.primary,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Application icon with a white border
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset('assets/icon/icon.png', width: 90),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Baggage Fee Estimator',
                      style: TextStyle(
                        color: colors.onPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Estimates the excess baggage fee for air travel.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: colors.onPrimary),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Author information (Lab 7 card)
            Card(
              color: Colors.white,
              elevation: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                    child: Text(
                      'Author Information',
                      style: TextStyle(
                        color: colors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // CircleAvatar gives each icon a light blue circle
                  const ListTile(
                    leading: CircleAvatar(child: Icon(Icons.person)),
                    title: Text('Name'),
                    subtitle: Text('Muhammad Nur Hafiz bin Mohd Zaid'),
                  ),
                  const ListTile(
                    leading: CircleAvatar(child: Icon(Icons.badge)),
                    title: Text('Matric No'),
                    subtitle: Text('2024250672'),
                  ),
                  const ListTile(
                    leading: CircleAvatar(child: Icon(Icons.school)),
                    title: Text('Course'),
                    subtitle: Text('CS251 - Netcentric Computing'),
                  ),
                  const Divider(height: 1),
                  // Clickable GitHub repository URL
                  ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.code)),
                    title: const Text('GitHub Repository'),
                    subtitle: Text(
                      githubUrl,
                      style: TextStyle(
                        color: colors.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    trailing: const Icon(Icons.open_in_new),
                    onTap: () => openGitHub(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Copyright notice
            Text(
              '© 2026 Muhammad Nur Hafiz bin Mohd Zaid. All rights reserved.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
