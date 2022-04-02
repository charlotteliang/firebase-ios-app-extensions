//
//  Post.swift
//  MiniTravelBlog
//
//  Created by Peter Friese on 02.04.22.
//

import Foundation
import FirebaseFirestoreSwift

struct Post: Codable {
  @DocumentID var id: String?
  var description: String
  var url: String
  
  var imageUrl: URL {
    URL(string: url)!
  }
  
  static let sample = Post(description: "San Francisco", url: "https://images.unsplash.com/photo-1534050359320-02900022671e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1964&q=80")
}
