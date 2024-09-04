import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Touch Cloud"),
        titleTextStyle: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.white
        ),
      ),
      body: ListView(
        children: const [
          ListTile(
            title: Text("Description"),
            subtitle: Text("A simple weather app made with flutter"),
          ),
          ListTile(
            title: Text("Developed by"),
            subtitle: Text("Samuel Filipe Faria"),
          ),
          ListTile(
            title: Text("GitHub repository"),
            subtitle: Text("https://github.com/samuelfilipefaria/touch-cloud"),
          ),
          ListTile(
            title: Text("Used API"),
            subtitle: Text("https://github.com/robertoduessmann/weather-api"),
          ),
        ],
      )
    );
  }
}
