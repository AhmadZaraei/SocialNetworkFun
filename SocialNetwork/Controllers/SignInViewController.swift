//
//  ViewController.swift
//  SocialNetwork
//
//  Created by Ahmad Zaraei on 10/13/17.
//  Copyright © 2017 Ahmad Zaraei. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import FirebaseAuth

class SignInViewController: UIViewController {

  @IBOutlet weak var emailAddressTextField: CustomTextField!

  @IBOutlet weak var passwordTextField: CustomTextField!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  @IBAction func signInWithCustomAccountAction(_ sender: Any) {
    if let email = emailAddressTextField.text, let password = passwordTextField.text {
      Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
        if let authError = error {
          print("Unable to login using using e-mail, error is:\(authError)")
          // TODO(ahmadzaraei): Show an error to the user.
          return
        }
        if let authUser = user {
          print("User logged in successfully :\(authUser)")
        }
      })
    } else {
      // TODO(ahmadzaraei): Show a pop-up to the user.
    }
  }

  @IBAction func facebookLoginAction(_ sender: Any) {
    let facebookLogin = FBSDKLoginManager()
    facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
      if let authError = error {
        print("Unable to authenticate with FB, error message was:\(authError)")
      } else if let userResult = result {
        if userResult.isCancelled {
          print("User cancelled the FB auth attempt.")
        } else {
          print("User Successfully logged in. :)")
            let credental = FacebookAuthProvider.credential(
                withAccessToken: FBSDKAccessToken.current().tokenString)
          self.signInFirebase(credential: credental)
        }
      }
    }
  }

  func signInFirebase(credential: AuthCredential) {
    Auth.auth().signIn(with: credential) { (user, error) in
      if let authError = error {
        print("Unable to authenticate with Firebase, error is: \(authError)")
        return
      }
      if let firUser = user {
        print("Successfully authenticated with Firebase, user is: \(firUser)")
      }
    }
  }
}

