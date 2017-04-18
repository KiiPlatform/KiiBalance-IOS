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

class BalanceListViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, DoneEditDelegate {
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!

    var items: [KiiObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add buttons to NavigationItem.
        self.navigationItem.leftBarButtonItem = self.logoutButton
        self.navigationItem.rightBarButtonItem = self.refreshButton

        self.items = []
        self.getItems()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let next = segue.destination as! EditItemViewController
        if segue.identifier == "addItem" {
            // Initialize the editing screen with empty value.
            next.mode = .Add
            next.objectId = nil
            next.name = ""
            next.type = BalanceItemType.Expense
            next.amount = 0
            next.doneEditDelegate = self
        } else if (segue.identifier == "editItem") {
            // Initialize the editing screen with tapped KiiObject.
            let obj = sender as! KiiObject
            next.mode = .Edit
            next.objectId = obj.uuid
            next.name = obj.getForKey(BalanceItem.FieldName) as! String
            next.type = BalanceItemType(rawValue: (obj.getForKey(BalanceItem.FieldType) as! NSNumber).intValue)
            next.amount = (obj.getForKey(BalanceItem.FieldAmount) as! NSNumber).intValue
            next.doneEditDelegate = self
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Clear the selection in the table view.
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }

    // MARK: - UI Event

    @IBAction func logoutClicked(_ sender: Any) {
        KiiUser.logOut()

        // Show the title screen.
        let app = UIApplication.shared.delegate as! AppDelegate
        app.showTitle()
    }

    @IBAction func refreshClicked(_ sender: Any) {
        self.getItems()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:IndexPath) {
        if indexPath.section == 0 {
            return
        }
 
        // Path KiiObject to prepare(for:sender:) method.
        let obj = self.items[indexPath.row]
        self.performSegue(withIdentifier: "editItem", sender: obj)
    }

    @IBAction func doneEditItem(segue: UIStoryboardSegue) {
        self.tableView.reloadData()
    }

    // MARK: - DoneEditDelegate

    func addItem(object: KiiObject) {
        self.items.append(object)
    }

    func updateItem(object: KiiObject) {
        // Replace KiiObject in self.items.
        for i in 0..<self.items.count {
            let objectInItems = self.items[i]
            if object.uuid == objectInItems.uuid {
                self.items[i] = object
                break
            }
        }
    }

    func deleteItem(object: KiiObject) {
        // Delete KiiObject in self.items.
        for i in 0..<self.items.count {
            let objectInItems = self.items[i]
            if object.uuid == objectInItems.uuid {
                self.items.remove(at: i)
                break
            }
        }
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return self.items.count
        }
    }

    func formatCurrency(amount: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.currencySymbol = "$"
        let text = numberFormatter.string(from: NSNumber.init(value: amount))
        return text!
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Total", for: indexPath) as! TotalAmountTableViewCell
            let total = self.calcTotal()
            if total < 0 {
                cell.amountLabel.textColor = UIColor.red
            } else {
                cell.amountLabel.textColor = UIColor.black
            }
            cell.amountLabel.text = self.formatCurrency(amount: total)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! BalanceItemTableViewCell
            let obj = self.items[indexPath.row]
            let name = obj.getForKey(BalanceItem.FieldName) as! String
            let type = (obj.getForKey(BalanceItem.FieldType) as! NSNumber).intValue
            let amount = (obj.getForKey(BalanceItem.FieldAmount) as! NSNumber).intValue

            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            let date = formatter.string(from: obj.created!)
            cell.dateLabel.text = date

            var amountDisplay: Double
            cell.nameLabel.text = name
            if type == BalanceItemType.Income.rawValue {
                cell.amountLabel.textColor = UIColor.black
                amountDisplay = Double(amount) / 100.0
            } else {
                cell.amountLabel.textColor = UIColor.red
                amountDisplay = -1 * Double(amount) / 100.0
            }
            cell.amountLabel.text = self.formatCurrency(amount: amountDisplay)
            return cell;
        }
    }

    // MARK: - private method

    func getItems() {
        let bucket = KiiUser.current()!.bucket(withName: BalanceItem.Bucket)

        // Create a query instance.
        let query = KiiQuery.init(clause: nil)
        // Sort KiiObjects by the _created field.
        query.sort(byAsc: BalanceItem.FieldCreated)

        let progress = KiiProgress.create(message:"Loading...")
        self.present(progress, animated: false, completion: nil)

        var objectList: [KiiObject] = []

        // Define the recursive closure to get all objects.
        var callback: KiiQueryResultBlock?
        callback = { (query: KiiQuery?, bucket: KiiBucket, results: [Any]?, nextQuery: KiiQuery?, error: Error?) -> Void in
            if error != nil {
                progress.dismiss(animated: true, completion: {
                    let description = (error! as NSError).userInfo["description"] as! String
                    let alert = KiiAlert.create(title: "Error", message: description)
                    self.present(alert, animated: true, completion: nil)
                })
                callback = nil
                return
            }
            objectList.append(contentsOf: results as! [KiiObject])

            // Check if more KiiObjects exit.
            if nextQuery == nil {
                progress.dismiss(animated: true, completion: nil)
                self.navigationItem.rightBarButtonItem = self.addButton
                self.items = objectList
                self.tableView.reloadData()
                callback = nil
            } else {
                // Get the remaining KiiObjects.
                bucket.execute(nextQuery, with: callback!)
            }
        }
        // Call the KiiCloud API to query KiiObjects.
        bucket.execute(query, with: callback!)
    }

    func calcTotal() -> Double {
        var total = 0
        for obj in self.items {
            let type = (obj.getForKey(BalanceItem.FieldType) as! NSNumber).intValue
            let amount = (obj.getForKey(BalanceItem.FieldAmount) as! NSNumber).intValue
            if type == BalanceItemType.Income.rawValue {
                total += amount
            } else {
                total -= amount
            }
        }
        return Double(total) / 100.0;
    }
}
