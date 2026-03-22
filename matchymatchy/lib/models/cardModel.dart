// card model to represent each card in the game
class CardModel {
  final int id;
  final String imagePath;
  bool isFaceUp;
  bool isMatched;

  CardModel({
    required this.id,
    required this.imagePath,
    this.isFaceUp = false,
    this.isMatched = false,
  });
}