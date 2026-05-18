import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavoritosPage extends StatefulWidget {
  const FavoritosPage({super.key});

  @override
  State<FavoritosPage> createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> {

  final supabase = Supabase.instance.client;

  List favoritos = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();

    buscarFavoritos();
  }

  Future<void> buscarFavoritos() async {

    final user = supabase.auth.currentUser;

    final response = await supabase
        .from('favoritos')
        .select('''
          id,
          videos (
            id,
            titulo,
            descricao,
            categoria,
            capa_url
          )
        ''')
        .eq('usuario_id', user!.id);

    setState(() {

      favoritos = response;
      loading = false;

    });
  }

  Future<void> removerFavorito(int id) async {

    await supabase
        .from('favoritos')
        .delete()
        .eq('id', id);

    buscarFavoritos();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,

        title: const Text(
          'Favoritos',
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: loading

          ? const Center(
              child: CircularProgressIndicator(),
            )

          : favoritos.isEmpty

              ? const Center(
                  child: Text(
                    'Nenhum favorito',
                    style: TextStyle(color: Colors.white),
                  ),
                )

              : ListView.builder(

                  itemCount: favoritos.length,

                  itemBuilder: (context, index) {

                    final favorito = favoritos[index];
                    final video = favorito['videos'];

                    return Card(
                      color: Colors.grey[900],
                      margin: const EdgeInsets.all(10),

                      child: ListTile(

                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),

                          child: Image.network(
                            video['capa_url'],
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                        ),

                        title: Text(
                          video['titulo'],

                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),

                        subtitle: Text(
                          video['categoria'],

                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),

                        trailing: IconButton(

                          onPressed: () {

                            removerFavorito(favorito['id']);
                          },

                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}