//
//  MiniPost.swift
//  MiniTravelBlog
//
//  Created by Charlotte Liang on 3/23/22.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseStorage
import FirebaseFirestore

struct MiniPost {
  static func getPostURL(imageName: String, completion: @escaping (URL, String) -> Void) {
    if FirebaseApp.app() == nil {
      FirebaseApp.configure()
    }

    let ref = Storage.storage().reference().child(imageName)
    ref.downloadURL { url, error in
      if let error = error {
        print("Error fetching URL: \(error)")
        completion(url!, "")
        return
      } else {
        let db = Firestore.firestore()
        db.collection("Posts").document("post")
          .getDocument { document, error in
            if let document = document, document.exists {
              guard let data = document.data() else {
                print("Document data was empty.")
                completion(url!, "")
                return
              }
              print("Current data: \(data)")
              let description = data["description"] as? String
              completion(url!, description ?? "")
            } else {
              print("Document does not exist")
              completion(url!, "test")
            }
          }
      }
    }
    
  }

  static func getPost(imageName: String, completion: @escaping (UIImage, String) -> Void) {
    if FirebaseApp.app() == nil {
      FirebaseApp.configure()
    }

    let ref = Storage.storage().reference().child(imageName)
    ref.getData(maxSize: 20 * 1024 * 2048) { (data: Data?, error: Error?) in
      guard let data = data, error == nil else { return }
      let image = UIImage(data: data)!
      let db = Firestore.firestore()
      db.collection("Posts").document("post")
        .getDocument { document, error in
          if let document = document, document.exists {
            guard let data = document.data() else {
              print("Document data was empty.")
              completion(image, "")
              return
            }
            print("Current data: \(data)")
            let description = data["description"] as? String
            completion(image, description ?? "")
          } else {
            print("Document does not exist")
            completion(image, "test")
          }
        }
//        .addSnapshotListener { documentSnapshot, error in
//          guard let document = documentSnapshot else {
//            print("Error fetching document: \(error!)")
//            completion(image, "")
//            return
//          }
//          guard let data = document.data() else {
//            print("Document data was empty.")
//            completion(image, "")
//            return
//          }
//          print("Current data: \(data)")
//          let description = data["description"] as? String
//          completion(image, description ?? "")
//        }
    }
  }
}
