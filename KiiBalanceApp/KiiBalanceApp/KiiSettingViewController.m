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
    KiiUser* user=[KiiAppSingleton sharedInstance].currentUser;
    //NSString* displayName=nil;
    
   // if(nil==user.displayName)
    self.displayNameLbl.text=user.displayName;
    self.userNameLbl.text=user.username;
	// Do any additional setup after loading the view.
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"%@",[segue identifier]);
    
    
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
