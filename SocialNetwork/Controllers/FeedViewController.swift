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

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var tableView: UITableView!

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
    self.tableView.delegate = self
    self.tableView.dataSource = self
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell") as? FeedTableViewCell {
      cell.userNameLabel.text = "Zaraei213"
      cell.caption.text = "Hey, look at this picture, I took this while I was at the Grand Canyon"
         + "giving a speech!!"
      return cell
    }
    // TODO(ahmadzaraei): Consider logging + throwing an error, since this should be an impossible
    // scenario.
    return UITableViewCell()
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }
}
