import 'package:flame_ecs/flame_ecs.dart';

class PositionInit extends InitObject {
  final double x;

  final double y;

  PositionInit({this.x = 0, this.y = 0});
}

class Position extends Component<PositionInit> {
  double x;

  double y;

  @override
  void init(PositionInit data) {
    x = data.x;
    y = data.y;
  }

  @override
  void reset() {
    x = 0;
    y = 0;
  }

  @override
  Stats stats() =>
      Stats()..add('x', x.toStringAsFixed(2))..add('y', y.toStringAsFixed(2));
}
