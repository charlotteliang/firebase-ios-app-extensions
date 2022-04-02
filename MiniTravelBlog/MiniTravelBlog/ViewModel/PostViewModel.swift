//
//  PostViewModel.swift
//  MiniTravelBlog
//
//  Created by Charlotte Liang on 4/1/22.
//

import UIKit
import FirebaseFirestoreSwift

class PostViewModel : ObservableObject {
  @Published var post: Post = Post.sample
  
  @MainActor
  func fetchImage() async {
    do {
      post = try await MiniPost.getPostURL()
    }
    catch {
    }
  }
}
