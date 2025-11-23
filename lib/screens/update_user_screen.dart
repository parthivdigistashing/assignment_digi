import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/api_provider.dart';
import '../widgets/app_bar_builder.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';

/// Task 1: PUT API Demo
/// Update existing user data
/// Demonstrates: PUT request, async/await, response handling
class UpdateUserScreen extends StatefulWidget {
  const UpdateUserScreen({Key? key}) : super(key: key);

  @override
  State<UpdateUserScreen> createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  // Form controllers
  late TextEditingController _userIdController;
  late TextEditingController _nameController;
  late TextEditingController _jobController;
  final _formKey = GlobalKey<FormState>();

  // Task 5: Widget Lifecycle - initState() to initialize controllers
  @override
  void initState() {
    super.initState();
    // Initialize controllers
    _userIdController = TextEditingController(text: '2'); // Default user ID
    _nameController = TextEditingController();
    _jobController = TextEditingController();
  }

  // Task 5: Widget Lifecycle - dispose() to clean up controllers
  @override
  void dispose() {
    // IMPORTANT: Clean up controllers to prevent memory leaks
    _userIdController.dispose();
    _nameController.dispose();
    _jobController.dispose();
    super.dispose();
  }

  // Validation functions
  String? _validateUserId(String? value) {
    if (value == null || value.isEmpty) {
      return 'User ID is required';
    }
    if (int.tryParse(value) == null) {
      return 'User ID must be a number';
    }
    return null;
  }

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

  /// Submit form and call PUT API
  /// Demonstrates: async/await, try/catch error handling
  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final userId = int.parse(_userIdController.text);
    final name = _nameController.text;
    final job = _jobController.text;

    // Call PUT API through provider
    final success = await context.read<ApiProvider>().updateUser(userId, name, job);

    if (mounted) {
      if (success) {
        // Show success dialog with response
        _showResponseDialog('User Updated Successfully');
        _nameController.clear();
        _jobController.clear();
      } else {
        // Show error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.read<ApiProvider>().errorMessage ?? 'Error updating user',
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
        title: 'PUT - Update User',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Update User Information',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                const Text(
                  'Modify user details:',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),

                // User ID TextField
                CustomTextField(
                  label: 'User ID',
                  hint: 'e.g., 2',
                  controller: _userIdController,
                  validator: _validateUserId,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: screenHeight * 0.02),

                // Name TextField
                CustomTextField(
                  label: 'Full Name',
                  hint: 'e.g., bijay',
                  controller: _nameController,
                  validator: _validateName,
                ),
                SizedBox(height: screenHeight * 0.02),

                // Job TextField
                CustomTextField(
                  label: 'Job Title',
                  hint: 'e.g., team leader',
                  controller: _jobController,
                  validator: _validateJob,
                ),
                SizedBox(height: screenHeight * 0.04),

                // Submit Button
                Consumer<ApiProvider>(
                  builder: (context, apiProvider, child) {
                    return CustomButton(
                      text: 'Update User',
                      onTap: _submitForm,
                      isLoading: apiProvider.isLoading,
                      backgroundColor: Colors.purple,
                    );
                  },
                ),

                SizedBox(height: screenHeight * 0.03),

                // Info Box
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.purple.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        '✏️ Note:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'This demonstrates PUT API to update existing user. Default user ID is 2. Change the values and submit.',
                        style: TextStyle(color: Colors.purple, fontSize: 13),
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