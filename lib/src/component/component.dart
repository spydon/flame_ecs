part of flame_ecs;

@immutable
abstract class InitObject {

}

abstract class Component<T extends InitObject> extends PoolObject {
  Stats stats() => Stats();

  void init(T data) {}

  @override
  void reset();

  void dispose() {
    if (_pool != null) {
      _pool.release(this);
    }
  }
}
