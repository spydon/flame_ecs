import 'package:example/components/position.dart';
import 'package:example/components/shape.dart';
import 'package:example/components/velocity.dart';
import 'package:flame_ecs/flame_ecs.dart';

class Moveable extends System with UpdateSystem {
  Query moveableQuery;

  @override
  void init() {
    moveableQuery = createQuery([
      HasComponent<Position>(),
      HasComponent<Velocity>(),
    ]);
  }

  @override
  void update(double delta) {
    for (final entity in moveableQuery.entities) {
      final velocity = entity.getComponent<Velocity>();
      final position = entity.getComponent<Position>();

      position.x += velocity.x * delta;
      position.y += velocity.y * delta;

      if (position.x > 360 + SHAPE_HALF) position.x = -SHAPE_HALF;
      if (position.x < -SHAPE_HALF) position.x = 360 + SHAPE_HALF;
      if (position.y > 640 + SHAPE_HALF) position.y = -SHAPE_HALF;
      if (position.y < -SHAPE_HALF) position.y = 640 + SHAPE_HALF;
    }
  }
}
