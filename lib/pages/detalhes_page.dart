import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/video_model.dart';

class DetalhesPage extends StatelessWidget {

  final VideoModel video;

  const DetalhesPage({
    super.key,
    required this.video,
  });

  Future<void> favoritar() async {

    final user = Supabase.instance.client.auth.currentUser;

    await Supabase.instance.client
        .from('favoritos')
        .insert({
          'usuario_id': user!.id,
          'video_id': video.id,
        });
  }

  Future<void> assistir() async {

    final user = Supabase.instance.client.auth.currentUser;

    await Supabase.instance.client
        .from('historico')
        .insert({
          'usuario_id': user!.id,
          'video_id': video.id,
        });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
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

                        await favoritar();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Adicionado aos favoritos'),
                          ),
                        );
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

                      onPressed: () async {

                        await assistir();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Adicionado ao histórico'),
                          ),
                        );
                      },

                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Assistir'),
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