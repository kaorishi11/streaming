// pages/video_player_page.dart
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/video_model.dart';

class VideoPlayerPage extends StatefulWidget {
  final VideoModel video;

  const VideoPlayerPage({
    super.key,
    required this.video,
  });

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late YoutubePlayerController _controller;
  bool _isVideoStarted = false;

  @override
  void initState() {
    super.initState();
    
    // Extrair o ID do vídeo do YouTube da URL
    final videoId = _extractVideoId(widget.video.videoUrl);
    
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        loop: false,
        isLive: false,
      ),
    );
    
    // Adicionar listener para detectar quando o vídeo começar
    _controller.addListener(() {
      if (!_isVideoStarted && _controller.value.isPlaying) {
        _isVideoStarted = true;
        _salvarNoHistorico();
      }
    });
  }
  
  String _extractVideoId(String url) {
    // Para URLs do tipo: https://youtu.be/ymYAuexz8GE?si=...
    if (url.contains('youtu.be')) {
      final uri = Uri.parse(url);
      return uri.pathSegments.first;
    }
    // Para URLs do tipo: https://youtube.com/watch?v=...
    else if (url.contains('watch?v=')) {
      final uri = Uri.parse(url);
      return uri.queryParameters['v'] ?? '';
    }
    return '';
  }
  
  Future<void> _salvarNoHistorico() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;
      
      // Verificar se já existe no histórico
      final existing = await Supabase.instance.client
          .from('historico')
          .select()
          .eq('usuario_id', user.id)
          .eq('video_id', widget.video.id)
          .maybeSingle();
      
      if (existing == null) {
        // Salvar no histórico apenas se não existir
        await Supabase.instance.client
            .from('historico')
            .insert({
              'usuario_id': user.id,
              'video_id': widget.video.id,
            });
      }
    } catch (e) {
      print('Erro ao salvar histórico: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.video.titulo,
          style: const TextStyle(color: Colors.white),
          overflow: TextOverflow.ellipsis,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Player do YouTube
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.red,
            progressColors: const ProgressBarColors(
              playedColor: Colors.red,
              handleColor: Colors.red,
            ),
          ),
          
          // Informações do vídeo
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.video.titulo,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.video.categoria,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.video.descricao,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}