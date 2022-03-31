//
//  ContentView.swift
//  MiniTravelBlog
//
//  Created by Charlotte Liang on 3/17/22.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
  @State var description: String?
  @State var url: URL?
  var body: some View {
    VStack {
      if url != nil {
          AsyncImage(
            url: url,
            content: { image in
              image.resizable()
                .aspectRatio(contentMode: .fit)
            },
            placeholder: {
              ProgressView()
            }
          )
      }
      if description != nil {
        Text(description!)
          .bold()
          .padding()
      }
    }
    .onAppear {
      showPost()
    }
  }

  func showPost() {
    Task {
      let post = try await MiniPost.getPostURL()
      self.url = URL(string:post.url)
      self.description = post.description
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
