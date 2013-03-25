//
//  KiiSettingViewController.m
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

#import "KiiSettingViewController.h"
#import "KiiAppSingleton.h"
#import <KiiSDK/Kii.h>
@interface KiiSettingViewController ()
@end

@implementation KiiSettingViewController

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
    
	// Do any additional setup after loading the view.
}


-(void) viewDidAppear:(BOOL)animated{
    //get current user from singleton object
    KiiUser* user=[KiiAppSingleton sharedInstance].currentUser;
    
    self.displayNameLbl.text=user.displayName;
    self.userNameLbl.text=user.username;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
