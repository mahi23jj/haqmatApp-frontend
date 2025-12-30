class Review {
  final String id;
  final String productid;
  final String author;
  final String text;
  final int rating; // 1..5
  final DateTime date;
  final bool verified;

  Review({
    required this.id,
    required this.productid,
    required this.author,
    required this.text,
    required this.rating,
    required this.date,
    this.verified = false,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? "",
      productid: json['productid'] ?? "",
      author: json['user']['name'] ?? "",
      text: json['message'] ?? "",
      rating: json['rating'] ?? 0,
      date: DateTime.parse(json['submittedAt']) ?? DateTime.now(),
    );
  }
}

class ReviewList {
  final List<Review> reviews;
  final int totalCount;
  final double averageRating;

  ReviewList({
    required this.reviews,
    required this.totalCount,
    required this.averageRating,
  });

  factory ReviewList.fromJson(Map<String, dynamic> json) {
    return ReviewList(
      reviews: (json['feedback'] as List<dynamic>? ?? [])
          .map((e) => Review.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: json['totalRatings'] ?? 0,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /* factory ReviewList.fromJson(List<dynamic> jsonList) {
    List<Review> reviews = jsonList
        .map((json) => Review.fromJson(json as Map<String, dynamic>))
        .toList();
    return ReviewList(reviews: reviews , );
  } */
}

// (property) feedbacks: {
//     message: string | null;
//     id: string;
//     productid: string;
//     rating: number | null;
//     submittedAt: Date | null;
//     user: {
//         name: string;
//         id: string;
//     };
// }[]
