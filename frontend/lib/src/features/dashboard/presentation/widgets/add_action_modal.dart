import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../dimension/presentation/dimension_providers.dart';
import '../../../action/presentation/action_providers.dart';

class AddActionModal extends ConsumerStatefulWidget {
  const AddActionModal({super.key});

  @override
  ConsumerState<AddActionModal> createState() => _AddActionModalState();
}

class _AddActionModalState extends ConsumerState<AddActionModal> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  String? _selectedDimensionId;
  int _fulfillmentScore = 3;
  
  final DateTime _startTime = DateTime.now();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate() && _selectedDimensionId != null) {
      final success = await ref
          .read(actionCreateControllerProvider.notifier)
          .createAction(
            startTime: _startTime,
            description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
            dimensionId: _selectedDimensionId!,
            fulfillmentScore: _fulfillmentScore,
          );

      if (success && mounted) {
        Navigator.of(context).pop();
      }
    } else if (_selectedDimensionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Seleziona una dimensione")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dimensionsAsync = ref.watch(dimensionsListProvider);
    final createControllerState = ref.watch(actionCreateControllerProvider);

    final isLoading = createControllerState.isLoading;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.newActionTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            
            // Dimension Selection
            dimensionsAsync.when(
              data: (dimensions) {
                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: AppStrings.dimensionLabel,
                    border: OutlineInputBorder(),
                  ),
                  items: dimensions.map((dim) {
                    return DropdownMenuItem(
                      value: dim.id,
                      child: Text(dim.name),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedDimensionId = val),
                );
              },
              loading: () => const LinearProgressIndicator(),
              error: (err, stack) => Text('${AppStrings.errorLoadingDimensions}: $err'),
            ),
            
            const SizedBox(height: 24),

            // Fulfillment Score
            const Text("Quanto ti ha nutrito? (1-5)"),
            Slider(
              value: _fulfillmentScore.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              label: _fulfillmentScore.toString(),
              onChanged: (val) => setState(() => _fulfillmentScore = val.round()),
            ),
            
            const SizedBox(height: 16),

            // Descrizione Input
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: AppStrings.descriptionLabel,
                border: OutlineInputBorder(),
              ),
            ),
            
            const SizedBox(height: 32),
            
            if (createControllerState.hasError)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  createControllerState.error.toString(),
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            ElevatedButton(
              onPressed: isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: isLoading 
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text("SALVA"),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
