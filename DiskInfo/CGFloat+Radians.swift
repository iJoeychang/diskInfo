
import Foundation

extension CGFloat {
  var radians: CGFloat {
    return self * CGFloat(2 * Double.pi / 360)
  }
  
  var degrees: CGFloat {
    return 360.0 * self / CGFloat(2 * Double.pi)
  }
}
