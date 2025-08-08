import 'package:flutter/material.dart';
import 'package:pokedex/widgets/character_card.dart';
import 'package:pokedex/models/character.dart';
import 'package:pokedex/core/theme/app_colors.dart';

class CharacterList extends StatelessWidget {
  final List<Character> characters;
  final Character? selectedCharacter;
  final Function(Character) onCharacterSelected;
  final ScrollController scrollController;
  final bool isLoading;

  const CharacterList({
    Key? key,
    required this.characters,
    required this.selectedCharacter,
    required this.onCharacterSelected,
    required this.scrollController,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: AppColors.secondaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: characters.length + (isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == characters.length) {
              return Container(
                padding: const EdgeInsets.all(20),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 2,
                  ),
                ),
              );
            }

            final character = characters[index];
            final isSelected = selectedCharacter?.id == character.id;

            return CharacterCard(
              character: character,
              isSelected: isSelected,
              onTap: () => onCharacterSelected(character),
            );
          },
        ),
      ),
    );
  }
}
