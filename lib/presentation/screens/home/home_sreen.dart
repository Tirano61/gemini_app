
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Gimini'),
      ),
      body: ListTile(

        leading: const CircleAvatar(
          backgroundColor: Colors.pink,
          child: Icon(Icons.person_2_outlined),
        ),
        title: const Text('Prompt basico a Gemini'),
        subtitle: const Text('Usando el modelo Flash'),
        onTap: () => context.push('/basic-prompt'),
      ),
    );
  }
}