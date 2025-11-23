import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/api_provider.dart';
import '../widgets/app_bar_builder.dart';
import '../widgets/card_widget.dart';
import '../widgets/shimmer_loader.dart';

/// Task 1: GET API Demo
/// Fetch user list and display on UI with loading states
/// Demonstrates: async/await, loading states, error handling, FutureBuilder alternatives
class UsersListScreen extends StatefulWidget {
  const UsersListScreen({Key? key}) : super(key: key);

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  // Task 5: Widget Lifecycle - initState() called when screen loads
  @override
  void initState() {
    super.initState();
    // Note: API is fetched from home screen, but can refresh here
  }

  // Task 5: Widget Lifecycle - dispose() for cleanup
  @override
  void dispose() {
    // Cleanup code if needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBuilder(
        title: 'GET - Fetch Users',
        showBackButton: true,
        actions: [
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ApiProvider>().fetchUsers();
            },
          ),
        ],
      ),
      body: Consumer<ApiProvider>(
        builder: (context, apiProvider, child) {
          // Task 1: Loading State
          if (apiProvider.isLoading) {
            return ShimmerLoader(itemCount: 5);
          }

          // Task 1: Error State
          if (apiProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    'Error Loading Users',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    apiProvider.errorMessage ?? 'Unknown error',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<ApiProvider>().fetchUsers();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Task 1: Success State - Display user list
          if (apiProvider.users.isEmpty) {
            return Center(
              child: Text(
                'No users found',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            );
          }

          // Task 4: Responsive UI - Use LayoutBuilder for responsive widgets
          return LayoutBuilder(
            builder: (context, constraints) {
              final isTall = constraints.maxHeight > 600;
              
              return ListView.builder(
                itemCount: apiProvider.users.length,
                itemBuilder: (context, index) {
                  final user = apiProvider.users[index];
                  return UserCard(
                    userData: user,
                    onTap: () {
                      _showUserDetails(context, user);
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  /// Show user details in a dialog
  void _showUserDetails(BuildContext context, Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(user['name'] ?? 'User'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('ID', user['id']?.toString() ?? 'N/A'),
              _buildDetailRow('Email', user['email'] ?? 'N/A'),
              _buildDetailRow('Phone', user['phone'] ?? 'N/A'),
              _buildDetailRow('Website', user['website'] ?? 'N/A'),
              _buildDetailRow('Company', user['company']?['name'] ?? 'N/A'),
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

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        Text(value, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 12),
      ],
    );
  }
}