part of flame_ecs;

abstract class ECSGame extends Game {
  World world;

  Entity player;

  ECSGame() {
    world = World();
    init();
    world.init();
  }

  void init();

  @override
  @mustCallSuper
  void render(Canvas canvas) => world.render(canvas);

  @override
  @mustCallSuper
  void update(double delta) => world.update(delta);
}
