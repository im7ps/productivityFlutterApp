import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/daily_logs_provider.dart';
import '../../data/models/daily_log.dart';

class DailyLogListScreen extends ConsumerWidget {
  const DailyLogListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyLogsAsync = ref.watch(dailyLogsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Logs Test'),
        actions: [ 
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(dailyLogsNotifierProvider),
          ),
        ],
      ),
      body: dailyLogsAsync.when(
        data: (logs) => logs.isEmpty
            ? const Center(child: Text('Nessun log presente. Aggiungine uno!'))
            : ListView.builder(
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  final log = logs[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text('Giorno: ${log.day}'),
                      subtitle: Text(
                        'Sonno: ${log.sleepHours}h | Umore: ${log.moodScore}/10\nNota: ${log.note ?? "-"}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => ref
                            .read(dailyLogsNotifierProvider.notifier)
                            .deleteLog(log.id),
                      ),
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Errore: $err', style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(dailyLogsNotifierProvider),
                child: const Text('Riprova'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDummyDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDummyDialog(BuildContext context, WidgetRef ref) {
    // Aggiunge un log fake per testare la comunicazione col backend
    final today = DateTime.now().toIso8601String().split('T')[0];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Test: Aggiungi Log Fake'),
        content: Text('Verrà creato un log per la data di oggi: $today'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annulla'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(dailyLogsNotifierProvider.notifier).addLog(
                    DailyLogCreate(
                      day: today,
                      sleepHours: 7.5,
                      sleepQuality: 4, // Range 1-5
                      moodScore: 4,    // Range 1-5
                      dietQuality: 3,  // Range 1-5
                      exerciseMinutes: 30,
                      note: 'Log generato automaticamente per test.',
                    ),
                  );
              Navigator.pop(context);
            },
            child: const Text('Aggiungi'),
          ),
        ],
      ),
    );
  }
}
