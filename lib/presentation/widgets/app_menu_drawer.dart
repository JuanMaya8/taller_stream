// TODO: AppMenuDrawer
import 'package:flutter/material.dart';

enum AppMenuDestination { monitor, history }

class AppMenuDrawer extends StatelessWidget {
  final AppMenuDestination selectedDestination;
  final VoidCallback onMonitorTap;
  final VoidCallback onHistoryTap;

  const AppMenuDrawer({
    super.key,
    required this.selectedDestination,
    required this.onMonitorTap,
    required this.onHistoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.teal.shade50,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.monitor_heart, color: Colors.teal, size: 36),
                  SizedBox(height: 12),
                  Text(
                    'Medical IoT',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Vital Signs Monitor',
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Monitor'),
              selected: selectedDestination == AppMenuDestination.monitor,
              selectedColor: Colors.teal,
              selectedTileColor: Colors.teal.shade50,
              onTap: onMonitorTap,
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Historial'),
              selected: selectedDestination == AppMenuDestination.history,
              selectedColor: Colors.teal,
              selectedTileColor: Colors.teal.shade50,
              onTap: onHistoryTap,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Streams + Isolates',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
