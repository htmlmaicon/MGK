import 'package:flutter/material.dart';
import 'formulario.dart';

class CadastroClientePage extends StatelessWidget {
  void _abrirFormulario(BuildContext context, String tipoCliente) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormularioPage(tipoCliente: tipoCliente),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Cadastrar Cliente'),
        backgroundColor: Colors.green[900],
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              Icon(Icons.person_add_alt_1, size: 80, color: Colors.green[800]),
              SizedBox(height: 20),
              Text(
                'Bem-vindo ao cadastro de clientes!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[900],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Escolha o tipo de cliente que deseja cadastrar abaixo. Cada opção possui um formulário específico para agilizar o processo.',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),

              // Botão Agricultor
              ElevatedButton.icon(
                onPressed: () => _abrirFormulario(context, 'Agricultor'),
                icon: Icon(Icons.agriculture, color: Colors.white),
                label: Text('Agricultor', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800],
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 20),

              // Botão Assalariado
              ElevatedButton.icon(
                onPressed: () => _abrirFormulario(context, 'Assalariado'),
                icon: Icon(Icons.work, color: Colors.white),
                label: Text('Assalariado', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800],
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 20),

              // Botão Aposentado/Pensionista
              ElevatedButton.icon(
                onPressed: () =>
                    _abrirFormulario(context, 'Aposentado/Pensionista'),
                icon: Icon(Icons.elderly, color: Colors.white),
                label: Text('Aposentado/Pensionista', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800],
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 40),

              Text(
                'Após selecionar o tipo de cliente, você será direcionado para o formulário correspondente.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}