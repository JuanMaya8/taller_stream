// TODO: HistoryScreen
import 'package:flutter/material.dart';
import '../../domain/entities/vital_sign.dart';
import '../../domain/usecases/monitor_vitals_use_case.dart';
import '../widgets/app_menu_drawer.dart';

class HistoryScreen extends StatelessWidget {
  final MonitorVitalsUseCase useCase;

  const HistoryScreen({super.key, required this.useCase});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        drawer: AppMenuDrawer(
          selectedDestination: AppMenuDestination.history,
          onMonitorTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).maybePop();
          },
          onHistoryTap: () => Navigator.of(context).pop(),
        ),
        appBar: AppBar(
          title: const Text('Vitals History'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0.5,
          bottom: const TabBar(
            labelColor: Colors.teal,
            unselectedLabelColor: Colors.black54,
            tabs: [
              Tab(icon: Icon(Icons.favorite), text: 'Heart'),
              Tab(icon: Icon(Icons.water_drop), text: 'Pressure'),
              Tab(icon: Icon(Icons.thermostat), text: 'Temp'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _HistoryList(
              title: 'Heart Rate',
              stream: useCase.watchHeartRateHistory(),
              icon: Icons.favorite,
            ),
            _HistoryList(
              title: 'Blood Pressure',
              stream: useCase.watchBloodPressureHistory(),
              icon: Icons.water_drop,
            ),
            _HistoryList(
              title: 'Temperature',
              stream: useCase.watchTemperatureHistory(),
              icon: Icons.thermostat,
              decimals: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryList extends StatelessWidget {
  final String title;
  final Stream<List<VitalSign>> stream;
  final IconData icon;
  final int decimals;

  const _HistoryList({
    required this.title,
    required this.stream,
    required this.icon,
    this.decimals = 0,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<VitalSign>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                snapshot.error.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        final history = snapshot.data ?? const <VitalSign>[];

        if (history.isEmpty) {
          return _EmptyHistory(title: title, icon: icon);
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: history.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final vital = history[index];
            return _HistoryTile(vital: vital, icon: icon, decimals: decimals);
          },
        );
      },
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final VitalSign vital;
  final IconData icon;
  final int decimals;

  const _HistoryTile({
    required this.vital,
    required this.icon,
    required this.decimals,
  });

  @override
  Widget build(BuildContext context) {
    final color = vital.isNormal ? Colors.green : Colors.red;
    final time = _formatTime(vital.timestamp);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              vital.isNormal ? Colors.green.shade50 : Colors.red.shade50,
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          '${vital.value.toStringAsFixed(decimals)} ${vital.unit}',
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text('Updated: $time'),
        trailing: Text(
          vital.isNormal ? 'Normal' : 'Alert',
          style: TextStyle(color: color, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final second = timestamp.second.toString().padLeft(2, '0');
    return '$hour:$minute:$second';
  }
}

class _EmptyHistory extends StatelessWidget {
  final String title;
  final IconData icon;

  const _EmptyHistory({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: Colors.grey.shade500),
            const SizedBox(height: 12),
            Text(
              'Waiting for $title readings',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
