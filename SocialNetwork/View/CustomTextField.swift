import UIKit

class CustomTextField: UITextField, UITextFieldDelegate {
  override func layoutSubviews() {
    super.layoutSubviews()

    layer.borderColor = UIColor(
      displayP3Red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.2).cgColor

    self.borderStyle = UITextBorderStyle.none
    self.layer.cornerRadius = 5
    self.layer.borderWidth = 1
    delegate = self
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.resignFirstResponder()
    return true
  }

  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.insetBy(dx: 10, dy: 5)
  }

  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.insetBy(dx: 10, dy: 5)
  }
}
