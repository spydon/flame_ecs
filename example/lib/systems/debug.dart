import 'dart:ui';

import 'package:example/components/position.dart';
import 'package:example/components/renderable.dart';
import 'package:example/components/shape.dart';
import 'package:flame/anchor.dart';
import 'package:flame/extensions/vector2.dart';
import 'package:flame/text_config.dart';
import 'package:flame_ecs/flame_ecs.dart';
import 'package:flutter/material.dart';

class Debug extends System with RenderSystem {
  final textConfig = TextConfig(
    fontSize: 8,
    color: Colors.green,
  );

  Query renderableQuery;

  @override
  void init() {
    renderableQuery = createQuery([HasComponent<Renderable>()]);
  }

  @override
  void render(Canvas canvas) {
    for (final entity in renderableQuery.entities) {
      final position = entity.getComponent<Position>();

      textConfig.render(
        canvas,
        entity.stats().toString(),
        Vector2(position.x, position.y + SHAPE_FULL),
        anchor: Anchor.topLeft,
      );

      canvas.drawRect(
        Rect.fromLTWH(position.x, position.y, SHAPE_FULL, SHAPE_FULL),
        Paint()
          ..color = Colors.green
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }
  }
}
