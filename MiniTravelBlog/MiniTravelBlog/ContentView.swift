//
//  ContentView.swift
//  MiniTravelBlog
//
//  Created by Charlotte Liang on 3/17/22.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

struct ContentView: View {
  
  @State var image:UIImage?
  @State var description:String?
    var body: some View {
      VStack {
      if image != nil {
        Image(uiImage:image!)
          .resizable()
          .scaledToFit()
      }
        if description != nil {
          Text(description!)
            .padding()
        }
      }.onAppear() {
        showPost()
      }
    }
  
  func showPost() {
//    do {
//      try Auth.auth().useUserAccessGroup("EQHXZ8M8AV.group.com.google.firebase.extensions")
//    } catch let error as NSError {
//      print("Error changing user access group: %@", error)
//    }
    let ref = Storage.storage().reference().child("currentImage.JPG")
        ref.getData(maxSize: 20 * 1024 * 2048) { (data: Data?, error: Error?) in
          guard let data = data, error == nil else {return }
          self.image = UIImage(data:data)!
          }
    let db = Firestore.firestore()
    db.collection("Posts").document("post")
        .addSnapshotListener { documentSnapshot, error in
          guard let document = documentSnapshot else {
            print("Error fetching document: \(error!)")
            return
          }
          guard let data = document.data() else {
            print("Document data was empty.")
            return
          }
          print("Current data: \(data)")
          self.description = data["description"] as? String
        }

  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
