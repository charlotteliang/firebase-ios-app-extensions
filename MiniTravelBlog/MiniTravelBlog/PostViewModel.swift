//
//  PostViewModel.swift
//  MiniTravelBlog
//
//  Created by Charlotte Liang on 4/1/22.
//

import UIKit
import FirebaseFirestoreSwift


struct Post: Codable {
  @DocumentID var id: String?
  var description: String
  var url: String
}

class PostViewModel : ObservableObject {
  @Published var post: Post
  init(description: String, url: String) {
    self.post = Post(id: "fakeDocumentID", description: description, url: url)
  }
}
