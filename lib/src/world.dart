part of flame_ecs;

class World {
  Iterable<Entity> get entities => entityManager._entities;

  final Set<System> systems = Set();

  EntityManager entityManager;

  ComponentManager componentManager;

  World() {
    entityManager = EntityManager(this);
    componentManager = ComponentManager(this);
  }

  @mustCallSuper
  void init() {
    for (final system in systems) {
      system.init();
    }
  }

  void registerSystem(System system) {
    // TODO Probably make a manager for this aswell.
    system.world = this;
    systems.add(system);
  }

  void registerComponent<T extends Component>(ComponentBuilder<T> builder) {
    componentManager.registerComponent(builder);
  }

  Entity createEntity([String name]) {
    return entityManager.createEntity(name);
  }

  void render(Canvas canvas) {
    for (final system in systems) {
      if (system is RenderSystem) {
        system.render(canvas);
      }
    }
  }

  void update(double delta) {
    for (final system in systems) {
      if (system is UpdateSystem) {
        system.update(delta);
      }
    }
  }

  Stats stats() => Stats()
    ..add('entities', entityManager.stats())
    ..add('components', componentManager.stats())
    ..add('system', systems.length);
}
