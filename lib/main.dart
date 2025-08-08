import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/core/dependency_injection.dart';
import 'package:pokedex/core/router.dart';
import 'package:pokedex/core/theme/app_theme.dart';
import 'package:pokedex/view_models/characters_cubit.dart';
import 'package:pokedex/view_models/character_detail_cubit.dart';

void main() {
  setupDependencyInjection();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<CharactersCubit>()),
        BlocProvider(create: (_) => getIt<CharacterDetailCubit>()),
      ],
      child: MaterialApp.router(
        title: 'Rick and Morty App',
        debugShowCheckedModeBanner: false,
        locale: const Locale('pt'),
        theme: AppTheme.lightTheme,
        routerConfig: router,
      ),
    );
  }
}
