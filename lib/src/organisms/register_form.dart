import 'package:flutter/material.dart';
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

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _loading = false;

  Future<void> _register() async {
    String nome = nomeController.text.trim();
    String cpf = cpfController.text.trim();
    String email = emailController.text.trim();
    String senha = senhaController.text.trim();

    if ([nome, cpf, email, senha].any((v) => v.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos.")),
      );
      return;
    }

    if (senha.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("A senha deve ter pelo menos 6 caracteres."),
        ),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      // Verificar se já existe solicitação pendente com este email
      final existingSolicitation = await _firestore
          .collection('solicitacoes_cadastro')
          .where('email', isEqualTo: email)
          .where('status', isEqualTo: 'pendente')
          .get();

      if (existingSolicitation.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Já existe uma solicitação pendente com este email."),
          ),
        );
        setState(() => _loading = false);
        return;
      }

      // Criar solicitação de cadastro pendente
      await _firestore.collection('solicitacoes_cadastro').add({
        'nome': nome,
        'cpf': cpf,
        'email': email,
        'senha': senha, // Em produção, deveria ser hash da senha
        'status': 'pendente',
        'solicitadoEm': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Solicitação enviada! Aguarde aprovação do administrador.",
          ),
          duration: Duration(seconds: 4),
        ),
      );

      // Voltar à tela de login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginTemplate()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao enviar solicitação: $e")));
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
        LoginField(
          controller: senhaController,
          label: "Senha",
          isPassword: true,
        ),
        const SizedBox(height: 8),
        Text(
          'A senha deve ter pelo menos 6 caracteres',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 20),
        _loading
            ? const CircularProgressIndicator()
            : CustomButton(text: "Cadastrar", onPressed: _register),
      ],
    );
  }
}
