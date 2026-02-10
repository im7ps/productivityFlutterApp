import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VisualFulfillmentSelector extends StatelessWidget {
  final int value; // 1 to 5
  final ValueChanged<int> onChanged;
  final Color activeColor;
  final bool isSubmitting;
  final IconData? icon;

  const VisualFulfillmentSelector({
    super.key,
    required this.value,
    required this.onChanged,
    required this.activeColor,
    this.isSubmitting = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(5, (index) {
        final step = index + 1;
        final isSelected = step <= value;
        final isCurrent = step == value;
        
        final double baseSize = 16.0 + (index * 8.0);
        final double scale = isCurrent && isSubmitting ? 1.3 : 1.0;

        return Semantics(
          label: "Livello $step di 5",
          selected: isCurrent,
          button: true,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (_) {
              if (!isSubmitting) {
                _triggerHaptic(step);
                onChanged(step);
              }
            },
            child: Container(
              width: 50, 
              alignment: Alignment.center,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 1.0, end: scale),
                duration: const Duration(milliseconds: 400),
                curve: Curves.elasticOut,
                builder: (context, scaleValue, child) {
                  return Transform.scale(
                    scale: scaleValue,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutBack,
                      width: baseSize,
                      height: baseSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? activeColor.withValues(alpha: 0.4 + (index * 0.15))
                            : Colors.grey.withValues(alpha: 0.1),
                        boxShadow: [
                           // FIX: Provide a minimal safe shadow for unselected state to ensure
                           // valid interpolation. Using 0.0 blur can sometimes be optimized out
                           // or cause lerp issues if the other end is large.
                           // Using a tiny blur/spread instead of 0 prevents the assertion.
                           if (isSelected && (isCurrent || step == 5))
                              BoxShadow(
                                color: activeColor.withValues(alpha: 0.4),
                                blurRadius: (8.0 + (step * 3.0)).clamp(1.0, 50.0),
                                spreadRadius: (step.toDouble() * 0.5).clamp(0.0, 10.0),
                              )
                           else
                              BoxShadow(
                                color: Colors.transparent,
                                blurRadius: 1.0, // Safe non-zero value
                                spreadRadius: 0.0,
                              )
                        ],
                        border: Border.all(
                          color: isSelected ? activeColor : Colors.grey.withValues(alpha: 0.1),
                          width: isCurrent ? 2 : 1,
                        ),
                      ),
                      child: isCurrent && icon != null
                          ? Icon(
                              icon,
                              size: (baseSize * 0.6).clamp(0.0, 40.0),
                              color: Colors.white,
                            )
                          : null,
                    ),
                  );
                },
              ),
            ),
          ),
        );
      }),
    );
  }

  void _triggerHaptic(int step) {
    if (step <= 2) {
      HapticFeedback.lightImpact();
    } else if (step <= 4) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.heavyImpact();
      Future.delayed(const Duration(milliseconds: 80), () => HapticFeedback.lightImpact());
    }
  }
}
