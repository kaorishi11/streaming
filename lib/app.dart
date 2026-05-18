import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'pages/splash_page.dart';
import 'pages/login.dart';
import 'pages/cadastro.dart';
import 'pages/home_page.dart';
import 'pages/detalhes_page.dart';
import 'pages/favoritos_page.dart';
import 'pages/perfil.dart';

import 'models/video_model.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),

    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),

    GoRoute(
      path: '/cadastro',
      builder: (context, state) => const CadastroPage(),
    ),

    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),

    GoRoute(
      path: '/detalhes',
      builder: (context, state) {
        final video = state.extra;

        if (video is! VideoModel) {
          return const Scaffold(
            body: Center(
              child: Text('Vídeo não encontrado'),
            ),
          );
        }

        return DetalhesPage(video: video);
      },
    ),

    GoRoute(
      path: '/favoritos',
      builder: (context, state) => const FavoritosPage(),
    ),

    GoRoute(
      path: '/perfil',
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}