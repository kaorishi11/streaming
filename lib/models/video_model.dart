class VideoModel {

  final int id;
  final String titulo;
  final String descricao;
  final String categoria;
  final String capaUrl;

  VideoModel({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.categoria,
    required this.capaUrl,
  });

  factory VideoModel.fromMap(Map<String, dynamic> map) {

    return VideoModel(
      id: map['id'],
      titulo: map['titulo'],
      descricao: map['descricao'],
      categoria: map['categoria'],
      capaUrl: map['capa_url'],
    );
  }
}