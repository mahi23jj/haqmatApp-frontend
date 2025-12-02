import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:haqmate/core/constants.dart';
import 'package:haqmate/features/review/model/review_model.dart';
import 'package:haqmate/features/review/viewmodel/review_view_model.dart';
import 'package:haqmate/features/review/widget/startDisplay.dart';
import 'package:provider/provider.dart';

class ReviewsList extends StatelessWidget {
  ReviewsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ReviewViewModel>(context, listen: false);

    List<Review> reviewlist = vm.reviews!.reviews;

    if (vm.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.error != null) {
      return Center(child: Text('Error: ${vm.error}'));
    }

    if (reviewlist.isEmpty) {
      return const Center(child: Text('No reviews yet'));
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 20),
      itemBuilder: (ctx, index) {
        final r = reviewlist[index];
        return AnimatedReviewCard(review: r, index: index);
      },
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: reviewlist.length,
    );
  }
}

class AnimatedReviewCard extends StatefulWidget {
  final Review review;
  final int index;
  const AnimatedReviewCard({
    Key? key,
    required this.review,
    required this.index,
  }) : super(key: key);

  @override
  State<AnimatedReviewCard> createState() => _AnimatedReviewCardState();
}

class _AnimatedReviewCardState extends State<AnimatedReviewCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offset;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _offset = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _opacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Staggered animation
    Future.delayed(
      Duration(milliseconds: 80 * widget.index),
      () => _controller.forward(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.review;
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _offset,
        child: Card(
          color: const Color.fromARGB(255, 255, 255, 255),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      child: Text(r.author.isEmpty ? '?' : r.author[0]),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                r.author,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (r.verified) VerifiedBadge(),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatDate(r.date),
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    StarDisplay(value: r.rating),
                  ],
                ),
                const SizedBox(height: 10),
                Text(r.text),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.thumb_up_alt_outlined, size: 18),
                    ),
                    const SizedBox(width: 4),
                    const Text('Helpful', style: TextStyle(fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inDays >= 365)
      return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    if (diff.inDays >= 30) return '${d.month}-${d.day}-${d.year}';
    if (diff.inDays >= 7) return '${diff.inDays ~/ 7}w ago';
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    return 'just now';
  }
}

class VerifiedBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'Verified',
        style: TextStyle(color: Colors.green, fontSize: 12),
      ),
    );
  }
}
