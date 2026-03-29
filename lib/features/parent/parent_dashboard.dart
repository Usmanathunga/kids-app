import 'package:flutter/material.dart';
import 'widgets/summary_card.dart';
import 'widgets/activity_tile.dart';
import 'widgets/action_button.dart';

class ParentDashboard extends StatelessWidget {
  const ParentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Weekly Progress",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
          const SizedBox(height: 15),
          const SummaryCard(),
          const SizedBox(height: 25),
          const Text("Recent Activities",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
          const SizedBox(height: 15),
          const ActivityTile(
            title: "Spelling Bee",
            subtitle: "Completed 15 mins ago",
            icon: Icons.spellcheck,
            color: Colors.green,
          ),
          const ActivityTile(
            title: "Coloring Fun",
            subtitle: "20 mins spent today",
            icon: Icons.brush,
            color: Colors.orange,
          ),
          const ActivityTile(
            title: "Math Quiz",
            subtitle: "Locked - Needs Review",
            icon: Icons.calculate,
            color: Colors.redAccent,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ActionButton(
                  label: "Set Limits",
                  icon: Icons.timer,
                  color: Colors.blue,
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ActionButton(
                  label: "Settings",
                  icon: Icons.settings,
                  color: Colors.blueGrey,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
