//
//  LoadableImageView.swift
//  MiniTravelBlog
//
//  Created by Peter Friese on 02.04.22.
//

import SwiftUI

struct LoadableImage: View {
  var post: Post
  
  var body: some View {
    AsyncImage(url: post.imageUrl) { phase in
      if let image = phase.image {
        image
          .resizable()
          .scaledToFit()
          .cornerRadius(15)
          .shadow(radius: 5)
          .accessibility(hidden: false)
          .accessibilityLabel(Text(post.description))
      }  else if phase.error != nil  {
        VStack {
          Image("pandaplaceholder")
            .resizable()
            .scaledToFit()
            .frame(maxWidth: 300)
          Text("The pandas were all busy.")
            .font(.title2)
          Text("Please try again.")
            .font(.title3)
        }
        
      } else {
        ProgressView()
      }
    }
  }
}

struct Panda_Previews: PreviewProvider {
  static var previews: some View {
    LoadableImage(post: Post.sample)
  }
}
