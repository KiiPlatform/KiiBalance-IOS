//
//
// Copyright 2017 Kii Corporation
// http://kii.com
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
//
import Foundation
import UIKit

class KiiProgress {
    class func create(message: String) -> UIAlertController {
        let alert = UIAlertController (title: nil, message: message + "\n\n\n", preferredStyle: .alert)
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge);
        indicator.center = CGPoint(x: 130.5, y: 65.5)
        indicator.color = UIColor.black
        indicator.startAnimating()
        alert.view.addSubview(indicator)

        return alert
    }
}
