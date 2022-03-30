//
//  ContentView.swift
//  MiniTravelBlog
//
//  Created by Charlotte Liang on 3/17/22.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
  @State var image: UIImage?
  @State var description: String?
  @State var url: URL?
  var body: some View {
    VStack {
      if image != nil {
        Image(uiImage: image!)
          .resizable()
          .scaledToFit()
      }
      if url != nil {
        if #available(iOS 15.0, *) {
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
        } else {
          // Fallback on earlier versions
        }
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
    let imageFileName = "currentImage.JPG"
//    MiniPost.getPost(imageName: imageFileName) { image, description in
//      self.image = image
//      self.description = description
//    }
    MiniPost.getPostURL(imageName: imageFileName) { url, description in
      self.url = url
      self.description = description
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
