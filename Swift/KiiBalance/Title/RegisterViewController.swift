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
import KiiSDK

class RegisterViewController : UIViewController {
    @IBOutlet weak var registerButton: UIBarButtonItem!

    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add the "Register" button to NavigationItem.
        self.navigationItem.rightBarButtonItem = self.registerButton

        self.usernameText.becomeFirstResponder();
    }

    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        self.closeKeyboard()
    }

    func closeKeyboard() {
        self.usernameText.resignFirstResponder()
        self.passwordText.resignFirstResponder()
    }

    // MARK: - UI event

    @IBAction func registerClicked(_ sender: Any) {
        // Get a username and password.
        let username = self.usernameText.text!
        let password = self.passwordText.text!

        self.closeKeyboard()

        // Show the progress.
        let progress = KiiProgress.create(message:"Registering...")
        self.present(progress, animated: false, completion: nil)

        // Register the user.
        let user = KiiUser(username: username, andPassword: password)
        user.performRegistration { (user: KiiUser?, error: Error?) -> Void in
            if error != nil {
                progress.dismiss(animated: true, completion: {
                    let description = (error! as NSError).userInfo["description"] as! String
                    let alert = KiiAlert.create(title: "Error", message: description)
                    self.present(alert, animated: true, completion: nil)
                })
                return
            }
            progress.dismiss(animated: false, completion: nil)
            let app = UIApplication.shared.delegate as! AppDelegate
            app.showBalanceList()
        }
    }
}
