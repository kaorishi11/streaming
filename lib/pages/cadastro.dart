import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  bool loading = false;
  bool obscurePassword = true;

  Future<void> cadastrar() async {
    try {
      setState(() {
        loading = true;
      });

      await Supabase.instance.client.auth.signUp(
        email: emailController.text.trim(),
        password: senhaController.text.trim(),
      );

      if (mounted) {
        context.go('/');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black,
          content: Text('Erro: $e'),
        ),
      );
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Widget campo({
    required String titulo,
    required TextEditingController controller,
    required IconData icon,
    bool obscure = false,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            color: Color(0xFF777777),
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          obscureText: obscure,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                onPressed: () {
                  context.go('/');
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.grey,
                  size: 16,
                ),
                label: const Text(
                  'Voltar',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Título centralizado
              Center(
  child: Column(
    children: [
      Image.asset(
        'assets/logo.png',
        width: 250,
      ),

      const SizedBox(height: 12),

      const Text(
        'seu cinema pessoal',
        style: TextStyle(
          color: Color(0xFF777777),
          fontSize: 14,
          letterSpacing: 1,
        ),
      ),
    ],
  ),
),
              const SizedBox(height: 45),

              Center(
  child: Column(
    children: [
      const Text(
        'Criar conta',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),

      const SizedBox(height: 10),

      const Text(
        'Junte-se e organize seu mundo cinematográfico',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF777777),
          fontSize: 15,
        ),
      ),
    ],
  ),
),
              const SizedBox(height: 35),

              campo(
                titulo: 'NOME',
                controller: nomeController,
                icon: Icons.person_outline,
              ),

              const SizedBox(height: 20),

              campo(
                titulo: 'E-MAIL',
                controller: emailController,
                icon: Icons.email_outlined,
              ),

              const SizedBox(height: 20),

              campo(
                titulo: 'SENHA',
                controller: senhaController,
                icon: Icons.lock_outline,
                obscure: obscurePassword,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                ),
              ),

              const SizedBox(height: 35),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: loading ? null : cadastrar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 242, 246, 246),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: loading
                      ? const CircularProgressIndicator(
                          color: Colors.black,
                        )
                      : const Text(
                          'Cadastrar',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              const Center(
                child: Text(
                  'Ao continuar, você concorda com os\nTermos de Uso e Política de Privacidade',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromARGB(255, 74, 74, 74),
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: TextButton(
                  onPressed: () {
                    context.go('/');
                  },
                  child: const Text(
                    'Já tem conta? Entrar',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}