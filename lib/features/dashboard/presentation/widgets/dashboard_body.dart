
import 'package:flutter/material.dart';
import '../cubit/dashboard_state.dart';
import 'dashboard_content_layout.dart';

class DashboardBody extends StatelessWidget {
  const DashboardBody({
    super.key,
    required this.state,
    required this.userId,
    required this.isDesktop,
  });

  final DashboardLoaded state;
  final String userId;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Your nutrition overview for today',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                
                  ),
                ),
              ),
              // TextButton.icon(
              //   onPressed: () {
              //     Navigator.of(context).push(
              //       MaterialPageRoute<void>(
              //         builder: (_) => const ProgressScreen(),
              //       ),
              //     );
              //   },
              //   icon: const Icon(Icons.show_chart),
              //   label: const Text('View Progress'),
              // ),
            ],
          ),
          const SizedBox(height: 16),
          DashboardContentLayout(
            state: state,
            userId: userId,
            isDesktop: isDesktop,
          ),
        ],
      ),
    );
  }
}
