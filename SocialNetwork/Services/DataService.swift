import Foundation
import Firebase

private let databaseReference = Database.database().reference()
private let storageReference = Storage.storage().reference()

class DataService {
  static let dataService = DataService()
  // Database references
  private var _baseReference = databaseReference
  private var _postsReference = databaseReference.child("posts")
  private var _usersReference = databaseReference.child("users")

  // Storage references
  private var _postImageReferences = storageReference.child("post-images")

  // Storage getters
  var postImageReferences : StorageReference {
    return _postImageReferences
  }

  // Database getters
  var baseReference : DatabaseReference {
    return _baseReference
  }
  var postsReference : DatabaseReference {
    return _postsReference
  }
  var usersReference : DatabaseReference {
    return _usersReference
  }

  func createDatabaseUser(uid: String, userData: Dictionary<String, String>) {
    usersReference.child(uid).updateChildValues(userData)
  }

  func createPost(uid: String, postData: Dictionary<String, String>) {
    _postsReference.child(uid).updateChildValues(postData)
  }
}
