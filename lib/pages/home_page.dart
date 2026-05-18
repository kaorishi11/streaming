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
  String searchQuery = '';
  String selectedCategory = 'Tudo';

  final List<String> categories = [
    'Tudo',
    'Tecnologia',
    'Ciência',
    'Matemática',
    'História',
    'Negócios'
  ];

  @override
  void initState() {
    super.initState();
    buscarVideos();
  }

  Future<void> buscarVideos() async {
    final response = await supabase.from('videos').select();
    videos = (response as List)
        .map((e) => VideoModel.fromMap(e))
        .toList();
    setState(() => loading = false);
  }

  List<VideoModel> get filteredVideos {
    var filtered = videos;

    if (selectedCategory != 'Tudo') {
      filtered =
          filtered.where((v) => v.categoria == selectedCategory).toList();
    }

    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((v) =>
          v.titulo.toLowerCase().contains(searchQuery.toLowerCase()) ||
          v.descricao.toLowerCase().contains(searchQuery.toLowerCase())).toList();
    }

    return filtered;
  }

  Widget _buildVideoCard(VideoModel video) {
    return GestureDetector(
      onTap: () => context.go('/detalhes', extra: video),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Stack(
                children: [
                  Image.network(
                    video.capaUrl,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.play_arrow,
                              size: 12, color: Colors.white),
                          SizedBox(width: 2),
                          Text(
                            'Assistir',
                            style: TextStyle(
                                color: Colors.white, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.titulo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      video.categoria,
                      style: const TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 10,
                      ),
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

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        color: const Color(0xFF1A1A1A),
        child: ListView(
          children: [
            const DrawerHeader(
              child: Icon(Icons.person,
                  size: 60, color: Colors.white),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.white),
              title: const Text('Início',
                  style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.history,
                  color: Colors.white),
              title: const Text('Histórico',
                  style: TextStyle(color: Colors.white)),
              onTap: () => context.go('/historico'),
            ),
            ListTile(
              leading: const Icon(Icons.favorite,
                  color: Colors.white),
              title: const Text('Favoritos',
                  style: TextStyle(color: Colors.white)),
              onTap: () => context.go('/favoritos'),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Sair',
                  style: TextStyle(color: Colors.red)),
              onTap: () async {
                await supabase.auth.signOut();
                if (context.mounted) context.go('/login');
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      drawer: _buildDrawer(),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () =>
                Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Image.asset(
          'assets/logo2.png',
          height: 65,
          fit: BoxFit.contain,
        ),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SizedBox(
                  height: 45,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      final selected = cat == selectedCategory;

                      return GestureDetector(
                        onTap: () => setState(
                            () => selectedCategory = cat),
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: selected
                                ? Colors.blue
                                : const Color(0xFF1E1E1E),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            cat,
                            style: TextStyle(
                              color: selected
                                  ? Colors.white
                                  : Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.95,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: filteredVideos.length,
                      itemBuilder: (context, index) {
                        return _buildVideoCard(
                            filteredVideos[index]);
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}