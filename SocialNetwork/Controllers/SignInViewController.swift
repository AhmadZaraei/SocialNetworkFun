import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import FirebaseAuth
import SwiftKeychainWrapper

class SignInViewController: UIViewController {
  
  @IBOutlet weak var emailAddressTextField: CustomTextField!
  
  @IBOutlet weak var passwordTextField: CustomTextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    // If the user has already logged in, let them continue.
    if let _ = KeychainWrapper.standard.string(forKey: KEYCHAIN_KEY) {
      self.performSegue(withIdentifier: "segueFeedViewController", sender: nil)
    }
  }
  
  @IBAction func signInWithCustomAccountAction(_ sender: Any) {
    if let email = emailAddressTextField.text, let password = passwordTextField.text {
      Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
        if let authError = error {
          print("Unable to login using using e-mail, error is:\(authError)")
          // TODO(ahmadzaraei): Show an error to the user, and ask them if they actually want
          // an account :), since this is a toy project, just create an account.
          Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if let authError = error {
              print("Unable to create a new user, error is:\(authError)")
            } else if let authUser = user {
              print("User logged in successfully:\(authUser)")
              KeychainWrapper.standard.set(authUser.uid, forKey: KEYCHAIN_KEY)
              
              let userData = ["Provider" : authUser.providerID]
              DataService.dataService.createDatabaseUser(uid: authUser.uid, userData: userData)
              self.performSegue(withIdentifier: "segueFeedViewController", sender: nil)
            }
          })
        } else if let authUser = user {
          print("User logged in successfully with existing account :\(authUser)")
          KeychainWrapper.standard.set(authUser.uid, forKey: KEYCHAIN_KEY)
          self.performSegue(withIdentifier: "segueFeedViewController", sender: nil)
        }
      })
    } else {
      // TODO(ahmadzaraei): Show a pop-up to the user.
    }
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
        
        KeychainWrapper.standard.set(firUser.uid, forKey: KEYCHAIN_KEY)
        
        let userData = ["Provider" : credential.provider]
        DataService.dataService.createDatabaseUser(uid: firUser.uid, userData: userData)
        
        self.performSegue(withIdentifier: "segueFeedViewController", sender: nil)
      }
    }
  }
}

