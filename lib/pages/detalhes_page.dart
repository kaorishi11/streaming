import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/video_model.dart';
import 'video_player_page.dart';  // Importar a nova página

class DetalhesPage extends StatelessWidget {
  final VideoModel video;

  const DetalhesPage({
    super.key,
    required this.video,
  });

  Future<void> favoritar() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    try {
      // Verificar se já está favoritado
      final existing = await Supabase.instance.client
          .from('favoritos')
          .select()
          .eq('usuario_id', user.id)
          .eq('video_id', video.id)
          .maybeSingle();

      if (existing == null) {
        await Supabase.instance.client
            .from('favoritos')
            .insert({
              'usuario_id': user.id,
              'video_id': video.id,
            });
      } else {
        // Se já estiver favoritado, remover dos favoritos
        await Supabase.instance.client
            .from('favoritos')
            .delete()
            .eq('usuario_id', user.id)
            .eq('video_id', video.id);
      }
    } catch (e) {
      print('Erro ao favoritar: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.network(
                video.capaUrl,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.titulo,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    video.categoria,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    video.descricao,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () async {
                        try {
                          await favoritar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Favoritos atualizado'),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Erro ao favoritar'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.favorite),
                      label: const Text('Favoritar'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () {
                        // Navegar para a página do player
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoPlayerPage(video: video),
                          ),
                        );
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Assistir Agora'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}