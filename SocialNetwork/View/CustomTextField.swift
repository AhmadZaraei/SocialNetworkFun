//
//  CustomTextField.swift
//  SocialNetwork
//
//  Created by Ahmad Zaraei on 10/14/17.
//  Copyright © 2017 Ahmad Zaraei. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
  override func layoutSubviews() {
    super.layoutSubviews()

    layer.borderColor = UIColor(
      displayP3Red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.2).cgColor

    self.borderStyle = UITextBorderStyle.none
    self.layer.cornerRadius = 5
    self.layer.borderWidth = 1
  }

  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.insetBy(dx: 10, dy: 5)
  }

  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.insetBy(dx: 10, dy: 5)
  }
}
