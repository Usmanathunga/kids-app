import 'package:flutter/material.dart';

void main() {
  runApp(ChildActivityApp());
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
        colorSchemeSeed: Colors.orange, // A warm, child-friendly color
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

  // These would eventually be separate files/classes
  static const List<Widget> _modes = <Widget>[
    Center(
      child: Text(
        'Child Mode: Fun Activities Here!',
        style: TextStyle(fontSize: 24),
      ),
    ),
    Center(
      child: Text(
        'Parent Mode: Progress & Limits',
        style: TextStyle(fontSize: 24),
      ),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('KidSteps'), centerTitle: true),
      body: _modes[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.face), label: 'Child Mode'),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights),
            label: 'Parent Mode',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
