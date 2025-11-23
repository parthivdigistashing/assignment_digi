import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/api_provider.dart';
import '../widgets/app_bar_builder.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';

/// Task 1: POST API Demo
/// Submit form data and display response
/// Demonstrates: Form validation, async/await, response handling
class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({Key? key}) : super(key: key);

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  // Form controllers
  late TextEditingController _nameController;
  late TextEditingController _jobController;
  final _formKey = GlobalKey<FormState>();

  // Task 5: Widget Lifecycle - initState() to initialize controllers
  @override
  void initState() {
    super.initState();
    // Initialize controllers when screen loads
    _nameController = TextEditingController();
    _jobController = TextEditingController();
  }

  // Task 5: Widget Lifecycle - dispose() to clean up controllers
  @override
  void dispose() {
    // IMPORTANT: Clean up controllers to prevent memory leaks
    _nameController.dispose();
    _jobController.dispose();
    super.dispose();
  }

  // Validation functions
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? _validateJob(String? value) {
    if (value == null || value.isEmpty) {
      return 'Job is required';
    }
    if (value.length < 2) {
      return 'Job must be at least 2 characters';
    }
    return null;
  }

  /// Submit form and call POST API
  /// Demonstrates: async/await, try/catch error handling
  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = _nameController.text;
    final job = _jobController.text;

    // Call API through provider
    final success = await context.read<ApiProvider>().createUser(name, job);

    if (mounted) {
      if (success) {
        // Show success dialog with response
        _showResponseDialog('User Created Successfully');
        _nameController.clear();
        _jobController.clear();
      } else {
        // Show error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.read<ApiProvider>().errorMessage ?? 'Error creating user',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showResponseDialog(String title) {
    final response = context.read<ApiProvider>().lastResponse;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'API Response:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  response.toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Task 4: Responsive UI - Use MediaQuery for sizing
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBarBuilder(
        title: 'POST - Create User',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Create a New User',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                const Text(
                  'Fill in the details below:',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),

                // Name TextField
                CustomTextField(
                  label: 'Full Name',
                  hint: 'e.g., Bijay',
                  controller: _nameController,
                  validator: _validateName,
                ),
                SizedBox(height: screenHeight * 0.02),

                // Job TextField
                CustomTextField(
                  label: 'Job Title',
                  hint: 'e.g., developer',
                  controller: _jobController,
                  validator: _validateJob,
                ),
                SizedBox(height: screenHeight * 0.04),

                // Submit Button
                Consumer<ApiProvider>(
                  builder: (context, apiProvider, child) {
                    return CustomButton(
                      text: 'Create User',
                      onTap: _submitForm,
                      isLoading: apiProvider.isLoading,
                      backgroundColor: Colors.orange,
                    );
                  },
                ),

                SizedBox(height: screenHeight * 0.03),

                // Info Box
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        '📝 Note:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'This form demonstrates POST API integration. The data is sent to the API and response is shown in a dialog.',
                        style: TextStyle(color: Colors.blue, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}