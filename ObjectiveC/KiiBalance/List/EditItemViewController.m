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
#import "EditItemViewController.h"
#import "BalanceItem.h"
#import "KiiProgress.h"
#import "KiiAlert.h"

@interface EditItemViewController ()

@end

@implementation EditItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Add buttons to NavigationItem.
    self.navigationItem.rightBarButtonItem = self.saveButton;

    // Set default values.
    self.amountText.text = [NSString stringWithFormat:@"%.2lf", ((double)self.amount / 100.0)];
    self.nameText.text = self.name;
    [self refreshType];
}

- (void)closeKeyboard{
    [self.amountText resignFirstResponder];
    [self.nameText resignFirstResponder];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.mode == EditItemViewModeAdd) {
        return 1;
    } else {
        return 2;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // If the user tapped the "Type" field, open the type dialog.
    if (indexPath.row == 2) {
        [self.amountText resignFirstResponder];
        [self.nameText resignFirstResponder];
        [self showTypeDialog];
    }
}

- (void)showTypeDialog {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *incomeAction = [UIAlertAction actionWithTitle:@"Income"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action) {
        self.type = BalanceItemTypeIncome;
        [self refreshType];
    }];
    [alert addAction:incomeAction];
    UIAlertAction *expenseAction = [UIAlertAction actionWithTitle:@"Expense"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
        self.type = BalanceItemTypeExpense;
        [self refreshType];
    }];
    [alert addAction:expenseAction];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void) refreshType {
    switch (self.type) {
        case BalanceItemTypeIncome:
            self.typeLabel.text = @"Income";
            break;
        case BalanceItemTypeExpense:
            self.typeLabel.text = @"Expense";
            break;
        default:
            break;
    }
}

- (IBAction)saveClicked:(id)sender {
    // Read input values.
    double amount = (int)([self.amountText.text doubleValue] * 100);
    NSString *name = self.nameText.text;
    int type = self.type;

    // Set the default name if the value is empty.
    if ([name isEqualToString:@""]) {
        if (type == BalanceItemTypeIncome) {
            name = @"Income";
        } else {
            name = @"Expense";
        }
    }

    // Create a KiiObject instance.
    KiiBucket *bucket = [[KiiUser currentUser] bucketWithName:BalanceItemBucket];
    KiiObject *object;
    if (self.mode == EditItemViewModeAdd) {
        object = [bucket createObject];
    } else {
        object = [bucket createObjectWithID:self.objectId];
    }

    [object setObject:[NSNumber numberWithInt:amount] forKey:BalanceItemFieldAmount];
    [object setObject:name forKey:BalanceItemFieldName];
    [object setObject:[NSNumber numberWithInt:type] forKey:BalanceItemFieldType];

    // Show the progress.
    UIAlertController *progress = [KiiProgress createWithMessage:@"Saving Object..."];
    [self presentViewController:progress animated:NO completion:nil];

    // Call the Kii Cloud API for saving the KiiObject on Kii Cloud.
    [object saveWithBlock:^(KiiObject *object, NSError *error) {
        if (error != nil) {
            [progress dismissViewControllerAnimated:YES completion:^{
                UIAlertController *alert = [KiiAlert createWithTitle:@"Error" andMessage:error.description];
                [self presentViewController:alert animated:YES completion:nil];
            }];
            return;
        }

        // Return to the data listing screen.
        [self closeKeyboard];
        if (self.mode == EditItemViewModeAdd) {
            [self.doneEditDelegate addItem:object];
        } else {
            [self.doneEditDelegate updateItem:object];
        }
        [progress dismissViewControllerAnimated:NO completion:nil];
        [self performSegueWithIdentifier:@"doneEditItem" sender:nil];
    }];
}

- (IBAction)deleteClicked:(id)sender {
    [self closeKeyboard];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Confirm"
                                                                   message:@"Would you delete this item?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
    [alert addAction:cancelAction];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action) {
        [self deleteItem];
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) deleteItem {
    // Create a KiiObject instance with its ID.
    KiiBucket *bucket = [[KiiUser currentUser] bucketWithName:BalanceItemBucket];
    KiiObject *object = [bucket createObjectWithID:self.objectId];

    // Show the progress.
    UIAlertController *progress = [KiiProgress createWithMessage:@"Deleting Object..."];
    [self presentViewController:progress animated:NO completion:nil];

    // Call the Kii Cloud API for deleting the KiiObject on Kii Cloud.
    [object deleteWithBlock:^(KiiObject *object, NSError *error) {
        if (error != nil) {
            [progress dismissViewControllerAnimated:NO completion:^{
                UIAlertController *alert = [KiiAlert createWithTitle:@"Error" andMessage:error.description];
                [self presentViewController:alert animated:YES completion:nil];
            }];
            return;
        }

        // Return to the data listing screen.
        [self.doneEditDelegate deleteItem:object];
        [progress dismissViewControllerAnimated:NO completion:nil];
        [self performSegueWithIdentifier:@"doneEditItem" sender:nil];
    }];
}

@end
