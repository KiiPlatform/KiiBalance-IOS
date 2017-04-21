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

enum EditItemViewMode {
    case Add
    case Edit
}

@objc protocol DoneEditDelegate {
    func addItem(object: KiiObject) -> Void
    func updateItem(object: KiiObject) -> Void
    func deleteItem(object: KiiObject) -> Void
}

class EditItemViewController : UITableViewController {
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var amountText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var typeLabel: UILabel!

    var mode: EditItemViewMode!
    var objectId: String?
    var name: String!
    var type: BalanceItemType!
    var amount: Int!

    weak var doneEditDelegate: DoneEditDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add buttons to NavigationItem.
        self.navigationItem.rightBarButtonItem = self.saveButton;

        // Set default values.
        self.amountText.text = String(format: "%.2lf", (Double(amount!) / 100.0));
        self.nameText.text = name!
        self.refreshType()
    }

    func closeKeyboard() {
        self.amountText.resignFirstResponder()
        self.nameText.resignFirstResponder()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.mode == EditItemViewMode.Add {
            return 1
        } else {
            return 2
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath:IndexPath) {
        // If the user tapped the "Type" field, open the type dialog.
        if indexPath.row == 2 {
            self.amountText.resignFirstResponder()
            self.nameText.resignFirstResponder()
            self.showTypeDialog()
        }
    }

    func showTypeDialog() {
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let incomeAction = UIAlertAction.init(title: "Income", style: .default) { (action) in
            self.type = .Income
            self.refreshType()
        }
        alert.addAction(incomeAction)
        let expenseAction = UIAlertAction.init(title: "Expense", style: .default) { (action) in
            self.type = .Expense
            self.refreshType()
        }
        alert.addAction(expenseAction)
        self.present(alert, animated: true, completion: nil)
    }

    func refreshType() {
        switch (self.type!) {
        case BalanceItemType.Income:
            self.typeLabel.text = "Income"
        case BalanceItemType.Expense:
            self.typeLabel.text = "Expense"
        }
    }

    @IBAction func saveClicked(_ sender: Any) {
        // Read input values.
        let amount = Int(Double(self.amountText.text!)! * 100)
        var name = self.nameText.text
        let type = self.type

        // Set the default name if the value is empty.
        if name == "" {
            if type == BalanceItemType.Income {
                name = "Income"
            } else {
                name = "Expense"
            }
        }

        // Create a KiiObject instance.
        let bucket = KiiUser.current()?.bucket(withName: BalanceItem.Bucket)
        var object: KiiObject
        if self.mode == .Add {
            object = bucket!.createObject()
        } else {
            object = bucket!.createObject(withID: self.objectId!)
        }

        object.setObject(NSNumber(value: amount), forKey: BalanceItem.FieldAmount)
        object.setObject(name, forKey: BalanceItem.FieldName)
        object.setObject(NSNumber(value: type!.rawValue), forKey: BalanceItem.FieldType)

        // Show the progress.
        let progress = KiiProgress.create(message: "Saving Object...")
        self.present(progress, animated: false, completion: nil)

        // Call the KiiCloud API for saving the KiiObject on Kii Cloud.
        object.save { (object, error) in
            if error != nil {
                progress.dismiss(animated: true, completion: {
                    let description = (error! as NSError).userInfo["description"] as! String
                    let alert = KiiAlert.create(title: "Error", message: description)
                    self.present(alert, animated: true, completion: nil)
                    return
                })
            }

            // Return to the data listing screen.
            self.closeKeyboard()
            if self.mode == EditItemViewMode.Add {
                self.doneEditDelegate.addItem(object: object);
            } else {
                self.doneEditDelegate.updateItem(object: object);
            }
            progress.dismiss(animated: false, completion: nil)
            self.performSegue(withIdentifier: "doneEditItem", sender: nil)
        }
    }

    @IBAction func deleteClicked(_ sender: Any) {
        self.closeKeyboard()
        let alert = UIAlertController.init(title: "Confirm", message: "Would you delete this item?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "No", style: .default, handler: nil)
        alert.addAction(cancelAction)
        let okAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            self.deleteItem()
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

    func deleteItem() {
        // Create a KiiObject instance with its ID.
        let bucket = KiiUser.current()?.bucket(withName: BalanceItem.Bucket)
        let object = bucket!.createObject(withID: self.objectId!)

        // Show the progress.
        let progress = KiiProgress.create(message: "Deleting Object...")
        self.present(progress, animated: false, completion: nil)

        // Call the KiiCloud API for deleting the KiiObject on Kii Cloud.
        object.delete { (object, error) in
            if error != nil {
                progress.dismiss(animated: true, completion: {
                    let description = (error! as NSError).userInfo["description"] as! String
                    let alert = KiiAlert.create(title: "Error", message: description)
                    self.present(alert, animated: true, completion: nil)
                    return
                })
            }

            // Return to the data listing screen.
            self.doneEditDelegate.deleteItem(object: object);
            progress.dismiss(animated: false, completion: nil)
            self.performSegue(withIdentifier: "doneEditItem", sender: nil)
        }
    }
}
