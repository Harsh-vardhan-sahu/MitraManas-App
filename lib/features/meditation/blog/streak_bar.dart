import 'dart:ui';
import 'package:flutter/material.dart';

class StreakProgressBar extends StatelessWidget {
  final int currentStreak;
  final int totalDays;

  const StreakProgressBar({
    Key? key,
    required this.currentStreak,
    this.totalDays = 7,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final displayStreak = currentStreak % totalDays == 0 && currentStreak != 0
        ? totalDays
        : currentStreak % totalDays;

    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(totalDays, (index) {
          final isFilled = index < displayStreak;

          return Transform(
            transform: Matrix4.skewX(-0.3),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: MediaQuery.of(context).size.width / (totalDays + 2.5),
              height: 40,
              decoration: BoxDecoration(
                gradient: isFilled
                    ? const LinearGradient(
                  colors: [Color(0xFFFFC107), Color(0xFFFF8F00)],
                )
                    : null,
                color: isFilled ? null : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                  isFilled ? Colors.amber.shade700 : Colors.grey.shade400,
                  width: 1.2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: isFilled ? 0 : 6,
                    sigmaY: isFilled ? 0 : 6,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isFilled
                            ? Colors.white
                            : Colors.black.withOpacity(0.4),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

}
