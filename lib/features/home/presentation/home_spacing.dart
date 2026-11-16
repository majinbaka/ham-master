/// Spacing in artwork units: 10 units ≈ 4 dp on a 390 dp phone.
/// All home gaps use this grid; frame borders are separate from content padding.
abstract final class HomeSpacing {
  static const unit = 10.0;
  static const small = unit;
  static const gap = unit * 2;
  static const section = unit * 4;
  static const edge = gap;
}
