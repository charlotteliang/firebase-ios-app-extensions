//
//  ContentView.swift
//  MiniTravelBlog
//
//  Created by Charlotte Liang on 3/17/22.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
  @ObservedObject var postViewModel: PostViewModel
  var body: some View {
    VStack {
      AsyncImage(
        url: URL(string:postViewModel.post.url),
        content: { image in
              image.resizable()
                .aspectRatio(contentMode: .fit)
            },
        placeholder: {
          ProgressView()
        }
      )
      TextField("Post description", text: $postViewModel.post.description)
    }
    .task {
      do {
        let post = try await MiniPost.getPostURL()
        postViewModel.post = post
      } catch {
        
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(postViewModel: PostViewModel(description: "",url: ""))
  }
}
