//
//  MiniTravelBlogApp.swift
//  MiniTravelBlog
//
//  Created by Charlotte Liang on 3/17/22.
//

import SwiftUI
import FirebaseCore

@main
struct MiniTravelBlogApp: App {

  init () {
    FirebaseApp.configure()
  }
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
