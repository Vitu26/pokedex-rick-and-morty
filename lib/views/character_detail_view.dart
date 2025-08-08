import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pokedex/core/theme/app_colors.dart';
import 'package:pokedex/view_models/character_detail_cubit.dart';
import 'package:pokedex/view_models/character_detail_state.dart';
import 'package:pokedex/widgets/error_widget.dart';
import 'package:pokedex/widgets/character_detail_header.dart';
import 'package:pokedex/widgets/character_info_section.dart';

class CharacterDetailView extends StatefulWidget {
  final int characterId;

  const CharacterDetailView({
    super.key,
    required this.characterId,
  });

  @override
  State<CharacterDetailView> createState() => _CharacterDetailViewState();
}

class _CharacterDetailViewState extends State<CharacterDetailView> {
  @override
  void initState() {
    super.initState();
    _loadCharacterDetail();
  }

  void _loadCharacterDetail() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<CharacterDetailCubit>()
          .loadCharacterDetail(widget.characterId);
    });
  }

  void _onRetry() {
    context.read<CharacterDetailCubit>().retryLoading(widget.characterId);
  }

  void _onUseOfflineMode() {
    context.read<CharacterDetailCubit>().enableOfflineMode(widget.characterId);
  }

  void _onBackPressed() {
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.rickWhite,
      body: BlocBuilder<CharacterDetailCubit, CharacterDetailState>(
        builder: (context, state) {
          return _buildBody(state);
        },
      ),
    );
  }

  Widget _buildBody(CharacterDetailState state) {
    if (state is CharacterDetailLoading) {
      return _buildLoadingState();
    }

    if (state is CharacterDetailError) {
      return _buildErrorState(state);
    }

    if (state is CharacterDetailLoaded) {
      return _buildLoadedState(state);
    }

    return _buildEmptyState();
  }

  Widget _buildLoadingState() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.rickGray.withOpacity(0.1),
            AppColors.rickWhite,
          ],
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppColors.rickGreen,
              strokeWidth: 3,
            ),
            SizedBox(height: 16),
            Text(
              'Carregando detalhes do personagem',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(CharacterDetailError state) {
    return AppErrorWidget(
      error: state.error,
      onRetry: _onRetry,
      onUseOfflineMode: _onUseOfflineMode,
    );
  }

  Widget _buildLoadedState(CharacterDetailLoaded state) {
    final character = state.character;
    final cubit = context.read<CharacterDetailCubit>();

    return CustomScrollView(
      slivers: [
        CharacterDetailHeader(
          character: character,
          onBackPressed: _onBackPressed,
        ),
        _buildCharacterInfoSliver(character, cubit),
      ],
    );
  }

  Widget _buildCharacterInfoSliver(character, CharacterDetailCubit cubit) {
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.rickWhite,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Column(
            children: [
              _buildInfoSection('Status', character.status,
                  cubit.getStatusIcon(character.status)),
              const SizedBox(height: 16),
              _buildInfoSection(
                  'Species', character.species, Icons.pets_rounded),
              const SizedBox(height: 16),
              _buildInfoSection('Gender', character.gender,
                  cubit.getGenderIcon(character.gender)),
              const SizedBox(height: 16),
              _buildInfoSection(
                  'Origin',
                  cubit.formatOriginName(character.origin.name),
                  Icons.public_rounded),
              const SizedBox(height: 16),
              _buildInfoSection(
                  'Last known location',
                  cubit.formatLocationName(character.location.name),
                  Icons.location_on_rounded),
              const SizedBox(height: 16),
              _buildInfoSection(
                  'Episodes',
                  cubit.formatEpisodesCount(character.episode.length),
                  Icons.tv_rounded),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String value, IconData icon) {
    return CharacterInfoSection(
      title: title,
      value: value,
      icon: icon,
    );
  }

  Widget _buildEmptyState() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.rickGray.withOpacity(0.1),
            AppColors.rickWhite,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.rickGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.person_outline_rounded,
                color: AppColors.rickGreen,
                size: 50,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Personagem não encontrado',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tente novamente mais tarde',
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
