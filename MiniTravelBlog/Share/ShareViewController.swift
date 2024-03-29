//
//  ShareViewController.swift
//  Share
//
//  Created by Charlotte Liang on 3/17/22.
//

import WidgetKit
import UIKit
import Social
import FirebaseAuth
import FirebaseCore
import FirebaseStorage
import FirebaseFirestore

class ShareViewController: SLComposeServiceViewController {
  var imageData : NSData!

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
      // Initialize Firebase here and make sure you import GoogleService-Info.plist into this target as well.
          if (FirebaseApp.app() == nil) {
            FirebaseApp.configure()
          }
//          do {
//            try Auth.auth().useUserAccessGroup("EQHXZ8M8AV.group.com.google.firebase.extensions")
//          } catch let error as NSError {
//            print("Error changing user access group: %@", error)
//          }
          
          let fileName = "currentImage.JPG"
          let ref = Storage.storage().reference().child(fileName)
          let firstItem = self.extensionContext?.inputItems.first as! NSExtensionItem
          for attachment in firstItem.attachments! {
            guard let typeIdentifier = attachment.registeredTypeIdentifiers.first else { return }
            attachment.loadItem(forTypeIdentifier: typeIdentifier, options: nil) { (item: NSSecureCoding?, error: Error?) in
              if (item is URL) {
                self.imageData = NSData(contentsOf: item as! URL)
              }
              if (item is UIImage ) {
                self.imageData = (item as! UIImage).pngData() as NSData?
              }
                
              
              ref.putData(self.imageData as Data, metadata: nil) { (metadata: StorageMetadata?, error: Error?) in
                self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
              }
            }
          }
      // Add a new document in collection "cities"
      let db = Firestore.firestore()
      let description = self.contentText
      db.collection("Posts").document("post").setData([
        "description": description ?? ""
      ]) { err in
          if let err = err {
              print("Error writing document: \(err)")
          } else {
              print("Document successfully written!")
          }
        WidgetCenter.shared.reloadAllTimelines()

      }
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}
