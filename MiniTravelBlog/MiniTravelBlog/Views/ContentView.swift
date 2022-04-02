//
//  ContentView.swift
//  MiniTravelBlog
//
//  Created by Charlotte Liang on 3/17/22.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
  @Environment(\.scenePhase) var scenePhase
  @StateObject var postViewModel = PostViewModel()
  
  var body: some View {
    VStack {
      AsyncImage(url: postViewModel.post.imageUrl, scale: 2) { image in
        image
          .resizable()
          .scaledToFit()
          .aspectRatio(contentMode: .fill)
      } placeholder: {
        ProgressView()
          .progressViewStyle(.circular)
      }
      .ignoresSafeArea()
      .overlay(alignment: .bottom) {
        Text(postViewModel.post.description)
          .font(.headline)
          .frame(maxWidth: .infinity, maxHeight: 50, alignment: .center)
          .background(.thinMaterial)
      }
    }
    .task {
      await postViewModel.fetchImage()
    }
    .onChange(of: scenePhase) { newScenePhase in
      if newScenePhase == .active {
        Task {
          await postViewModel.fetchImage()
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
