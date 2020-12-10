part of flame_ecs;

abstract class Filter<T extends Component> {
  Filter() : assert(T != Component);

  String get uniqueId;

  Type get type => T;

  bool match(Entity entity);
}

class HasComponent<T extends Component> extends Filter<T> {
  @override
  String get uniqueId => 'HasComponent<$T>';

  @override
  bool match(Entity entity) => entity._componentTypes.contains(T);
}

class Query {
  final EntityManager entityManager;

  Iterable<Filter> _filters = [];

  List<Entity> entities = [];

  Query(this.entityManager, this._filters) {
    for (final entity in entityManager._entities) {
      if (match(entity)) {
        entities.add(entity);
      }
    }
  }

  bool match(Entity entity) => _filters.every((filter) => filter.match(entity));

  Stats stats() => Stats()..add('entities', entities.length);
}
