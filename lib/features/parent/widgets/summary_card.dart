import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Screen Time", style: TextStyle(color: Colors.grey, fontSize: 14)),
              Text("2h 15m", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            ],
          ),
          CircularProgressIndicator(
            value: 0.7,
            strokeWidth: 8,
            color: Colors.orangeAccent,
            backgroundColor: Colors.grey[200],
          ),
        ],
      ),
    );
  }
}
