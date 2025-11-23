import 'package:flutter/material.dart';
import 'package:haqmate/features/review/viewmodel/review_view_model.dart';
import 'package:haqmate/features/review/widget/startInpute.dart';
import 'package:provider/provider.dart';

class WriteReviewSheet extends StatefulWidget {
  const WriteReviewSheet({Key? key}) : super(key: key);

  @override
  State<WriteReviewSheet> createState() => _WriteReviewSheetState();
}

class _WriteReviewSheetState extends State<WriteReviewSheet> {
  int _rating = 0;
  final _controller = TextEditingController();
  bool _submitting = false;
  String _author = 'You'; // in real app, use user profile

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.6;
    return Container(
      constraints: BoxConstraints(maxHeight: height),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Write a Review',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF7B4B27),
            ),
          ),
          const SizedBox(height: 14),
          const Text('Your Rating', style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 8),
          StarInput(
            value: _rating,
            onChanged: (v) => setState(() => _rating = v),
          ),
          const SizedBox(height: 12),
          const Text('Your Review', style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 8),
          Expanded(
            child: TextField(
              controller: _controller,
              maxLines: null,
              expands: true,
              decoration: InputDecoration(
                hintText: 'Share your experience with this product...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _submitting
                      ? null
                      : () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _submitting ? null : () => _submit(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD8B384),
                  ),
                  child: _submitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Submit Review'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    if (_rating == 0) {
      _showError('Please select a rating');
      return;
    }
    if (_controller.text.trim().isEmpty) {
      _showError('Please write your review');
      return;
    }

    setState(() => _submitting = true);
    final vm = context.read<ReviewViewModel>();
    try {
      await vm.submitReview(_author, _controller.text.trim(), _rating);
      Navigator.of(context).pop();
      // show success snackbar
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Review submitted')));
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
