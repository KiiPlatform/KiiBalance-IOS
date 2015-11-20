//
//  BalanceListViewController.m
//  KiiBalance
//
//  Created by Kii on 2015/11/11.
//  Copyright © 2015年 kii. All rights reserved.
//

#import "BalanceListViewController.h"
#import "TotalAmountTableViewCell.h"
#import "BalanceItemTableViewCell.h"
#import "EditItemViewController.h"
#import "AppDelegate.h"
#import "BalanceItem.h"
#import "KiiAlert.h"
#import <KiiSDK/Kii.h>

@interface BalanceListViewController ()

@end

@implementation BalanceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Add "Logout" button to NavigationItem
    self.navigationItem.leftBarButtonItem = self.logoutItem;
    
    // Add "Add" button to NavigationItem
    self.navigationItem.rightBarButtonItem = self.addItem;
    
    self.array = [[NSMutableArray alloc] init];
    [self queryObjects];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    EditItemViewController *next = [segue destinationViewController];
    if ([segue.identifier isEqualToString:@"addItem"]) {
        next.obj = [[[KiiUser currentUser] bucketWithName:BalanceItemBucket] createObject];
        next.mode = EditItemViewModeAdd;
    } else if ([segue.identifier isEqualToString:@"editItem"]) {
        KiiObject *obj = (KiiObject*)sender;
        next.obj = obj;
        next.mode = EditItemViewModeEdit;
    }
}

#pragma mark - UI Event
- (IBAction)logoutClicked:(id)sender {
    [KiiUser logOut];
    // show title page
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    [app showTitle];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return;
    }
    KiiObject *obj = self.array[indexPath.row];
    [self performSegueWithIdentifier:@"editItem" sender:obj];
}

- (IBAction)doneEditItem:(UIStoryboardSegue *)segue {
    [self.array removeAllObjects];
    [self queryObjects];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return self.array.count;
    }
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
        cell.amountLabel.text = [NSString stringWithFormat:@"%.2lf", [self calcTotal]];
        return cell;
    } else {
        BalanceItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        KiiObject *obj = self.array[indexPath.row];
        NSString *name = [obj getObjectForKey:BalanceItemFieldName];
        NSNumber *type = [obj getObjectForKey:BalanceItemFieldType];
        double amount = [(NSNumber*)[obj getObjectForKey:BalanceItemFieldAmount] doubleValue];
        
        cell.nameLabel.text = name;
        if ([type intValue] == BalanceItemTypeIncome) {
            cell.amountLabel.textColor = [UIColor blackColor];
            amount = amount / 100.0;
        } else {
            cell.amountLabel.textColor = [UIColor redColor];
            amount = -1 * amount / 100.0;
        }
        cell.amountLabel.text = [NSString stringWithFormat:@"%.2lf", amount];
        return cell;
    }
}

#pragma mark - private method
- (void) queryObjects {
    // fetch all objects
    KiiBucket *bucket = [[KiiUser currentUser] bucketWithName:BalanceItemBucket];
    KiiQuery *query = [KiiQuery queryWithClause:nil];
    [query sortByAsc:BalanceItemFieldCreated];
    
    KiiQueryResultBlock callback = ^(KiiQuery *query, KiiBucket *bucket, NSArray *results, KiiQuery *nextQuery, NSError *error) {
        if (error != nil) {
            UIAlertController *alert = [KiiAlert createWithTitle:@"Error" andMessage:error.description];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        [self.array addObjectsFromArray:results];
        
        if (nextQuery == nil) {
            [self.tableView reloadData];
        } else {
            [bucket executeQuery:nextQuery withBlock:callback];
        }
    };
    [bucket executeQuery:query withBlock:callback];
}

- (double) calcTotal {
    long total = 0;
    for (KiiObject *obj in self.array) {
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
