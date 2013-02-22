//
//  KiiSettingViewController.m
//  KiiPhotos
//
//  Created by Riza Alaudin Syah on 11/1/12.
//  Copyright (c) 2012 Kii Corporation. All rights reserved.
//

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
