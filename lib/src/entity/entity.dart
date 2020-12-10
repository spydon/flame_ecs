part of flame_ecs;

class Entity extends PoolObject {
  final EntityManager _entityManager;

  final Map<Type, Component> _components = {};

  final Set<Type> _componentTypes = Set();

  int id;

  bool alive = false;

  String name;

  Entity(this._entityManager) : id = _entityManager._nextEntityId++;

  T getComponent<T extends Component>() {
    assert(T != Component, 'An implemented Component was expected');
    return _components[T];
  }

  void addComponent<T extends Component>([InitObject data]) {
    assert(T != Component, 'An implemented Component was expected');
    _entityManager.addComponentToEntity<T>(this, data);
  }

  void removeComponent<T extends Component>(T component) {
    assert(T != Component, 'An implemented Component was expected');
    _components.remove(component);
  }

  @override
  void reset() {
    id = _entityManager._nextEntityId++;
    _components.clear();
  }

  void remove() => _entityManager.removeEntity(this);

  @override
  String toString() =>
      'Entity { id: $id, name: $name components: $_components }';

  Stats stats([bool withComponents = false]) {
    final stats = Stats()..add('id', id)..add('name', name);

    if (withComponents) {
      final componentStats = Stats();
      for (final component in _components.values) {
        componentStats.add('${component.runtimeType}', component.stats());
      }
      stats.add('components', componentStats);
    }
    return stats;
  }
}
