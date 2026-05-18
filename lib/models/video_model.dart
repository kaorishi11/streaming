class VideoModel {
  final int id;
  final String titulo;
  final String descricao;
  final String categoria;
  final String capaUrl;
  final String videoUrl;
  final DateTime criadoEm;

  VideoModel({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.categoria,
    required this.capaUrl,
    required this.videoUrl,
    required this.criadoEm,
  });

  factory VideoModel.fromMap(Map<String, dynamic> map) {
    return VideoModel(
      id: map['id'] as int,
      titulo: map['titulo'] as String,
      descricao: map['descricao'] as String,
      categoria: map['categoria'] as String,
      capaUrl: map['capa_url'] as String,
      videoUrl: map['video_url'] as String? ?? '', 
      criadoEm: DateTime.parse(map['criado_em'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'categoria': categoria,
      'capa_url': capaUrl,
      'video_url': videoUrl,
      'criado_em': criadoEm.toIso8601String(),
    };
  }
}