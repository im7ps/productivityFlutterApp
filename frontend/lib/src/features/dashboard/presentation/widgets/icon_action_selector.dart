import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/action_category_data.dart';

class IconActionSelector extends StatefulWidget {
  final String? selectedAction;
  final String? dimensionId;
  final ValueChanged<String> onSelected;

  const IconActionSelector({
    super.key,
    required this.selectedAction,
    this.dimensionId,
    required this.onSelected,
  });

  @override
  State<IconActionSelector> createState() => _IconActionSelectorState();
}

class _IconActionSelectorState extends State<IconActionSelector> {
  @override
  Widget build(BuildContext context) {
    // 1. Smart Filtering
    final actions = widget.dimensionId != null 
        ? ActionCategory.getByDimension(widget.dimensionId!) 
        : ActionCategory.values;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation),
            child: child,
          ),
        );
      },
      child: Wrap(
        // Key is crucial for AnimatedSwitcher to detect changes
        key: ValueKey<String>(widget.dimensionId ?? 'all'), 
        spacing: 16,
        runSpacing: 16,
        alignment: WrapAlignment.center,
        children: actions.map((category) {
          final isSelected = widget.selectedAction == category.label;
          
          return _AnimatedActionIcon(
            category: category,
            isSelected: isSelected,
            activeColor: _getDimensionColor(widget.dimensionId),
            onTap: () {
              HapticFeedback.selectionClick();
              widget.onSelected(category.label);
            },
          );
        }).toList(),
      ),
    );
  }

  Color _getDimensionColor(String? dimensionId) {
    if (dimensionId == null) return const Color(0xFF64FFDA);
    switch (dimensionId.toLowerCase()) {
      case 'energy': return const Color(0xFFE64A19);
      case 'clarity': return const Color(0xFF006064);
      case 'relationships': return const Color(0xFFFBC02D);
      case 'soul': return const Color(0xFF6A1B9A);
      default: return const Color(0xFF64FFDA);
    }
  }
}

class _AnimatedActionIcon extends StatefulWidget {
  final ActionCategory category;
  final bool isSelected;
  final Color activeColor;
  final VoidCallback onTap;

  const _AnimatedActionIcon({
    required this.category,
    required this.isSelected,
    required this.activeColor,
    required this.onTap,
  });

  @override
  State<_AnimatedActionIcon> createState() => _AnimatedActionIconState();
}

class _AnimatedActionIconState extends State<_AnimatedActionIcon> with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -8.0).chain(CurveTween(curve: Curves.easeOut)), weight: 50),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 0.0).chain(CurveTween(curve: Curves.bounceOut)), weight: 50),
    ]).animate(_bounceController);
  }

  @override
  void didUpdateWidget(covariant _AnimatedActionIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _bounceController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Semantics(
      label: "Seleziona attività: ${widget.category.label}",
      button: true,
      selected: widget.isSelected,
      child: Tooltip(
        message: widget.category.label,
        waitDuration: const Duration(milliseconds: 500),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedBuilder(
            animation: _bounceAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _bounceAnimation.value),
                child: child,
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.isSelected
                    ? widget.activeColor.withValues(alpha: 0.2)
                    : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05)),
                border: Border.all(
                  color: widget.isSelected ? widget.activeColor : Colors.transparent,
                  width: 2,
                ),
                boxShadow: widget.isSelected
                    ? [
                        BoxShadow(
                          color: widget.activeColor.withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : [],
              ),
              child: Icon(
                widget.category.icon,
                color: widget.isSelected
                    ? widget.activeColor
                    : (isDark ? Colors.white70 : Colors.black54),
                size: 28,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
