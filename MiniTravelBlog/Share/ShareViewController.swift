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
import FirebaseStorageSwift
import FirebaseFirestore
import FirebaseFirestoreSwift

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
    let fileName = "currentImage.JPG"
    let ref = Storage.storage().reference().child(fileName)
    
    let db = Firestore.firestore()
    let description = contentText
    
    guard let inputItem = extensionContext?.inputItems.first as? NSExtensionItem else { return }
    guard let attachment = inputItem.attachments?.first else { return }
    guard let typeIdentifier = attachment.registeredTypeIdentifiers.first else { return }
    
    Task {
      // load image data
      let item = try await attachment.loadItem(forTypeIdentifier: typeIdentifier)
      if let itemURL = item as? URL {
        self.imageData = NSData(contentsOf: itemURL)
      }
      else if let itemImage = item as? UIImage {
        self.imageData = itemImage.pngData() as? NSData
      }
      
      // write image data to Cloud Storage
      let _ = try await ref.putDataAsync(self.imageData as Data)
      let url = try await ref.downloadURL()
      
      let post = Post(description: description ?? "", url: url.absoluteString)
      try db.collection("Posts").document("post").setData(from: post)
      
      WidgetCenter.shared.reloadAllTimelines()
      extensionContext?.completeRequest(returningItems: [])
    }
  }

  override func configurationItems() -> [Any]! {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return []
  }
}
