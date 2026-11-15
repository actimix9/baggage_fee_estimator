import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_info.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  /// Opens the GitHub repository in the phone's browser.
  Future<void> _openGitHub(BuildContext context) async {
    final Uri url = Uri.parse(AppInfo.githubUrl);
    bool opened = false;
    try {
      opened = await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Could not open $url: $e');
    }

    if (!context.mounted) {
      return;
    }
    if (!opened) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the GitHub link.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                const SizedBox(height: 8),

                // Application icon
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    AppInfo.iconAsset,
                    key: const Key('appIcon'),
                    width: 110,
                    height: 110,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.luggage,
                      size: 110,
                      color: scheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  AppInfo.appTitle,
                  style: textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Version ${AppInfo.version}',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Estimates the excess baggage fee for air travel from the '
                  'baggage weight, ticket class and rate per kg, '
                  'including 8% service tax.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Author information
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: Text(
                          'Author Information',
                          style: textTheme.titleMedium,
                        ),
                      ),
                      const ListTile(
                        leading: Icon(Icons.person),
                        title: Text('Name'),
                        subtitle: Text(AppInfo.authorName),
                      ),
                      const ListTile(
                        leading: Icon(Icons.badge),
                        title: Text('Matric No'),
                        subtitle: Text(AppInfo.matricNo),
                      ),
                      const ListTile(
                        leading: Icon(Icons.school),
                        title: Text('Course'),
                        subtitle: Text(AppInfo.course),
                      ),

                      // Clickable GitHub repository URL
                      ListTile(
                        key: const Key('githubLink'),
                        leading: const Icon(Icons.code),
                        title: const Text('GitHub Repository'),
                        subtitle: Text(
                          AppInfo.githubUrl,
                          style: TextStyle(
                            color: scheme.primary,
                            decoration: TextDecoration.underline,
                            decorationColor: scheme.primary,
                          ),
                        ),
                        trailing: const Icon(Icons.open_in_new),
                        onTap: () => _openGitHub(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Copyright notice
                Text(
                  AppInfo.copyright,
                  style: textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
