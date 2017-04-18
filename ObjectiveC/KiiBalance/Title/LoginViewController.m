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
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "KiiProgress.h"
#import "KiiAlert.h"
#import <KiiSDK/Kii.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Add "Login" button to NavigationItem.
    self.navigationItem.rightBarButtonItem = self.loginButton;

    [self.usernameText becomeFirstResponder];
}

- (IBAction)backgroundTapped:(id)sender {
    [self closeKeyboard];
}

- (void)closeKeyboard{
    [self.usernameText resignFirstResponder];
    [self.passwordText resignFirstResponder];
}

#pragma mark - UI event

- (IBAction)loginClicked:(id)sender {
    // Get a username and password.
    NSString *username = self.usernameText.text;
    NSString *password = self.passwordText.text;

    [self closeKeyboard];

    // Show the progress.
    UIAlertController *progress = [KiiProgress createWithMessage:@"Login..."];
    [self presentViewController:progress animated:NO completion:nil];

    // Log in the user.
    [KiiUser authenticate:username withPassword:password andBlock:^(KiiUser *user, NSError *error) {
        if (error != nil) {
            [progress dismissViewControllerAnimated:YES completion:^{
                UIAlertController *alert = [KiiAlert createWithTitle:@"Error" andMessage:error.description];
                [self presentViewController:alert animated:YES completion:nil];
            }];
            return;
        }
        [progress dismissViewControllerAnimated:YES completion:nil];
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [app showBalanceList];
    }];
}

@end
