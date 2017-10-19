import UIKit
import Firebase

class FeedTableViewCell: UITableViewCell {
  @IBOutlet weak var profileImage: UIImageView!
  @IBOutlet weak var postImage: UIImageView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var likesLabel: UILabel!
  @IBOutlet weak var caption: UITextView!

  var post : Post!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
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
  }
}
