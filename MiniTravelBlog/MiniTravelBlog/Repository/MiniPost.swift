//
//  MiniPost.swift
//  MiniTravelBlog
//
//  Created by Charlotte Liang on 3/23/22.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift

struct MiniPost {
  static func getPostURL() async throws -> Post {
    let db = Firestore.firestore()
    let docRef = db.collection("Posts").document("post")
    let document = try await docRef.getDocument()
    let post = try document.data(as: Post.self)
    return post
  }

  static func getPost(imageName: String, completion: @escaping (UIImage, String) -> Void) {
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
    }
  }
}
