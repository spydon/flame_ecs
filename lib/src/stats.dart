part of flame_ecs;

class Stats {
  final Map<String, dynamic> _map = {};

  bool get isEmpty => _map.isEmpty;
  bool get isNotEmpty => _map.isNotEmpty;

  void add(String key, [dynamic value]) => _map[key] = value;

  void remove(String key) => _map.remove(key);

  @override
  String toString() {
    return _map.entries.map((entry) {
      final key = entry.key;
      final value = entry.value;

      if (value is Stats) {
        if (value.isNotEmpty) {
          final valueList = '\n$value'.split('\n');
          for (var i = 1; i < valueList.length; i++) {
            valueList[i] = '  ${valueList[i]}';
          }
          return '$key: ${valueList.join('\n')}';
        }
        return '$key';
      }

      if (value == null) {
        return '$key';
      }
      return '$key: $value';
    }).join('\n');
  }
}
