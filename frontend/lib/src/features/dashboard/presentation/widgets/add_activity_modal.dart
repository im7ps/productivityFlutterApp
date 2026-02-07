import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../category/presentation/category_providers.dart';
import '../../../activity_log/presentation/activity_providers.dart';

class AddActivityModal extends ConsumerStatefulWidget {
  const AddActivityModal({super.key});

  @override
  ConsumerState<AddActivityModal> createState() => _AddActivityModalState();
}

class _AddActivityModalState extends ConsumerState<AddActivityModal> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  String? _selectedCategoryId;
  
  // Per semplicità, start time è NOW al momento dell'apertura, ma potremmo aggiungere un picker.
  final DateTime _startTime = DateTime.now();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final success = await ref
          .read(activityCreateControllerProvider.notifier)
          .createActivity(
            startTime: _startTime,
            description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
            categoryId: _selectedCategoryId,
          );

      if (success && mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesListProvider);
    final createControllerState = ref.watch(activityCreateControllerProvider);

    final isLoading = createControllerState.isLoading;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.newActivityTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            
            // Categoria Dropdown
            categoriesAsync.when(
              data: (categories) {
                if (categories.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      AppStrings.noCategoriesFound,
                      style: TextStyle(color: Colors.orange),
                    ),
                  );
                }
                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: AppStrings.categoryLabel,
                    border: OutlineInputBorder(),
                  ),
                  items: categories.map((cat) {
                    return DropdownMenuItem(
                      value: cat.id,
                      child: Row(
                        children: [
                          const Icon(Icons.circle, size: 16),
                          const SizedBox(width: 8),
                          Text(cat.name),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedCategoryId = val),
                );
              },
              loading: () => const LinearProgressIndicator(),
              error: (err, stack) => Text('${AppStrings.errorLoadingCategories}: $err'),
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
            
            const SizedBox(height: 24),
            
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
              child: isLoading 
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text(AppStrings.saveButton),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
