import UIKit

class CustomShadowView: UIView {

  override func awakeFromNib() {
    super.awakeFromNib()

    layer.shadowColor = UIColor(
      displayP3Red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
    layer.shadowOpacity = 0.7
    layer.shadowRadius = 6.0
    layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
  }
}
