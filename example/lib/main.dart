import 'dart:math';

import 'package:example/components/position.dart';
import 'package:example/components/renderable.dart';
import 'package:example/components/shape.dart';
import 'package:example/components/velocity.dart';
import 'package:example/systems/debug.dart';
import 'package:example/systems/moveable.dart';
import 'package:example/systems/render.dart';
import 'package:flame/extensions/vector2.dart';
import 'package:flame/flame.dart';
import 'package:flame/fps_counter.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'
    show Canvas, Colors, WidgetsFlutterBinding, runApp;
import 'package:flame_ecs/flame_ecs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.util.fullScreen();
  final size = await Flame.util.initialDimensions();

  runApp(ExampleGame(size).widget);
}

ShapeInit randomShape() {
  return ShapeInit(primitive: Random().nextDouble() < 0.5 ? 'box' : 'circle');
}

PositionInit randomPosition(Vector2 within) {
  final rnd = Random();
  return PositionInit(
    x: rnd.nextDouble() * within.x,
    y: rnd.nextDouble() * within.y,
  );
}

VelocityInit randomVelocity([int maxVelocity = 5]) {
  final rnd = Random();
  return VelocityInit(
    x: maxVelocity * rnd.nextDouble() + 1,
    y: maxVelocity * rnd.nextDouble() + 1,
  );
}

class ExampleGame extends ECSGame with FPSCounter {
  final TextConfig textConfig = TextConfig(fontSize: 8, color: Colors.green);

  Vector2 screenSize;

  ExampleGame(this.screenSize) : super();

  void init() {
    world.registerSystem(Moveable());
    world.registerSystem(Render());
    world.registerComponent(() => Position());
    world.registerComponent(() => Velocity());
    world.registerComponent(() => Shape());
    world.registerComponent(() => Renderable());
    if (kDebugMode) world.registerSystem(Debug());

    for (var i = 0; i < 100; i++) {
      world.createEntity('entity_$i')
        ..addComponent<Position>(randomPosition(screenSize))
        ..addComponent<Velocity>(randomVelocity())
        ..addComponent<Shape>(randomShape())
        ..addComponent<Renderable>();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final rnd = Random();
    if (rnd.nextDouble() < 0.5 && world.entities.length != 0 || world.entities.length == 100) {
      world.entities.elementAt(0).remove();
    } else {
      world.createEntity()
        ..addComponent<Position>(randomPosition(screenSize))
        ..addComponent<Velocity>(randomVelocity())
        ..addComponent<Shape>(randomShape())
        ..addComponent<Renderable>();
    }
    final stats = Stats()
      ..add('fps', fps().toStringAsFixed(2))
      ..add('world', world.stats());

    textConfig.render(
      canvas,
      stats.toString(),
      Vector2(0, 0),
    );
  }
}
