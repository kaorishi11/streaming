import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HistoricoPage extends StatefulWidget {
  const HistoricoPage({super.key});

  @override
  State<HistoricoPage> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {

  final supabase = Supabase.instance.client;

  List historico = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();

    buscarHistorico();
  }

  Future<void> buscarHistorico() async {

    final user = supabase.auth.currentUser;

    final response = await supabase
        .from('historico')
        .select('''
          id,
          assistido_em,
          videos (
            id,
            titulo,
            categoria,
            capa_url
          )
        ''')
        .eq('usuario_id', user!.id)
        .order('assistido_em', ascending: false);

    setState(() {

      historico = response;
      loading = false;

    });
  }

  Future<void> removerHistorico(int id) async {

    await supabase
        .from('historico')
        .delete()
        .eq('id', id);

    buscarHistorico();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,

        title: const Text(
          'Histórico',
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: loading

          ? const Center(
              child: CircularProgressIndicator(),
            )

          : historico.isEmpty

              ? const Center(
                  child: Text(
                    'Nenhum vídeo assistido',
                    style: TextStyle(color: Colors.white),
                  ),
                )

              : ListView.builder(

                  itemCount: historico.length,

                  itemBuilder: (context, index) {

                    final item = historico[index];
                    final video = item['videos'];

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

                            removerHistorico(item['id']);
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