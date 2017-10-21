import UIKit

class CustomImage: UIImageView {
  override func layoutSubviews() {
    super.layoutSubviews()
    self.layer.cornerRadius = 10
  }
}

