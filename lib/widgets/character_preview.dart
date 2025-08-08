import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pokedex/models/character.dart';
import 'package:pokedex/core/theme/app_colors.dart';

class CharacterPreview extends StatelessWidget {
  final Character? selectedCharacter;

  const CharacterPreview({
    Key? key,
    this.selectedCharacter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 2, right: 2, bottom: 12),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.borderDark,
          width: 1,
        ),
      ),
      child: selectedCharacter != null
          ? Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: _buildImage(),
                ),
                _buildButton(context),
              ],
            )
          : _buildEmptyState(),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 200,
          child: CachedNetworkImage(
            imageUrl: selectedCharacter!.image,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: AppColors.primary,
            ),
            errorWidget: (context, url, error) => Container(
              color: AppColors.primary,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primary.withOpacity(0.9),
                AppColors.primary,
              ],
            ),
          ),
        ),
        // Conteúdo
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.textOnPrimary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '#${selectedCharacter!.id.toString().padLeft(3, '0')}',
                    style: const TextStyle(
                      color: AppColors.textOnPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                selectedCharacter!.name,
                style: const TextStyle(
                  color: AppColors.textOnPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImage() {
    return Container(
      width: double.infinity,
      color: AppColors.secondaryLight,
      child: CachedNetworkImage(
        imageUrl: selectedCharacter!.image,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        placeholder: (context, url) => Container(
          color: AppColors.secondaryLight,
          child: const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 2,
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: AppColors.secondaryLight,
          child: Icon(
            Icons.person_outline,
            color: AppColors.textSecondary,
            size: 48,
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: ElevatedButton(
        onPressed: () {
          context.go('/character/${selectedCharacter!.id}');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline,
              size: 18,
            ),
            SizedBox(width: 8),
            Text(
              'View Details',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.secondaryLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.person_outline,
              color: AppColors.textSecondary,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Select a character',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'Choose a character from the list\nto see details',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
