import 'package:flutter/material.dart';

class VerClientesPage extends StatelessWidget {
  final List<String> clientes = [
    'João Silva',
    'Maria Oliveira',
    'Carlos Souza',
    'Ana Paula',
    'Pedro Santos',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Lista de Clientes',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green[900],
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: clientes.length,
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.green[50],
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            child: ListTile(
              leading: Icon(Icons.person, color: Colors.green[800], size: 35),
              title: Text(
                clientes[index],
                style: TextStyle(
                  color: Colors.green[900],
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}