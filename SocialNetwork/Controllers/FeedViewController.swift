//
//  FeedViewController.swift
//  SocialNetwork
//
//  Created by Ahmad Zaraei on 10/14/17.
//  Copyright © 2017 Ahmad Zaraei. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  var posts : [Post] = []

  @IBOutlet weak var tableView: UITableView!

  @IBAction func signoutAction(_ sender: Any) {
    do {
      try Auth.auth().signOut()
    } catch let error as NSError {
      print("Could not sign user out, error is \(error.localizedDescription)")
      // TODO(ahmadzaraei): Show user a dialog for this error.
      return
    }
    KeychainWrapper.standard.removeAllKeys()
    dismiss(animated: true, completion: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.tableView.delegate = self
    self.tableView.dataSource = self

    DataService.dataService.postsReference.observe(.value) { (dataSnapShot) in
      if let dataObjects = dataSnapShot.children.allObjects as? [DataSnapshot] {
        for dataObject in dataObjects {
          if let postDictionary = dataObject.value as? Dictionary<String, AnyObject> {
            let key = dataObject.key
            self.posts.append(Post(postKey: key, postData: postDictionary))
          }
        }
      }
      self.tableView.reloadData()
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell") as? FeedTableViewCell {
      let post = posts[indexPath.row]
      print("Ahmad the post is \(post)")
      cell.userNameLabel.text = "Zaraei213"
      cell.caption.text = post.caption
      cell.likesLabel.text = String(post.likes)
      return cell
    }
    // TODO(ahmadzaraei): Consider logging + throwing an error, since this should be an impossible
    // scenario.
    return UITableViewCell()
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return posts.count
  }
}
