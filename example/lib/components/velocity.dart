import 'package:flame_ecs/flame_ecs.dart';

class VelocityInit extends InitObject {
  final double x;

  final double y;

  VelocityInit({this.x = 0, this.y = 0});
}

class Velocity extends Component<VelocityInit> {
  double x;

  double y;

  @override
  void init(VelocityInit data) {
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
