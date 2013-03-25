//
//  KiiLoginViewController.m
//  KiiPhotos
//
//  Created by Riza Alaudin Syah on 10/30/12.
//  Copyright (c) 2012 Kii Corporation. All rights reserved.
//
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.


#import "KiiLoginViewController.h"
#import "KiiAppSingleton.h"
#import "KiiUserValidation.h"
#import <KiiSDK/Kii.h>
#import "KiiProfileViewController.h"
#import "MBProgressHUD.h"
typedef enum{
    kKiiLogin,
    kKiiRegister,
} KiiAuthType;

@interface KiiLoginViewController (){
    KiiAuthType authType;
    MBProgressHUD* hud;
}
-(void) doKiiUserAuthWithUserName:(NSString*) username andPassword:(NSString*) password;

@end

@implementation KiiLoginViewController

@synthesize userName=_userName;
@synthesize userPassword= _userPassword;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self isNetworkConnected];
    
    hud=[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark IBAction
-(IBAction)doLogin:(id)sender {
    if (![self isNetworkConnected]) {
        return;
    }
    authType=kKiiLogin;
    [self doKiiUserAuthWithUserName:_userName.text andPassword:_userPassword.text];
}
-(IBAction) doRegister:(id)sender {
    if (![self isNetworkConnected]) {
        return;
    }
    authType=kKiiRegister;
    [self doKiiUserAuthWithUserName:_userName.text andPassword:_userPassword.text];
}


#pragma mark - Kii Login and Register
-(void) doKiiUserAuthWithUserName:(NSString*) username andPassword:(NSString*) password{
    

    KiiUser* userObj=nil;
    
    
    
    
    switch (authType) {
        case kKiiLogin:
            // Login
            [KiiUser authenticate:username withPassword:password andDelegate:self andCallback:@selector(authProcessComplete:withError:)];
            
            break;
        case kKiiRegister:
            // Register
            userObj = [KiiUser userWithUsername:username andPassword:password];
           
            [userObj performRegistration:self withCallback:@selector(authProcessComplete:withError:)];
            
            break;
            
        default:
            break;
    }
   
    [hud show:YES];
    
}

#pragma mark -
#pragma mark Handlers

- (void) authProcessComplete:(KiiUser*)user withError:(KiiError*)error {
    [hud hide:YES];
    // the request was successful
    if(error == nil) {
        // do something with the user
        
        [KiiAppSingleton sharedInstance].currentUser=user;
        [[KiiAppSingleton sharedInstance] registerToken];
        [hud removeFromSuperview];
        
        switch (authType) {
            case kKiiLogin:
                // Login
               
                [self performSegueWithIdentifier:@"mainSegue" sender:nil];
                
                break;
            case kKiiRegister:
                // Register
                [self performSegueWithIdentifier:@"initProfileSegue" sender:nil];
                
                break;
                
            default:
                break;
        }

    }
    
    else {
        // there was a problem
        [KiiUserValidation showError:error];
        
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"%@",[segue identifier]);
    
    if([[segue identifier] isEqualToString:@"initProfileSegue"]){
        KiiProfileViewController* profileVC=(KiiProfileViewController*)segue.destinationViewController;
        [profileVC setAsInitial];
        
    }
    
    
    
}

@end
