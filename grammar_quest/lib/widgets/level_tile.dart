import 'package:flutter/material.dart';

class LevelTile extends StatefulWidget {
  final int levelId;
  final bool isUnlocked;
  final bool isCompleted;
  final int stars;
  final bool isNext;
  final VoidCallback? onTap;

  const LevelTile({
    super.key,
    required this.levelId,
    required this.isUnlocked,
    required this.isCompleted,
    required this.stars,
    required this.isNext,
    this.onTap,
  });

  @override
  State<LevelTile> createState() => _LevelTileState();
}

class _LevelTileState extends State<LevelTile> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTapDown: widget.isUnlocked ? (_) => _controller.forward() : null,
      onTapUp: widget.isUnlocked ? (_) => _controller.reverse() : null,
      onTapCancel: widget.isUnlocked ? () => _controller.reverse() : null,
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: widget.isUnlocked ? theme.cardColor : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: widget.isNext 
              ? Border.all(color: theme.primaryColor, width: 3)
              : null,
            boxShadow: widget.isUnlocked 
              ? [
                BoxShadow(
                  color: (widget.isNext ? theme.primaryColor : Colors.black).withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ] 
              : null,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (!widget.isUnlocked)
                const Icon(Icons.lock_rounded, color: Colors.grey, size: 32)
              else
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${widget.levelId}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: widget.isNext ? theme.primaryColor : null,
                      ),
                    ),
                  ],
                ),
                
              if (widget.isNext)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
