import 'package:flutter/material.dart';

class VitalCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final bool isNormal;
  final IconData icon;
  final DateTime timestamp;

  const VitalCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.isNormal,
    required this.icon,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    final color = isNormal ? Colors.green : Colors.red;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(label,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500)),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isNormal
                        ? Colors.green.shade50
                        : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: isNormal ? Colors.green : Colors.red),
                  ),
                  child: Text(
                    isNormal ? 'Normal' : 'Alert',
                    style: TextStyle(
                        fontSize: 11,
                        color: color,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(value,
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: color)),
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(unit,
                      style: TextStyle(
                          fontSize: 14, color: Colors.grey.shade600)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Updated: ${timestamp.hour.toString().padLeft(2, '0')}:'
              '${timestamp.minute.toString().padLeft(2, '0')}:'
              '${timestamp.second.toString().padLeft(2, '0')}',
              style:
                  TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingCard extends StatelessWidget {
  final String label;
  const LoadingCard({required this.label});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

class ErrorCard extends StatelessWidget {
  final String message;
  const ErrorCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.sensors_off, color: Colors.red),
            const SizedBox(width: 8),
            Expanded(
              child: Text(message,
                  style: const TextStyle(fontSize: 12, color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}
