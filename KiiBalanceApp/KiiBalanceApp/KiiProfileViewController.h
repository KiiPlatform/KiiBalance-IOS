//
//  KiiProfileViewController.h
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

#import <UIKit/UIKit.h>

@interface KiiProfileViewController : UITableViewController<UIAlertViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong) IBOutlet UILabel* userName;
@property(nonatomic,strong) IBOutlet UITextField* userDisplayName;
@property(nonatomic,strong) IBOutlet UITextField* userEmail;
@property(nonatomic,strong) IBOutlet UITextField* userPhone;
@property(nonatomic,strong) IBOutlet UITextField* userCountry;

-(IBAction)saveProfile:(id)sender;
-(void) setAsInitial;
@end

@interface KIICountrySetting : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>


@property(nonatomic,weak) IBOutlet UIPickerView *countryPicker;

-(IBAction)selectCountry:(id)sender;
-(void) setAsInitial;

@end
