//
//  EditItemViewController.m
//  KiiBalance
//
//  Created by Kii on 2015/11/11.
//  Copyright © 2015年 kii. All rights reserved.
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
    // Do any additional setup after loading the view.

    // Add "Add" button to NavigationItem
    self.navigationItem.rightBarButtonItem = self.saveButton;
    
    // set values
    NSNumber *amount = [self.obj getObjectForKey:BalanceItemFieldAmount];
    self.amountText.text = (amount == nil) ? @"0" : [NSString stringWithFormat:@"%.2lf", ([amount doubleValue] / 100.0)];
    
    NSString *name = [self.obj getObjectForKey:BalanceItemFieldName];
    self.nameText.text = (name == nil) ? @"" : name;

    NSNumber *typeNumber = [self.obj getObjectForKey:BalanceItemFieldType];
    if (typeNumber == nil) {
        self.type = BalanceItemTypeExpense;
    } else {
        self.type = [typeNumber intValue];
    }
    [self refreshType];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.mode == EditItemViewModeAdd ? 1 : 2;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self.amountText becomeFirstResponder];
            break;
        case 1:
            [self.nameText becomeFirstResponder];
            break;
        case 2:
            [self.amountText resignFirstResponder];
            [self.nameText resignFirstResponder];
            [self showTypeDialog];
            break;
        default:
            break;
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
    // read input value
    double amount = [self.amountText.text doubleValue];
    NSString *name = self.nameText.text;
    int type = self.type;
    
    [self.obj setObject:[NSNumber numberWithInt:(int)(amount * 100)] forKey:BalanceItemFieldAmount];
    [self.obj setObject:name forKey:BalanceItemFieldName];
    [self.obj setObject:[NSNumber numberWithInt:type] forKey:BalanceItemFieldType];
    
    UIAlertController *progress = [KiiProgress createWithMessage:@"Saving Object..."];
    [self presentViewController:progress animated:NO completion:nil];
    
    // save:YES means force save. Overwrite the object in Kii Cloud even if it is updated by other devices.
    [self.obj save:YES withBlock:^(KiiObject *object, NSError *error) {
        if (error != nil) {
            [progress dismissViewControllerAnimated:NO completion:^{
                UIAlertController *alert = [KiiAlert createWithTitle:@"Error" andMessage:error.description];
                [self presentViewController:alert animated:YES completion:nil];                
            }];
            return;
        }
        // back
        [progress dismissViewControllerAnimated:NO completion:nil];
        [self performSegueWithIdentifier:@"doneEditItem" sender:object];
    }];
}

- (IBAction)deleteClicked:(id)sender {
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
    UIAlertController *progress = [KiiProgress createWithMessage:@"Deleting Object..."];
    [self presentViewController:progress animated:NO completion:nil];

    [self.obj deleteWithBlock:^(KiiObject *object, NSError *error) {
        if (error != nil) {
            [progress dismissViewControllerAnimated:NO completion:^{
                UIAlertController *alert = [KiiAlert createWithTitle:@"Error" andMessage:error.description];
                [self presentViewController:alert animated:YES completion:nil];
            }];
            return;
        }
        // back
        [progress dismissViewControllerAnimated:NO completion:nil];
        [self performSegueWithIdentifier:@"doneEditItem" sender:object];
    }];
}

@end
