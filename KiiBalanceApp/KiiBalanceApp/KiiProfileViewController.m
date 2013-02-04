//
//  KiiProfileViewController.m
//  KiiPhotos
//
//  Created by Riza Alaudin Syah on 11/1/12.
//  Copyright (c) 2012 Kii Corporation. All rights reserved.
//

#import "KiiProfileViewController.h"
#import "KiiAppSingleton.h"
#import "KiiUserValidation.h"
#import "MBProgressHUD.h"
#import <KiiSDK/Kii.h>

@interface KiiProfileViewController (){
    BOOL isInitial;
}
@end

@implementation KiiProfileViewController

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
    KiiUser* user=[KiiAppSingleton sharedInstance].currentUser;
    if(user.username!=nil)
        _userName.text=user.username;
    
    _userDisplayName.text=user.displayName;
    _userEmail.text=user.email;
    _userPhone.text=user.phoneNumber;
    _userCountry.text=user.country;
    
    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) _saveProfile{
    KiiError *error;
    KiiUser *user = [KiiUser currentUser];
    [user setDisplayName:_userDisplayName.text];
    [user saveSynchronous:&error];
    if(error != nil) {
        // Display Name change failed
        // Please check error description/code to see what went wrong...
        [KiiUserValidation showError:error];
        return;
    }
    
    if (_userEmail.text!=nil&&_userEmail.text!=user.email) {
        // User - Setting predefined attributes (profile - email)
        [user changeEmailSynchronous:_userEmail.text withError:&error];
        //[user set]
        if(error != nil) {
            // Email change failed
            // Please check error description/code to see what went wrong...
            [KiiUserValidation showError:error];
            return;
        }
    }
    
    
    // User - Setting predefined attributes (profile - phone number)
    if (_userPhone.text!=nil&&_userPhone.text!=user.phoneNumber) {
        [user changePhoneSynchronous:_userPhone.text withError:&error];
        if(error != nil) {
            // Email change failed
            // Please check error description/code to see what went wrong...
            [KiiUserValidation showError:error];
            return;
        }
    }
    
    
    
    // User - Setting predefined attributes (profile - country)
    [user setCountry:_userCountry.text];
    
    [user saveSynchronous:&error];
    if(error != nil) {
        // Country change failed
        // Please check error description/code to see what went wrong...
        [KiiUserValidation showError:error];
        return;
    }
    [[KiiAppSingleton sharedInstance] loginWithToken];
}
-(IBAction)saveProfile:(id)sender{
    
    MBProgressHUD* hud=[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    [hud showAnimated:YES whileExecutingBlock:^(){
        [self _saveProfile];
    } completionBlock:^(){
        [hud removeFromSuperview];
        
        if (isInitial) {
            [self performSegueWithIdentifier:@"initialProfileSaveSegue" sender:nil];
            
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
    
    
    
}
-(void) setAsInitial{
    isInitial=YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    NSLog(@"%@",identifier);
    if ([identifier isEqualToString:@"initProfileSegue"]) {
        isInitial=YES;
    }else{
        isInitial=NO;
    }
    return YES;
}
@end
