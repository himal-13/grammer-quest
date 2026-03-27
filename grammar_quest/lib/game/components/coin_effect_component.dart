import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

class CoinEffectComponent extends PositionComponent {
  CoinEffectComponent({required Vector2 position}) : super(position: position, size: Vector2.all(24));

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    final coin = CircleComponent(
      radius: 12,
      paint: Paint()..color = Colors.amber,
    );
    add(coin);

    // Add move effect
    add(
      MoveEffect.to(
        Vector2(position.x, position.y - 100),
        EffectController(duration: 1.0, curve: Curves.easeOut),
        onComplete: () => removeFromParent(),
      ),
    );
    
    // Add opacity effect
    add(
      OpacityEffect.fadeOut(
        EffectController(duration: 1.0, curve: Curves.easeIn),
      ),
    );
  }
}
