//
//  KiiProfileViewController.m
//  KiiPhotos
//
//  Created by Riza Alaudin Syah on 11/1/12.
//  Copyright (c) 2012 Kii Corporation. All rights reserved.
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

#import "KiiProfileViewController.h"
#import "KiiAppSingleton.h"
#import "KiiUserValidation.h"
#import "MBProgressHUD.h"
#import <KiiSDK/Kii.h>
#import "NSString+Validation.h"

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
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==4) {
        if (isInitial) {
            [self performSegueWithIdentifier:@"countryInitSegue" sender:self];
        }else{
            [self performSegueWithIdentifier:@"changeCountry" sender:self];
        }
    }
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

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (![[KiiAppSingleton sharedInstance].selectedCountry isEqualToString:@""]&&[KiiAppSingleton sharedInstance].selectedCountry!=nil) {
        _userCountry.text=[KiiAppSingleton sharedInstance].selectedCountry;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) _saveProfile{
    NSError *error;
    KiiUser *user = [KiiUser currentUser];
    
    if (_userDisplayName.text!=nil&&![_userDisplayName.text isEqualToString:@""]&&_userDisplayName.text!=user.displayName) {
        [user setDisplayName:_userDisplayName.text];
        [user saveSynchronous:&error];
        if(error != nil) {
            // Display Name change failed
            // Please check error description/code to see what went wrong...
            [KiiUserValidation showError:error];
            return;
        }
    }
    if (_userEmail.text!=nil&&![_userEmail.text isEqualToString:@""]&&_userEmail.text!=user.email) {
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
    if (_userPhone.text!=nil&&![_userPhone.text isEqualToString:@""]&&_userPhone.text!=user.phoneNumber) {
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
    [KiiAppSingleton sharedInstance].selectedCountry=nil;
}
-(IBAction)saveProfile:(id)sender{
    if (![self isNetworkConnected]) {
        return;
    }
    NSError *error;
    if(_userDisplayName.text!=nil&&![_userDisplayName.text isEqualToString:@""]&&![_userDisplayName.text displaynameIsValid]){
        
        error=[KiiError invalidUsername];
        [KiiUserValidation showError:error];
        return;
    }
    
    if(_userEmail.text!=nil&&![_userEmail.text isEqualToString:@""]&&![_userEmail.text emailIsValid]){
        
        error=[KiiError invalidEmailFormat];
        [KiiUserValidation showError:error];
        return;
    }
    
    if(_userPhone.text!=nil&&![_userPhone.text isEqualToString:@""]&&![_userPhone.text phoneNumberIsValid]){
        
        error=[KiiError invalidPhoneFormat];
        [KiiUserValidation showError:error];
        return;
    }
    
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

-(IBAction)changeCountry:(id)sender{
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    KIICountrySetting* cSetting=[segue destinationViewController];
    
    if ([[segue identifier] isEqualToString:@"countryInitSegue"]) {
        [cSetting setAsInitial];
    }
}
@end


@interface KIICountrySetting (){
    NSArray *countryNames;
    BOOL isInitial;
}

@end

@implementation KIICountrySetting

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
    countryNames=@[@"US",@"JP"];
	// Do any additional setup after loading the view.
}

-(IBAction)selectCountry:(id)sender{
    if (isInitial) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    
}
-(void) setAsInitial{
    isInitial=YES;
}
#pragma mark -
#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return [countryNames count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return [countryNames objectAtIndex:row];
}

#pragma mark -
#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    [KiiAppSingleton sharedInstance].selectedCountry=[countryNames objectAtIndex:row];
    
}

@end
