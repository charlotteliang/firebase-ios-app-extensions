//
//  MiniPost.swift
//  MiniTravelBlog
//
//  Created by Charlotte Liang on 3/23/22.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseStorageSwift
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
  
  static func getPost(imageName: String) async throws -> (UIImage, String) {
    let ref = Storage.storage().reference().child(imageName)
    
    let data = try await ref.data(maxSize: 20 * 1024 * 2048)
    let image = UIImage(data: data)!
    
    let db = Firestore.firestore()
    let docRef = db.collection("Posts").document("post")
    let document = try await docRef.getDocument()
    let post = try document.data(as: Post.self)
    
    return (image, post.description)
  }
}
