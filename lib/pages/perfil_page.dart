import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    final userEmail = user?.email ?? 'Sem e-mail';

    return Scaffold(
      backgroundColor: Colors.black, // Fundo preto
      appBar: AppBar(
        title: const Text(
          'Perfil',
          style: TextStyle(color: Colors.white), // Texto branco
        ),
        backgroundColor: Colors.black, // AppBar preta
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white), // Ícone de voltar branco
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey, // Fundo cinza para contraste
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.white, // Ícone branco
                ),
              ),
              const SizedBox(height: 24),
              Card(
                color: Colors.grey[900], // Card cinza escuro
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        'Informações da Conta',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Texto branco
                        ),
                      ),
                      const Divider(
                        color: Colors.grey, // Divisor cinza
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.email,
                          color: Colors.white, // Ícone branco
                        ),
                        title: const Text(
                          'E-mail',
                          style: TextStyle(
                            color: Colors.grey, // Texto cinza claro
                          ),
                        ),
                        subtitle: Text(
                          userEmail,
                          style: const TextStyle(
                            color: Colors.white, // Texto branco
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await supabase.auth.signOut();
                          context.go('/login');
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text('Fazer Logout'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // Botão branco
                          foregroundColor: Colors.black, // Texto preto
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () {
                          context.go('/home');
                        },
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Voltar'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white, // Texto branco
                          side: const BorderSide(color: Colors.white), // Borda branca
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
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