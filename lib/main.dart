import 'package:flutter/material.dart';

void main() {
  runApp(const ChildActivityApp());
}

class ChildActivityApp extends StatelessWidget {
  const ChildActivityApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KidSteps',
      theme: ThemeData(
        useMaterial3: true,
        // Using a rounded font makes the app feel more "child-friendly"
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  // STEP 1: Update this list to call your new Dashboard widgets
  static final List<Widget> _modes = <Widget>[
    const ChildDashboard(),  // The Fun Side
    const ParentDashboard(), // The Management Side
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? '🌟 KidSteps 🌟' : 'Parent Control'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFE082), Color(0xFFFFB74D)], 
          ),
        ),
        child: SafeArea(child: _modes[_selectedIndex]),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 5, blurRadius: 10)],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          child: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.palette), label: 'Play'),
              BottomNavigationBarItem(icon: Icon(Icons.settings_accessibility), label: 'Parents'),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.deepOrange,
            onTap: (index) => setState(() => _selectedIndex = index),
          ),
        ),
      ),
    );
  }
}

// --- CHILD MODE WIDGET ---
class ChildDashboard extends StatelessWidget {
  const ChildDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(20),
      crossAxisCount: 2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      children: [
        _buildActivityCard('Drawing', Icons.brush, Colors.pinkAccent),
        _buildActivityCard('Music', Icons.music_note, Colors.blueAccent),
        _buildActivityCard('Games', Icons.videogame_asset, Colors.greenAccent),
        _buildActivityCard('Stories', Icons.auto_stories, Colors.purpleAccent),
      ],
    );
  }

  Widget _buildActivityCard(String title, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: color),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// --- STEP 2: PARENT MODE WIDGET ---
class ParentDashboard extends StatelessWidget {
  const ParentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Weekly Progress", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 15),
          _buildSummaryCard(),
          const SizedBox(height: 25),
          const Text("Recent Activities", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 15),
          _buildActivityTile("Spelling Bee", "Completed 15 mins ago", Icons.spellcheck, Colors.green),
          _buildActivityTile("Coloring Fun", "20 mins spent today", Icons.brush, Colors.orange),
          _buildActivityTile("Math Quiz", "Locked - Needs Review", Icons.calculate, Colors.redAccent),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildActionBtn("Set Limits", Icons.timer, Colors.blue)),
              const SizedBox(width: 15),
              Expanded(child: _buildActionBtn("Settings", Icons.settings, Colors.blueGrey)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
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
          CircularProgressIndicator(value: 0.7, strokeWidth: 8, color: Colors.orangeAccent, backgroundColor: Colors.grey[200]),
        ],
      ),
    );
  }

  Widget _buildActivityTile(String title, String subtitle, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }

  Widget _buildActionBtn(String label, IconData icon, Color color) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {},
      icon: Icon(icon),
      label: Text(label),
    );
  }
}