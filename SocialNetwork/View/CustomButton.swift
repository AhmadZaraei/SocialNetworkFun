import UIKit

class CustomButton: UIButton {
  override func layoutSubviews() {
    super.layoutSubviews()
    self.layer.cornerRadius = 10
  }
}

