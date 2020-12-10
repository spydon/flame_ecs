part of flame_ecs;

abstract class System {
  List<Entity> get entities => world.entities;

  World world;

  System();

  void init();

  Query createQuery(Iterable<Filter> filters) =>
      world.entityManager._queryManager.createQuery(filters);
}

mixin RenderSystem on System {
  void render(Canvas canvas);
}

mixin UpdateSystem on System {
  void update(double delta);
}
