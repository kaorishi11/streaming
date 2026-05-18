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

    videos = response
        .map<VideoModel>((e) => VideoModel.fromMap(e))
        .toList();

    setState(() {
      loading = false;
    });
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
            onPressed: () {
              context.go('/favoritos');
            },

            icon: const Icon(
              Icons.favorite,
              color: Colors.red,
            ),
          ),

          IconButton(
            onPressed: () {
              context.go('/perfil');
            },

            icon: const Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),

        ],
      ),

      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )

          : ListView(
              children: [

                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Mais Assistidos',
                    style: TextStyle(
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

                    itemCount: videos.length,

                    itemBuilder: (context, index) {

                      final video = videos[index];

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

              ],
            ),
    );
  }
}