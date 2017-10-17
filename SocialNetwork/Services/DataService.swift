import Foundation
import Firebase

private let databaseReference = Database.database().reference()

class DataService {
  static let dataService = DataService()

  private var _baseReference = databaseReference
  private var _postsReference = databaseReference.child("posts")
  private var _usersReference = databaseReference.child("users")

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
}
