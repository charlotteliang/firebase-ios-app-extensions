//
//  ContentView.swift
//  MiniTravelBlog
//
//  Created by Charlotte Liang on 3/17/22.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage

struct ContentView: View {
  
  @State var image:UIImage?
    var body: some View {
      VStack {
      Text("Hello, world!")
            .padding()
      if image != nil {
        Image(uiImage:image!)
          .resizable()
          .scaledToFit()
          .frame(width: 300, height: 300, alignment: .center)
      } else {
        Image(uiImage:UIImage(imageLiteralResourceName: "coffee.png"))
          .resizable()
          .scaledToFit()
          .frame(width: 300, height: 300, alignment: .center)
      }
        Button(action: showImage) {
          Text("Show Photo")
        }
    }
  }
  
  func showImage() {
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
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
