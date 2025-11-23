import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/api_provider.dart';
import '../widgets/app_bar_builder.dart';
import '../widgets/custom_button.dart';

/// Task 6: Asynchronous Programming Demo
/// Demonstrates:
/// - What is a Future
/// - How async/await works
/// - How to use FutureBuilder
/// - How to use Streams (simple counter stream)
class StreamDemoScreen extends StatefulWidget {
  const StreamDemoScreen({Key? key}) : super(key: key);

  @override
  State<StreamDemoScreen> createState() => _StreamDemoScreenState();
}

class _StreamDemoScreenState extends State<StreamDemoScreen> {
  late Future<String> _futureData;

  // Task 5: Widget Lifecycle - initState() initializes future
  @override
  void initState() {
    super.initState();
    // Initialize future that will complete after 2 seconds
    _futureData = _fetchDataSimulation();
  }

  // Task 5: Widget Lifecycle - dispose() for cleanup
  @override
  void dispose() {
    super.dispose();
  }

  /// Simulates API call using Future
  /// Task 6: What is a Future - represents an asynchronous operation
  Future<String> _fetchDataSimulation() async {
    // Task 6: How async/await works - pauses execution until future completes
    await Future.delayed(const Duration(seconds: 2));
    return 'Data loaded successfully!';
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBarBuilder(
        title: 'Async Programming Demo',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Section 1: FutureBuilder Demo
              Text(
                'Task 6: FutureBuilder Demo',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              
              // Task 6: How to use FutureBuilder
              FutureBuilder<String>(
                future: _futureData,
                builder: (context, snapshot) {
                  // While the future is loading
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Column(
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text(
                            'Loading data...',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }

                  // If future completed with error
                  if (snapshot.hasError) {
                    return Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.error, color: Colors.red.shade700, size: 48),
                          const SizedBox(height: 16),
                          Text(
                            'Error: ${snapshot.error}',
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ],
                      ),
                    );
                  }

                  // If future completed successfully
                  if (snapshot.hasData) {
                    return Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.check_circle, 
                            color: Colors.green.shade700, 
                            size: 48
                          ),
                          const SizedBox(height: 16),
                          Text(
                            snapshot.data ?? 'No data',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return const Text('No data');
                },
              ),

              SizedBox(height: screenHeight * 0.04),

              // Section 2: Stream Demo
              Text(
                'Task 6: Stream Demo (Counter Stream)',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Task 6: How to use Streams (simple counter stream)
              Consumer<ApiProvider>(
                builder: (context, apiProvider, child) {
                  return Column(
                    children: [
                      StreamBuilder<int>(
                        stream: apiProvider.getCounterStream(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == 
                            ConnectionState.waiting) {
                            return Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.orange.shade200
                                ),
                              ),
                              child: const Column(
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 16),
                                  Text(
                                    'Starting stream...',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            );
                          }

                          if (snapshot.hasError) {
                            return Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.red.shade200
                                ),
                              ),
                              child: Text(
                                'Error: ${snapshot.error}',
                                style: TextStyle(color: Colors.red.shade700),
                              ),
                            );
                          }

                          if (snapshot.hasData) {
                            return Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.cyan.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.cyan.shade200
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Stream Value:',
                                    style: TextStyle(
                                      color: Colors.cyan.shade700,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${snapshot.data}',
                                    style: TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.cyan.shade700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Emitting values 0-10 every second',
                                    style: TextStyle(
                                      color: Colors.cyan.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return const Text('Stream complete');
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      CustomButton(
                        text: 'Start New Stream',
                        onTap: () {
                          setState(() {
                            _futureData = _fetchDataSimulation();
                          });
                        },
                        backgroundColor: Colors.cyan,
                      ),
                    ],
                  );
                },
              ),

              SizedBox(height: screenHeight * 0.04),

              // Section 3: Explanation
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Key Concepts:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildConceptRow('Future', 
                      'Represents a single async value in future'),
                    _buildConceptRow('async/await', 
                      'Syntactic sugar for working with futures'),
                    _buildConceptRow('FutureBuilder', 
                      'Widget that rebuilds based on future state'),
                    _buildConceptRow('Stream', 
                      'Multiple async values over time'),
                    _buildConceptRow('StreamBuilder', 
                      'Widget that rebuilds on stream events'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConceptRow(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        Text(
          description,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}