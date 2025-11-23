class Review {
  final String id;
  final String author;
  final String text;
  final int rating; // 1..5
  final DateTime date;
  final bool verified;

  Review({
    required this.id,
    required this.author,
    required this.text,
    required this.rating,
    required this.date,
    this.verified = false,
  });
}
