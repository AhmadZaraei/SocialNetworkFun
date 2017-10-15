//
//  FeedViewController.swift
//  SocialNetwork
//
//  Created by Ahmad Zaraei on 10/14/17.
//  Copyright © 2017 Ahmad Zaraei. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import FirebaseAuth

class FeedViewController: UIViewController {

  @IBAction func signoutAction(_ sender: Any) {
    // First actually log the user out of Firebase.
    do {
      try Auth.auth().signOut()
    } catch let error as NSError {
      print("Could not sign user out, error is \(error.localizedDescription)")
      // TODO(ahmadzaraei): Show user a dialog for this error.
      return
    }
    // Now that we've signed the user out
    // clear the key chain.
    let keychainRemovalResult = KeychainWrapper.standard.removeAllKeys()
    print("Keychain removal result is \(keychainRemovalResult)")
    // Remove the view controller that was presented
    // Modally.
    dismiss(animated: true, completion: nil)
  }

  override func viewDidLoad() {
        super.viewDidLoad()
    }
}
