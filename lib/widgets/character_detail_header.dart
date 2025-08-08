import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pokedex/core/theme/app_colors.dart';
import 'package:pokedex/models/character.dart';

class CharacterDetailHeader extends StatelessWidget {
  final Character character;
  final VoidCallback onBackPressed;

  const CharacterDetailHeader({
    Key? key,
    required this.character,
    required this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        width: double.infinity,
        height: 400,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: character.image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 100,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.textPrimary.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Text(
                character.name,
                style: const TextStyle(
                  color: AppColors.rickWhite,
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top,
              left: 8,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_rounded,
                    color: AppColors.rickWhite),
                onPressed: onBackPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
