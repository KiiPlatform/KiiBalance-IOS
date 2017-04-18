//
//  RegisterViewController.m
//  KiiBalance
//
//  Created by Kii on 2015/11/11.
//  Copyright © 2015年 kii. All rights reserved.
//

#import "RegisterViewController.h"
#import "AppDelegate.h"
#import "KiiProgress.h"
#import "KiiAlert.h"
#import <KiiSDK/Kii.h>


@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Add "Register" button to NavigationItem
    self.navigationItem.rightBarButtonItem = self.registerButton;
    
    [self.usernameText becomeFirstResponder];
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

- (IBAction)backgroundTapped:(id)sender {
    [self closeKeyboard];
}

- (void)closeKeyboard{
    [self.usernameText resignFirstResponder];
    [self.passwordText resignFirstResponder];
}

- (IBAction)registerClicked:(id)sender {
    NSString *username = self.usernameText.text;
    NSString *password = self.passwordText.text;
    
    [self closeKeyboard];
    
    UIAlertController *alert = [KiiProgress createWithMessage:@"Registering..."];
    [self presentViewController:alert animated:NO completion:nil];
    
    KiiUser *user = [KiiUser userWithUsername:username andPassword:password];
    [user performRegistrationWithBlock:^(KiiUser *user, NSError *error) {
        if (error != nil) {
            [alert dismissViewControllerAnimated:YES completion:^{
                UIAlertController *alert = [KiiAlert createWithTitle:@"Error" andMessage:error.description];
                [self presentViewController:alert animated:YES completion:nil];
            }];
            return;
        }
        [alert dismissViewControllerAnimated:YES completion:nil];
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [app showBalanceList];
    }];
}
@end
