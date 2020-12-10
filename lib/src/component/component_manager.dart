part of flame_ecs;

typedef ComponentBuilder<T> = T Function();

class ComponentPool<T extends Component> extends ObjectPool<T> {
  final ComponentBuilder<T> componentBuilder;

  ComponentPool(this.componentBuilder) : super();

  @override
  T builder() => componentBuilder();
}

class ComponentManager {
  final World world;

  final List<Type> components = [];

  final Map<Type, ComponentPool<Component>> _componentPool = {};

  ComponentManager(this.world);

  bool hasComponent<T extends Component>() {
    return components.contains(T);
  }

  void registerComponent<T extends Component>(T Function() builder) {
    if (components.contains(T)) {
      return;
    }

    components.add(T);
    _componentPool[T] = ComponentPool(builder);
  }

  ComponentPool getComponentPool(Type component) => _componentPool[component];

  stats() {
    final stats = Stats()..add('registered', components.length);
    _componentPool.forEach((key, value) {
        stats.add('$key', value.stats());
    });
    return stats;
  }
}
