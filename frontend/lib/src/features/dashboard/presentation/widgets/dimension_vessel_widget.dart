import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DimensionVesselWidget extends StatelessWidget {
  final String dimensionId;
  final double fillLevel; // 0.0 to 1.0
  final IconData icon;
  final VoidCallback? onTap;

  const DimensionVesselWidget({
    super.key,
    required this.dimensionId,
    required this.fillLevel,
    required this.icon,
    this.onTap,
  });

  LinearGradient _getGradient(String id, double level) {
    // Increase saturation/brightness slightly with level if needed, 
    // but here we stick to the core colors and let the container's opacity/glow do the work.
    switch (id.toLowerCase()) {
      case 'energy':
        return const LinearGradient(
          colors: [Color(0xFFFFA726), Color(0xFFE64A19)], // Orange -> Red
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'clarity':
        return const LinearGradient(
          colors: [Color(0xFF26C6DA), Color(0xFF006064)], // Cyan -> Blue
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'relationships':
        return const LinearGradient(
          colors: [Color(0xFFFFEE58), Color(0xFFFBC02D)], // Amber -> Yellow
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'soul':
        return const LinearGradient(
          colors: [Color(0xFFAB47BC), Color(0xFF6A1B9A)], // Purple -> Violet
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      default:
        return const LinearGradient(
          colors: [Colors.grey, Colors.blueGrey],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
    }
  }

  Color _getMainColor(String id) {
     switch (id.toLowerCase()) {
      case 'energy': return const Color(0xFFE64A19);
      case 'clarity': return const Color(0xFF006064);
      case 'relationships': return const Color(0xFFFBC02D);
      case 'soul': return const Color(0xFF6A1B9A);
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradient = _getGradient(dimensionId, fillLevel);
    final mainColor = _getMainColor(dimensionId);
    
    // Dynamic Glow Logic
    final bool isFull = fillLevel >= 0.8;
    final double glowOpacity = fillLevel * 0.5; // Max 0.5 opacity for glow

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap?.call();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // The Vessel
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: 160,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.black12, 
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: mainColor.withValues(alpha: 0.3 + (fillLevel * 0.4)), // Border gets stronger
                width: 2,
              ),
              boxShadow: [
                // Inner glow simulation or outer glow based on level
                if (fillLevel > 0.1)
                  BoxShadow(
                    color: mainColor.withValues(alpha: glowOpacity),
                    blurRadius: 10 + (fillLevel * 10), // Blur increases with level
                    spreadRadius: isFull ? 2 : 0,
                  )
              ],
            ),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // Empty State Icon (Always visible, faint)
                Center(
                   child: Icon(
                    icon,
                    color: mainColor.withValues(alpha: 0.15),
                    size: 28,
                  ),
                ),

                // Fluid Fill Animation
                ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: fillLevel),
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.elasticOut,
                    builder: (context, value, child) {
                      return FractionallySizedBox(
                        heightFactor: value.clamp(0.0, 1.0),
                        widthFactor: 1.0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: gradient,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // Overlay Icon (Visible when filled enough to provide contrast, or simply sits on top)
                // We keep the main icon centered in background for empty state, 
                // but maybe we want a white icon floating on top of the liquid?
                // Let's keep it simple: The filled liquid covers the background icon.
                // We can add a white icon at the bottom if we want, but the prompt asked for 
                // "Empty States: show icon with low opacity". 
                // If I put another icon on top of the liquid, it might double up.
                // Let's just use the background icon for empty state. 
                // And maybe a white icon that only appears/moves with the liquid?
                // For now, the background icon covers the "Empty State" requirement.
                
                // If the liquid is high enough, we might want to show the icon in white for contrast.
                // Let's stick to the prompt: "maintain visual identity even when empty".
                // The background icon does this. 
              ],
            ),
          ),
        ],
      ),
    );
  }
}
