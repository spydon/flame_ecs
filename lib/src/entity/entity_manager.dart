part of flame_ecs;

class EntityPool extends ObjectPool<Entity> {
  EntityManager entityManager;

  EntityPool(this.entityManager) : super();

  @override
  Entity builder() => Entity(this.entityManager);
}

class EntityManager {
  final World world;

  List<Entity> _entities = [];

  Map<String, Entity> _entitiesByName = {};

  EntityPool _entityPool;

  int _nextEntityId = 0;

  QueryManager _queryManager;

  EntityManager(this.world) {
    _entityPool = EntityPool(this);
    _queryManager = QueryManager(this);
  }

  Entity getEntityByName(String name) => _entitiesByName[name];

  Entity createEntity([String name]) {
    final entity = _entityPool.acquire();
    entity.alive = true;
    entity.name = name ?? '';
    if (name != null) {
      _entitiesByName[name] = entity;
    }

    _entities.add(entity);
    return entity;
  }

  void addComponentToEntity<T extends Component>(
    Entity entity,
    InitObject data,
  ) {
    assert(T != Component, 'An implemented Component was expected');
    assert(
      world.componentManager.components.contains(T),
      'Component $T has not been registered to the World',
    );

    if (entity._componentTypes.contains(T)) {
      return; // Entity already has an instance of the component.
    }

    final componentPool = world.componentManager.getComponentPool(T);
    final component = componentPool.acquire();
    component.init(data);

    entity._componentTypes.add(T);
    entity._components[T] = component;
    _queryManager._onComponentAddedToEntity(entity, T);
  }

  void removeComponentFromEntity<T extends Component>(Entity entity) {
    assert(T != Component, 'An implemented Component was expected');
    assert(
      world.componentManager.components.contains(T),
      'Component $T has not been registered to the World',
    );
    return _removeComponentFromEntity(entity, T);
  }

  void _removeComponentFromEntity(Entity entity, Type componentType) {
    if (!entity._componentTypes.contains(componentType)) {
      return;
    }
    entity._componentTypes.remove(componentType);
    final component = entity._components.remove(componentType);
    component.dispose();

    _queryManager._onComponentRemovedFromEntity(entity, componentType);
  }

  void removeAllComponentFromEntity(Entity entity) {
    final componentTypes = entity._componentTypes.toSet();
    for (final componentType in componentTypes) {
      _removeComponentFromEntity(entity, componentType);
    }
  }

  void removeEntity(Entity entity) {
    if (!_entities.contains(entity)) {
      return;
    }

    entity.alive = false;
    removeAllComponentFromEntity(entity);
    _queryManager._onEntityRemoved(entity);
    _releaseEntity(entity);
  }

  void _releaseEntity(Entity entity) {
    _entities.remove(entity);
    if (_entitiesByName.containsKey(entity.name)) {
      _entitiesByName.remove(entity.name);
    }
    entity._pool.release(entity);
  }

  stats() => Stats()
    ..add('entities', _entities.length)
    ..add('queries', _queryManager.stats())
    ..add('pool', _entityPool.stats());
}
