import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../atoms/custom_button.dart';
import '../molecules/login_field.dart';
import '../templates/login_template.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _loading = false;

  Future<void> _register() async {
    String nome = nomeController.text.trim();
    String cpf = cpfController.text.trim();
    String email = emailController.text.trim();
    String senha = senhaController.text.trim();

    if ([nome, cpf, email, senha].any((v) => v.isEmpty)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Preencha todos os campos.")));
      return;
    }

    setState(() => _loading = true);

    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      await _firestore.collection('usuarios').doc(cred.user!.uid).set({
        'nome': nome,
        'cpf': cpf,
        'email': email,
        'createdAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cadastro realizado com sucesso!")),
      );

      // Voltar à tela de login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginTemplate()),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'email-already-in-use') {
        message = 'Este email já está em uso.';
      } else if (e.code == 'weak-password') {
        message = 'A senha deve ter pelo menos 6 caracteres.';
      } else {
        message = 'Erro ao cadastrar. Tente novamente.';
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LoginField(controller: nomeController, label: "Nome completo"),
        LoginField(controller: cpfController, label: "CPF"),
        LoginField(controller: emailController, label: "Email"),
        LoginField(controller: senhaController, label: "Senha", isPassword: true),
        const SizedBox(height: 20),
        _loading
            ? const CircularProgressIndicator()
            : CustomButton(text: "Cadastrar", onPressed: _register),
      ],
    );
  }
}
