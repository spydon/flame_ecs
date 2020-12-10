import 'package:flame_ecs/flame_ecs.dart';

const SHAPE_FULL = 32.0;
const SHAPE_HALF = SHAPE_FULL / 2;

class ShapeInit extends InitObject {
  final String primitive;

  ShapeInit({this.primitive}) : assert(primitive == 'box' || primitive == 'circle');
}

class Shape extends Component<ShapeInit> {
  String primitive;
  

  @override
  Stats stats() => Stats()..add('primitive', primitive);

  @override
  void init(ShapeInit data) {
    primitive = data.primitive;
  }

  @override
  void reset() {
    primitive = '';
  }
}
