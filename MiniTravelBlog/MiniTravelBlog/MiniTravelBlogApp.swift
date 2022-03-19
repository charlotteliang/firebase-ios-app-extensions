//
//  MiniTravelBlogApp.swift
//  MiniTravelBlog
//
//  Created by Charlotte Liang on 3/17/22.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      FirebaseApp.configure()
//      do {
//            try Auth.auth().useUserAccessGroup("EQHXZ8M8AV.group.com.google.firebase.extensions")
//          } catch let error as NSError {
//            print("Error changing user access group: %@", error)
//          }
            Auth.auth().signIn(withEmail: "chen@12345.com", password: "pugiscute") { (result: AuthDataResult?, error: Error?) in
                  }
        return true
    }
}
@main
struct MiniTravelBlogApp: App {
  @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
