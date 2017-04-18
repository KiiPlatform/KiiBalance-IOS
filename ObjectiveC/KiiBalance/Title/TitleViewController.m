//
//  TitleViewController.m
//  KiiBalance
//
//  Created by Kii on 2015/11/11.
//  Copyright © 2015年 kii. All rights reserved.
//

#import "TitleViewController.h"
#import "AppDelegate.h"
#import "KiiProgress.h"
#import <KiiSDK/Kii.h>

@interface TitleViewController ()

@end

@implementation TitleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // If user already logged in, Go to Balance list view
    [KiiUser authenticateWithStoredCredentials:^(KiiUser *user, NSError *error) {
        if (error != nil) {
            // shows Title page
            return;
        }
        UIAlertController *progress = [KiiProgress createWithMessage:@"Login..."];
        [self presentViewController:progress animated:NO completion:nil];
        
        [user refreshWithBlock:^(KiiUser *user, NSError *error) {
            [progress dismissViewControllerAnimated:NO completion:nil];
            
            if (error != nil) {
                return;
            }
            AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            [app showBalanceList];
        }];
    }];
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

@end
