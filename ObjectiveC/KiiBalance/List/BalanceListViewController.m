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
#import "BalanceListViewController.h"
#import "TotalAmountTableViewCell.h"
#import "BalanceItemTableViewCell.h"
#import "EditItemViewController.h"
#import "AppDelegate.h"
#import "BalanceItem.h"
#import "KiiAlert.h"
#import "KiiProgress.h"
#import <KiiSDK/Kii.h>

@interface BalanceListViewController ()

@end

@implementation BalanceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Add buttons to NavigationItem.
    self.navigationItem.leftBarButtonItem = self.logoutButton;
    self.navigationItem.rightBarButtonItem = self.refreshButton;

    self.items = [[NSMutableArray alloc] init];
    [self getItems];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    EditItemViewController *next = [segue destinationViewController];
    if ([segue.identifier isEqualToString:@"addItem"]) {
        // Initialize the edit screen with empty values.
        next.mode = EditItemViewModeAdd;
        next.objectId = nil;
        next.name = @"";
        next.type = BalanceItemTypeExpense;
        next.amount = 0;
        next.doneEditDelegate = self;
    } else if ([segue.identifier isEqualToString:@"editItem"]) {
        // Initialize the edit screen with values from the tapped KiiObject.
        KiiObject *obj = (KiiObject*)sender;
        next.mode = EditItemViewModeEdit;
        next.objectId = obj.uuid;
        next.name = [obj getObjectForKey:BalanceItemFieldName];
        next.type = [[obj getObjectForKey:BalanceItemFieldType] intValue];
        next.amount = [[obj getObjectForKey:BalanceItemFieldAmount] intValue];
        next.doneEditDelegate = self;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // Clear the selection in the table view.
    NSIndexPath* selectedRow = self.tableView.indexPathForSelectedRow;
    if (selectedRow != nil) {
        [self.tableView deselectRowAtIndexPath:selectedRow animated: true];
    }
}

#pragma mark - UI Event

- (IBAction)logoutClicked:(id)sender {
    [KiiUser logOut];

    // Show the title screen.
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app showTitle];
}

- (IBAction)refreshClicked:(id)sender {
    [self getItems];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return;
    }

    // Pass a KiiObject to the prepare(for:sender:) method.
    KiiObject *obj = self.items[indexPath.row];
    [self performSegueWithIdentifier:@"editItem" sender:obj];
}

- (IBAction)doneEditItem:(UIStoryboardSegue *)segue {
    [self.tableView reloadData];
}

#pragma mark - DoneEditDelegate

- (void)addItem: (KiiObject*)object {
    [self.items addObject:object];
}

- (void)updateItem: (KiiObject*)object {
    // Replace a KiiObject in self.items.
    for (int i = 0; i < self.items.count; i++) {
        KiiObject *objectInItems = [self.items objectAtIndexedSubscript:i];
        if ([object.uuid isEqualToString:objectInItems.uuid]) {
            [self.items setObject:object atIndexedSubscript: i];
            break;
        }
    }
}

- (void)deleteItem: (KiiObject*)object {
    // Delete a KiiObject in self.items.
    for (int i = 0; i < self.items.count; i++) {
        KiiObject *objectInItems = [self.items objectAtIndexedSubscript:i];
        if ([object.uuid isEqualToString:objectInItems.uuid]) {
            [self.items removeObjectAtIndex:i];
            break;
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return self.items.count;
    }
}

- (NSString *)formatCurrency:(double) amount {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    formatter.minimumFractionDigits = 2;
    formatter.currencySymbol = @"$";
    NSString *text = [formatter stringFromNumber: [NSNumber numberWithDouble: amount]];
    return text;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        TotalAmountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Total" forIndexPath:indexPath];
        double total = [self calcTotal];
        if (total < 0) {
            cell.amountLabel.textColor = [UIColor redColor];
        } else {
            cell.amountLabel.textColor = [UIColor blackColor];
        }
        cell.amountLabel.text = [self formatCurrency: total];
        return cell;
    } else {
        BalanceItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        KiiObject *obj = self.items[indexPath.row];
        NSString *name = [obj getObjectForKey:BalanceItemFieldName];
        NSNumber *type = [obj getObjectForKey:BalanceItemFieldType];
        int amount = [(NSNumber*)[obj getObjectForKey:BalanceItemFieldAmount] doubleValue];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateStyle = NSDateFormatterMediumStyle;
        cell.dateLabel.text = [formatter stringFromDate:obj.created];
        
        double amountDisplay;
        cell.nameLabel.text = name;
        if ([type intValue] == BalanceItemTypeIncome) {
            cell.amountLabel.textColor = [UIColor blackColor];
            amountDisplay = amount / 100.0;
        } else {
            cell.amountLabel.textColor = [UIColor redColor];
            amountDisplay = -1 * amount / 100.0;
        }
        cell.amountLabel.text = [self formatCurrency: amountDisplay];
        return cell;
    }
}

#pragma mark - private method

- (void) getItems {
    KiiBucket *bucket = [[KiiUser currentUser] bucketWithName:BalanceItemBucket];

    // Create a query instance.
    KiiQuery *query = [KiiQuery queryWithClause:nil];
    // Sort KiiObjects by the _created field.
    [query sortByAsc:BalanceItemFieldCreated];

    UIAlertController *progress = [KiiProgress createWithMessage:@"Loading..."];
    [self presentViewController:progress animated:NO completion:nil];

    NSMutableArray *objectList = [[NSMutableArray alloc] init];

    // Define a recursive block to get all KiiObjects.
    __block KiiQueryResultBlock callback = ^(KiiQuery *query, KiiBucket *bucket, NSArray *results, KiiQuery *nextQuery, NSError *error) {
        if (error != nil) {
            [progress dismissViewControllerAnimated:YES completion:^{
                UIAlertController *alert = [KiiAlert createWithTitle:@"Error" andMessage:error.description];
                [self presentViewController:alert animated:YES completion:nil];
            }];
            callback = nil;
            return;
        }
        [objectList addObjectsFromArray:results];

        // Check if more KiiObjects exit.
        if (nextQuery == nil) {
            [progress dismissViewControllerAnimated:YES completion:nil];
            self.navigationItem.rightBarButtonItem = self.addButton;
            self.items = objectList;
            [self.tableView reloadData];
            callback = nil;
        } else {
            // Get the remaining KiiObjects.
            [bucket executeQuery:nextQuery withBlock:callback];
        }
    };
    // Call the KiiCloud API to query KiiObjects.
    [bucket executeQuery:query withBlock:callback];
}

- (double) calcTotal {
    long total = 0;
    for (KiiObject *obj in self.items) {
        NSNumber *type = [obj getObjectForKey:BalanceItemFieldType];
        long amount = [(NSNumber*)[obj getObjectForKey:BalanceItemFieldAmount] longValue];
        if ([type intValue] == BalanceItemTypeIncome) {
            total += amount;
        } else {
            total -= amount;
        }
    }
    return (double)(total / 100.0);
}

@end
