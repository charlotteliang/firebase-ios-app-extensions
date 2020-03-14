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

import WatchKit
import Foundation
import FirebaseStorage


class InterfaceController: WKInterfaceController {

  @IBOutlet weak var imageView: WKInterfaceImage!
  override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
      super.willActivate()
      let storage = Storage.storage()
      let storageRef = storage.reference().child("imageFileName.JPG")
        storageRef.getData(maxSize: 20 * 1024 * 1024) { (data: Data?, error: Error?) in
          self.imageView.setImageData(data)
      }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
