import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/video_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final supabase = Supabase.instance.client;

  List<VideoModel> videos = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    buscarVideos();
  }

  Future<void> buscarVideos() async {

    final response = await supabase
        .from('videos')
        .select();

    videos = (response as List)
        .map((e) => VideoModel.fromMap(e))
        .toList();

    setState(() {
      loading = false;
    });
  }

  Widget buildCategoria(String titulo, List<VideoModel> lista) {

    if (lista.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            titulo,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        SizedBox(
          height: 250,

          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: lista.length,

            itemBuilder: (context, index) {

              final video = lista[index];

              return GestureDetector(
                onTap: () {
                  context.go(
                    '/detalhes',
                    extra: video,
                  );
                },

                child: Container(
                  width: 170,
                  margin: const EdgeInsets.only(left: 16),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),

                          child: Image.network(
                            video.capaUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        video.titulo,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                      ),

                      Text(
                        video.categoria,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),

                    ],
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,

        title: const Text(
          'StreamAcademy',
          style: TextStyle(color: Colors.white),
        ),

        actions: [

          IconButton(
            onPressed: () => context.go('/historico'),
            icon: const Icon(Icons.history, color: Colors.white),
          ),

          IconButton(
            onPressed: () => context.go('/favoritos'),
            icon: const Icon(Icons.favorite, color: Colors.red),
          ),

          IconButton(
            onPressed: () => context.go('/perfil'),
            icon: const Icon(Icons.person, color: Colors.white),
          ),
        ],
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())

          : ListView(

              children: [

                buildCategoria(
                  'Mais Assistidos',
                  videos,
                ),

                buildCategoria(
                  'Educação',
                  videos.where((v) => v.categoria == 'Educação').toList(),
                ),

                buildCategoria(
                  'Tecnologia',
                  videos.where((v) => v.categoria == 'Tecnologia').toList(),
                ),

                buildCategoria(
                  'Entretenimento',
                  videos.where((v) => v.categoria == 'Entretenimento').toList(),
                ),

              ],
            ),
    );
  }
}