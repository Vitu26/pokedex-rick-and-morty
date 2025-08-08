import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/view_models/characters_cubit.dart';
import 'package:pokedex/view_models/characters_state.dart';
import 'package:pokedex/widgets/error_widget.dart';
import 'package:pokedex/widgets/app_header.dart';
import 'package:pokedex/widgets/character_list.dart';
import 'package:pokedex/widgets/character_preview.dart';
import 'package:pokedex/models/character.dart';
import 'package:pokedex/core/theme/app_colors.dart';

class CharactersListView extends StatefulWidget {
  const CharactersListView({super.key});

  @override
  State<CharactersListView> createState() => _CharactersListViewState();
}

class _CharactersListViewState extends State<CharactersListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeData();
    _setupScrollListener();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CharactersCubit>().loadCharacters();
    });
  }

  void _setupScrollListener() {
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;
      context
          .read<CharactersCubit>()
          .checkScrollPosition(currentScroll, maxScroll);
    }
  }

  void _onCharacterSelected(Character character) {
    context.read<CharactersCubit>().selectCharacter(character);
  }

  Future<void> _onRefresh() async {
    context.read<CharactersCubit>().loadCharacters(refresh: true);
  }

  void _onRetry() {
    context.read<CharactersCubit>().retryLoading();
  }

  void _onUseOfflineMode() {
    context.read<CharactersCubit>().enableOfflineMode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryLight,
      body: BlocBuilder<CharactersCubit, CharactersState>(
        builder: (context, state) {
          return _buildBody(state);
        },
      ),
    );
  }

  Widget _buildBody(CharactersState state) {
    if (state is CharactersLoading && state is! CharactersLoaded) {
      return _buildLoadingState();
    }

    if (state is CharactersError) {
      return _buildErrorState(state);
    }

    if (state is CharactersLoaded) {
      return _buildLoadedState(state);
    }

    return _buildEmptyState();
  }

  Widget _buildLoadingState() {
    return Container(
      color: AppColors.secondaryLight,
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
              'Loading characters...',
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

  Widget _buildErrorState(CharactersError state) {
    return AppErrorWidget(
      error: state.error,
      onRetry: _onRetry,
      onUseOfflineMode: _onUseOfflineMode,
    );
  }

  Widget _buildLoadedState(CharactersLoaded state) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;

        return Column(
          children: [
            const AppHeader(),
            Expanded(
              child: _buildResponsiveLayout(state, isSmallScreen),
            ),
          ],
        );
      },
    );
  }

  Widget _buildResponsiveLayout(CharactersLoaded state, bool isSmallScreen) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: isSmallScreen ? 2 : 1,
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            color: AppColors.rickGreen,
            child: CharacterList(
              characters: state.characters,
              selectedCharacter: state.selectedCharacter,
              onCharacterSelected: _onCharacterSelected,
              scrollController: _scrollController,
              isLoading: state.isLoadingMore,
            ),
          ),
        ),
        Expanded(
          flex: isSmallScreen ? 3 : 2,
          child: CharacterPreview(
            selectedCharacter: state.selectedCharacter,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      color: AppColors.secondaryLight,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.rickGray,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.people_outline,
                color: AppColors.textLight,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No characters found',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try again later',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
