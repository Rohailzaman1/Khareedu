import 'package:flutter/material.dart';

class Admin_panel extends StatefulWidget {
  const Admin_panel({super.key});

  @override
  State<Admin_panel> createState() => _Admin_panelState();
}

class _Admin_panelState extends State<Admin_panel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Rohail"),
          )

        ],
      ),
    );
  }
}

