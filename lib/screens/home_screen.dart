import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/api_provider.dart';
import '../widgets/app_bar_builder.dart';
import '../widgets/custom_button.dart';
import 'users_list_screen.dart';
import 'create_user_screen.dart';
import 'update_user_screen.dart';
import 'stream_demo_screen.dart';

/// Task 5: Home Screen demonstrating Widget Lifecycle
/// initState() -> called when widget is created
/// build() -> renders UI
/// dispose() -> cleanup (if stateful)
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Task 5: Widget Lifecycle - initState() called when widget is created
  @override
  void initState() {
    super.initState();
    // Fetch users when app launches
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ApiProvider>().fetchUsers();
    });
  }

  // Task 5: Widget Lifecycle - didChangeDependencies called when dependencies change
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Can be used to react to theme changes or other dependency updates
  }

  // Task 5: Widget Lifecycle - dispose called to clean up resources
  @override
  void dispose() {
    // Cleanup code here if needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Task 4: Responsive UI - Use MediaQuery for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    return Scaffold(
      appBar: AppBarBuilder(
        title: 'Flutter Assignment',
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Text
              Text(
                'API Integration Demo',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Explore GET, POST, and PUT operations',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: screenHeight * 0.04),

              // GET Request Button
              _buildMenuButton(
                context: context,
                title: 'GET - Fetch Users',
                subtitle: 'Load user list from API',
                icon: Icons.download,
                color: Colors.green,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const UsersListScreen()),
                  );
                },
              ),
              SizedBox(height: screenHeight * 0.02),

              // POST Request Button
              _buildMenuButton(
                context: context,
                title: 'POST - Create User',
                subtitle: 'Submit form and get response',
                icon: Icons.add_circle,
                color: Colors.orange,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CreateUserScreen()),
                  );
                },
              ),
              SizedBox(height: screenHeight * 0.02),

              // PUT Request Button
              _buildMenuButton(
                context: context,
                title: 'PUT - Update User',
                subtitle: 'Update existing user data',
                icon: Icons.edit,
                color: Colors.purple,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const UpdateUserScreen()),
                  );
                },
              ),
              SizedBox(height: screenHeight * 0.02),

              // Stream Demo Button
              _buildMenuButton(
                context: context,
                title: 'Stream Demo',
                subtitle: 'Learn about Futures and Streams',
                icon: Icons.stream,
                color: Colors.cyan,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const StreamDemoScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper widget to build menu buttons
  Widget _buildMenuButton({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withAlpha(51),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}