// diifficulty configurations for the game

enum GameDifficulty { easy, medium, hard }

extension GameDifficultyLabel on GameDifficulty {
  String get label {
    switch (this) {
      case GameDifficulty.easy:
        return 'EASY';
      case GameDifficulty.medium:
        return 'MEDIUM';
      case GameDifficulty.hard:
        return 'HARD';
    }
  }
}

// assets per difficulty

const List<String> easyAssets = [
  'assets/cards/sir-nikko.png',
  'assets/cards/sir-pan.png',
  'assets/cards/sir-vic.png',
];

const List<String> mediumAssets = [
  'assets/cards/sir-nikko.png',
  'assets/cards/sir-pan.png',
  'assets/cards/sir-vic.png',
  'assets/cards/neyro.png',
  'assets/cards/cedric.png',
  'assets/cards/clyde.png',
];

const List<String> hardAssets = [
  'assets/cards/angel.png',
  'assets/cards/jave.png',
  'assets/cards/hernia.png',
  'assets/cards/neyro.png',
  'assets/cards/cedric.png',
  'assets/cards/clyde.png',
  'assets/cards/keith.png',
  'assets/cards/kent.png',
];

// difficulty configuration class

class DifficultyConfig {
  final int pairs;
  final int seconds;
  final int crossAxisCount;
  final double childAspectRatio;
  final List<String> assets;

  const DifficultyConfig({
    required this.pairs,
    required this.seconds,
    required this.crossAxisCount,
    required this.childAspectRatio,
    required this.assets,
  });

  int get totalCards => pairs * 2;

  // factory constructor to get config based on difficulty
  factory DifficultyConfig.of(GameDifficulty d) {
    switch (d) {
      case GameDifficulty.easy:
        return const DifficultyConfig(
          pairs: 3,
          seconds: 50,
          crossAxisCount: 3,
          childAspectRatio: 0.68,
          assets: easyAssets,
        );
      case GameDifficulty.medium:
        return const DifficultyConfig(
          pairs: 6,
          seconds: 30,
          crossAxisCount: 4,
          childAspectRatio: 0.72,
          assets: mediumAssets,
        );
      case GameDifficulty.hard:
        return const DifficultyConfig(
          pairs: 8,
          seconds: 20,
          crossAxisCount: 4,
          childAspectRatio: 0.72,
          assets: hardAssets,
        );
    }
  }
}
