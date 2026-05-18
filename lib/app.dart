import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'pages/splash_page.dart';
import 'pages/login.dart';
import 'pages/cadastro.dart';
import 'pages/home_page.dart';
import 'pages/detalhes_page.dart';
import 'pages/favoritos_page.dart';
import 'pages/historico_page.dart';

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
        final video = state.extra as VideoModel;
        return DetalhesPage(video: video);
      },
    ),

    GoRoute(
      path: '/favoritos',
      builder: (context, state) => const FavoritosPage(),
    ),
    
    GoRoute(
      path: '/historico',
      builder: (context, state) => const HistoricoPage(),
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