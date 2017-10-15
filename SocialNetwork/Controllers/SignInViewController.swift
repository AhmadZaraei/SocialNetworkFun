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

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
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

