import UIKit
import Firebase

class FeedTableViewCell: UITableViewCell {
  let userLikesRef = DataService.dataService.currentUser.child("likes")
  let postRef = DataService.dataService.postsReference
  
  @IBOutlet weak var profileImage: UIImageView!
  @IBOutlet weak var postImage: UIImageView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var likesLabel: UILabel!
  @IBOutlet weak var caption: UITextView!
  @IBOutlet weak var likesImage: UIImageView!
  
  var post : Post!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    let tap = UITapGestureRecognizer(target : self, action: #selector(likeTapped))
    tap.numberOfTapsRequired = 1
    likesImage.addGestureRecognizer(tap)
    likesImage.isUserInteractionEnabled = true
  }
  
  func configureCell(post: Post, image: UIImage? = nil) {
    self.post = post
    self.caption.text = post.caption
    self.likesLabel.text = String(post.likes)
    
    if image != nil {
      self.postImage.image = image
    } else {
      let imageUrl = self.post.imageUrl
      let ref = Storage.storage().reference(forURL: imageUrl)
      ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
        if error != nil {
          print("Failed to download image from Firebase with error \(error)")
        } else {
          print("Image downloaded from Firebase storage")
          if let imageData = data {
            if let image = UIImage(data: imageData) {
              self.postImage.image = image
              FeedViewController.imageCache.setObject(image, forKey: imageUrl as NSString)
            }
          }
        }
      })
    }
    userLikesRef.child(post.postKey).observeSingleEvent(of: .value) { (snapshot) in
      if let value = snapshot.value, value as? Bool == true {
        self.likesImage.image = UIImage(named: "filled-heart")
      } else {
        self.likesImage.image = UIImage(named: "empty-heart")
      }
    }
  }
  
  @objc func likeTapped(sender: UITapGestureRecognizer) {
    print("I was clicked!!!!")
    userLikesRef.child(post.postKey).observeSingleEvent(of: .value) { (snapshot) in
      if let value = snapshot.value, value as? Bool == true {
        self.likesImage.image = UIImage(named: "empty-heart")
        self.userLikesRef.child(self.post.postKey).setValue(false)
        self.post.adjustLikes(like: false)
      } else {
        self.likesImage.image = UIImage(named: "filled-heart")
        self.userLikesRef.child(self.post.postKey).setValue(true)
        self.post.adjustLikes(like: true)
      }
    }
  }
}
