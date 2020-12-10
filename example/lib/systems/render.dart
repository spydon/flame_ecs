import 'dart:ui';

import 'package:example/components/position.dart';
import 'package:example/components/renderable.dart';
import 'package:example/components/shape.dart';
import 'package:flame_ecs/flame_ecs.dart';
import 'package:flutter/material.dart';

class Render extends System with RenderSystem {
  Query renderableQuery;

  @override
  void init() {
    renderableQuery = createQuery([
      HasComponent<Renderable>(),
      HasComponent<Shape>(),
    ]);
  }

  @override
  void render(Canvas canvas) {
    for (final entity in renderableQuery.entities) {
      final shape = entity.getComponent<Shape>();
      final position = entity.getComponent<Position>();

      if (shape.primitive == 'box') {
        canvas.drawCircle(
          Offset(position.x + SHAPE_HALF, position.y + SHAPE_HALF),
          SHAPE_HALF,
          Paint()..color = Colors.red,
        );
      } else {
        canvas.drawRect(
          Rect.fromLTWH(position.x, position.y, SHAPE_FULL, SHAPE_FULL),
          Paint()..color = Colors.pink,
        );
      }
    }
  }
}
