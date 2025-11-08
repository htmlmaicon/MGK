import 'package:flutter/material.dart';
import 'text_field.dart';

class CepField extends StatelessWidget {
  final TextEditingController cepController;
  final TextEditingController enderecoController;
  final Future<void> Function(String) onSearchCep;
  final FormFieldValidator<String>? validator;
  final bool isLoading;
  final String? error;

  const CepField({
    super.key,
    required this.cepController,
    required this.enderecoController,
    required this.onSearchCep,
    this.validator,
    this.isLoading = false,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: cepController,
                labelText: "CEP",
                keyboardType: TextInputType.number,
                validator: validator,
              ),
            ),
            IconButton(
              icon: isLoading 
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.search, color: Colors.green),
              onPressed: isLoading ? null : () => onSearchCep(cepController.text),
            )
          ],
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 4),
            child: Text(
              error!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}