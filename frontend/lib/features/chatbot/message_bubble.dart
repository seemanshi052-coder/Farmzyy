import 'package:flutter/material.dart';
import '../../config/theme.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final double? confidenceScore;
  final List<String>? suggestedActions;

  const MessageBubble({
    super.key,
    required this.text,
    required this.isUser,
    this.confidenceScore,
    this.suggestedActions,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isUser ? Colors.green[700] : Colors.grey[100];
    final align = isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final textColor = isUser ? Colors.white : Colors.black87;

    return Column(
      crossAxisAlignment: align,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 6.0),
          padding: const EdgeInsets.all(AppTheme.paddingMedium),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: textColor,
                    ),
              ),
              if (!isUser && confidenceScore != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Confidence: ',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '${(confidenceScore! * 100).toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ],
              if (!isUser && suggestedActions != null && suggestedActions!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: suggestedActions!.map((action) {
                    return Chip(
                      backgroundColor: Colors.white,
                      label: Text(action),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
