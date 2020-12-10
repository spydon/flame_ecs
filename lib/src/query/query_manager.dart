part of flame_ecs;

class QueryManager {
  final EntityManager entityManager;

  Map<String, Query> _queries = {};

  QueryManager(this.entityManager);

  void _onEntityRemoved(Entity entity) {
    for (final query in _queries.values) {
      if (query.entities.contains(entity)) {
        query.entities.remove(entity);
      }
    }
  }

  void _onComponentAddedToEntity(Entity entity, Type componentType) {
    for (final query in _queries.values) {
      // Entity should only be added when all the following conditions are met:
      // - the Entity matches the complete query.
      // - the Entity is not already part of the query.
      if (query.match(entity) && !query.entities.contains(entity)) {
        query.entities.add(entity);
      }
    }
  }

  void _onComponentRemovedFromEntity(Entity entity, Type componentType) {
    for (final query in _queries.values) {
      // Entity should only be removed when all the following conditions are met:
      // - the Entity matches the complete query.
      // - the Entity is not already part of the query.
      if (!query.match(entity) && query.entities.contains(entity)) {
        query.entities.remove(entity);
      }
    }
  }

  String _createKey(Iterable<Filter> filters) {
    final uniqueIds = <String>[];
    for (final filter in filters) {
      if (!entityManager.world.componentManager.components.contains(filter.type)) {
        throw Exception(
          'Tried to query on ${filter.type}, but this component has not yet been registered to the World',
        );
      }
      uniqueIds.add(filter.uniqueId);
    }
    return uniqueIds.join('-');
  }

  Query createQuery(Iterable<Filter> filters) {
    return _queries.update(
      _createKey(filters),
      (value) => value,
      ifAbsent: () => Query(entityManager, filters),
    );
  }

  Stats stats() {
    final stats = Stats();
    for (final queryKey in _queries.keys) {
      stats.add(queryKey, _queries[queryKey].stats());
    }
    return stats;
  }
}
