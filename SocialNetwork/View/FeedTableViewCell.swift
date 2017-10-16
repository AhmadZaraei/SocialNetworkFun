import UIKit

class FeedTableViewCell: UITableViewCell {
  @IBOutlet weak var profileImage: UIImageView!
  @IBOutlet weak var postImage: UIImageView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var likesLabel: UILabel!
  @IBOutlet weak var caption: UITextView!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
}
