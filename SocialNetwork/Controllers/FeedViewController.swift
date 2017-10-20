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

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  static var imageCache: NSCache<NSString, UIImage> = NSCache()
  
  var imageSelected = false
  var postsMap: Dictionary<String, Post> = [:]
  var imagePicker = UIImagePickerController()
  
  @IBOutlet weak var addImage: UIImageView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var postText: UITextField!
  
  @IBAction func tapImageAction(_ sender: Any) {
    present(imagePicker, animated: true, completion: nil)
  }
  
  @IBAction func postAction(_ sender: Any) {
    guard let postText = postText.text, postText != "" else {
      // TODO(ahmadzaraei): Alert the user that the post text
      // needs to be entered.
      print("Post text was missing")
      return
    }
    guard let image = addImage.image, imageSelected == true else {
      // TODO(ahmadzaraei): Alert the user that the image
      // needs to be selected.
      print("Image for post is missing")
      return
    }
    
    if let imageData = UIImageJPEGRepresentation(image, 0.1) {
      let imageId = NSUUID().uuidString
      let imageMetadata = StorageMetadata()
      imageMetadata.contentType = "image/jpeg"
      DataService.dataService.postImageReferences.child(imageId).putData(imageData, metadata: imageMetadata, completion: { (metadata, error) in
        if (error != nil) {
          print("Could not upload image to Firebase storage, Error : \(error)")
        } else if let imageUrl = metadata?.downloadURL()?.absoluteString {
          self.createPostInFirebase(imageUrl: imageUrl, text: postText)
        }
      })
    }
  }
  
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
    
    self.imagePicker.delegate = self
    self.imagePicker.allowsEditing = true
    
    self.tableView.delegate = self
    self.tableView.dataSource = self
    
    DataService.dataService.postsReference.observe(.value) { (dataSnapShot) in
      if let dataObjects = dataSnapShot.children.allObjects as? [DataSnapshot] {
        for dataObject in dataObjects {
          if let postDictionary = dataObject.value as? Dictionary<String, AnyObject> {
            let key = dataObject.key
            // Covers the case where a user updates an existing post, or new post.
            // That way for an update, we aren't creating new posts.
            self.postsMap[key] = Post(postKey: key, postData: postDictionary)
          }
        }
      }
      self.tableView.reloadData()
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell") as? FeedTableViewCell {
      let posts = postsMap.map { $0.value }
      let post = posts[indexPath.row]
      if let image = FeedViewController.imageCache.object(forKey: post.imageUrl as NSString) {
        cell.configureCell(post: post, image: image)
      } else {
        cell.configureCell(post: post)
      }
      return cell
    }
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return postsMap.count
  }
  
  func createPostInFirebase(imageUrl: String, text: String) {
    let postData : Dictionary<String, AnyObject> = [
      "imageUrl" : imageUrl as AnyObject,
      "caption" : text as AnyObject,
      "likes" : 0 as AnyObject]
    
    // Create post in firebase
    DataService.dataService.postsReference.childByAutoId().setValue(postData)
    
    // Clear out the objects.
    postText.text = ""
    imageSelected = false
    addImage.image = UIImage(named: "add-image")
    postText.endEditing(true)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
      addImage.image = image
      imageSelected = true
    }
    imagePicker.dismiss(animated: true, completion: nil)
  }
}
