// Copyright 2020 Google
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import UIKit

import Firebase

class ViewController: UIViewController {

  
  @IBOutlet var imageView: UIImageView!
  
  var storage : Storage!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadImage()
  }
  
  func loadImage () {
    self.storage = Storage.storage()
    let imageFileName = "imageFileName.JPG"
    let ref = self.storage.reference().child(imageFileName)
    ref.getData(maxSize: 20 * 1024 * 2014) { (data: Data?, error: Error?) in
      guard let data = data, error == nil else { return }
      self.imageView.contentMode = .scaleAspectFit
      self.imageView.image = UIImage(data:data)
    }
  }


}

