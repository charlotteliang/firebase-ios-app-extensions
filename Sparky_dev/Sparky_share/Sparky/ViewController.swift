// Copyright 2020 Google
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import UIKit
import SwiftUI
import Firebase
import SwiftUI

class ViewController: UIViewController {
  
  @IBOutlet var imageView: UIImageView!
  var storage : Storage!
  var handle : AuthStateDidChangeListenerHandle!
  @IBOutlet weak var imageLabel: UILabel!
  @IBOutlet weak var authButton: UIBarButtonItem!
  
  override func viewWillAppear(_ animated: Bool) {
    handle = Auth.auth().addStateDidChangeListener { (auth, user) in
      if (user == nil) {
        self.authButton.title = "Log in 🔐"
      } else {
        self.authButton.title = "Log in 🔐"
      }
      self.view.setNeedsLayout()
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    Auth.auth().removeStateDidChangeListener(handle!)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.refreshView()

  }
  
// Storage
  func loadImage () {
    self.storage = Storage.storage()
    let imageFileName = "imageFileName.JPG"
    let ref = self.storage.reference().child(imageFileName)
    ref.getData(maxSize: 20 * 1024 * 2014) { (data: Data?, error: Error?) in
      guard let data = data, error == nil else { return }
      self.imageView.contentMode = .scaleAspectFit
      self.imageView.image = UIImage(data:data)
    }
  }
  
  @IBAction func refreshButtonClicked(_ sender: Any) {
    self.refreshView()
  }
  // Auth
  @IBAction func authButtonClicked(_ sender: Any) {
    if (Auth.auth().currentUser == nil) {
      self.popUpAuthDialog()
    } else {
      try! Auth.auth().signOut()

    }
  }
  
  func popUpAuthDialog() {
    let alert = UIAlertController(title: "Sign up", message: "You have not sign in yet", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: NSLocalizedString("Register", comment: "Reigster your account"), style: .default, handler: { _ in
      self.signup()
    }))
    alert.addAction(UIAlertAction(title: NSLocalizedString("Sign in", comment: "Sign in"), style: .default, handler: { _ in
      self.signin()
    }))
    alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: { _ in
    }))
    self.present(alert, animated: true, completion: nil)

  }
  
  func signup() {
    let alert = UIAlertController(title: "Sign up", message: "Create an account with your email and a password.", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: .cancel, handler: { _ in
    }))
    alert.addAction(UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .default, handler: { _ in
      let email = alert.textFields?.first?.text
      let password = alert.textFields?.last?.text
      Auth.auth().createUser(withEmail: email!, password: password!, completion: { (result: AuthDataResult?, error: Error?) in
        if (error != nil) {
          self.scheduleLocalNotification(withError: error!)
          return
        }
        self.refreshView()
      })
      
    }))
    alert.addTextField { (textField: UITextField) in
      textField.placeholder = "Enter your email:"
    }
    alert.addTextField { (textField: UITextField) in
      textField.placeholder = "Enter your password:"
      textField.isSecureTextEntry = true
    }
    self.present(alert, animated: true, completion: nil)
  }
  
  func signin() {
    let alert = UIAlertController(title: "Sign in", message: "Sign in with your email and a password.", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: .cancel, handler: { _ in
    }))
    alert.addAction(UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .default, handler: { _ in
      let email = alert.textFields?.first?.text
      let password = alert.textFields?.last?.text
      Auth.auth().signIn(withEmail: email!, password: password!) { (result: AuthDataResult?, error: Error?) in
        if (error != nil) {
          self.scheduleLocalNotification(withError: error!)
          return
        }
        self.refreshView()
      }
    }))
    alert.addTextField { (textField: UITextField) in
      textField.placeholder = "Enter your email:"
    }
    alert.addTextField { (textField: UITextField) in
      textField.placeholder = "Enter your password:"
      textField.isSecureTextEntry = true
    }
    self.present(alert, animated: true, completion: nil)
  
  }
  
  func refreshView() {
    if (Auth.auth().currentUser == nil) {
      self.authButton.title = "Log in 🔐"
    } else {
      self.authButton.title = "Log out 🔐"
    }
    loadImage()
  }
  
  func scheduleLocalNotification(withError error: Error) {
    print(error)
    let content = UNMutableNotificationContent()
    content.title = "title"//NSString.localizedUserNotificationString(forKey: "Error!", arguments: nil)
    content.body = "body"//NSString.localizedUserNotificationString(forKey: error.localizedDescription, arguments: nil)
    content.sound = .default
     
    let request = UNNotificationRequest(identifier: "Now", content: content, trigger: nil)
    let center = UNUserNotificationCenter.current()
    center.add(request) { (theError : Error?) in
      if (theError != nil) {
        print(theError!.localizedDescription)
      }
    }
  }
  

}

