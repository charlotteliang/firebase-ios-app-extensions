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
import Social
import Firebase

class ShareViewController: SLComposeServiceViewController {
  var imageData: NSData!
  override func isContentValid() -> Bool {
    // Do validation of contentText and/or NSExtensionContext attachments here
    return true
  }

  override func didSelectPost() {
    // Initialize Firebase here and make sure you import GoogleService-Info.plist into this target as well.
    if FirebaseApp.app() == nil {
      FirebaseApp.configure()
    }
    do {
      try Auth.auth().useUserAccessGroup("EQHXZ8M8AV.group.com.google.firebase.extensions")
    } catch let error as NSError {
      print("Error changing user access group: %@", error)
    }

    let fileName = "imageFileName.JPG"
    let ref = Storage.storage().reference().child(fileName)
    let item = extensionContext?.inputItems.first as! NSExtensionItem
    for attachment in item.attachments! {
      guard let typeIdentifier = attachment.registeredTypeIdentifiers.first else { return }
      attachment
        .loadItem(forTypeIdentifier: typeIdentifier,
                  options: nil) { (item: NSSecureCoding?, error: Error?) in
          if item is URL {
            self.imageData = NSData(contentsOf: item as! URL)
          }
          if item is UIImage {
            self.imageData = (item as! UIImage).pngData() as NSData?
          }
          ref
            .putData(self.imageData as Data,
                     metadata: nil) { (metadata: StorageMetadata?, error: Error?) in
              self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
            }
        }
    }
  }

  override func configurationItems() -> [Any]! {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return []
  }
}
