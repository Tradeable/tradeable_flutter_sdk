import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/tradeable_flutter_sdk.dart';

class DeepLinkTestPage extends StatelessWidget {
  const DeepLinkTestPage({super.key});

  void _testLink(BuildContext context, String path,
      [Map<String, String>? params]) {
    final queryParams = params != null
        ? '?${params.entries.map((e) => '${e.key}=${e.value}').join('&')}'
        : '';
    final uri = Uri.parse('https://simplehai.axisdirect.in/app$path$queryParams');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sending: $uri'), duration: Duration(seconds: 1)),
    );
    TFS().handleDeepLink(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Deep Link Test')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Tap a button to simulate a deep link:',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          _LinkTile(
            title: 'Dashboard',
            subtitle: 'simplehai.axisdirect.in/app/dashboard',
            onTap: () => _testLink(context, '/dashboard'),
          ),
          _LinkTile(
            title: 'Courses',
            subtitle: 'simplehai.axisdirect.in/app/courses',
            onTap: () => _testLink(context, '/courses'),
          ),
          _LinkTile(
            title: 'Course by ID',
            subtitle: 'simplehai.axisdirect.in/app/courseById?courseId=42',
            onTap: () => _testLink(context, '/courseById', {'courseId': '42'}),
          ),
          _LinkTile(
            title: 'Flow by ID',
            subtitle: 'simplehai.axisdirect.in/app/flowById?flowId=10',
            onTap: () => _testLink(context, '/flowById', {'flowId': '10'}),
          ),
          _LinkTile(
            title: 'Topic by ID',
            subtitle: 'simplehai.axisdirect.in/app/topicById?topicId=5',
            onTap: () => _testLink(context, '/topicById', {'topicId': '5'}),
          ),
          _LinkTile(
            title: 'Open Side Drawer',
            subtitle: 'simplehai.axisdirect.in/app/openSideDrawer?tagId=5&source=deeplink',
            onTap: () => _testLink(
                context, '/openSideDrawer', {'tagId': '5', 'source': 'deeplink'}),
          ),
          _LinkTile(
            title: 'User Activity',
            subtitle: 'simplehai.axisdirect.in/app/userActivity',
            onTap: () => _testLink(context, '/userActivity'),
          ),
        ],
      ),
    );
  }
}

class _LinkTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _LinkTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle:
            Text(subtitle, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
