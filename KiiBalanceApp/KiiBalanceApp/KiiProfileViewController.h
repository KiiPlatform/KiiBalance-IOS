//
//  KiiProfileViewController.h
//  KiiPhotos
//
//  Created by Riza Alaudin Syah on 11/1/12.
//  Copyright (c) 2012 Kii Corporation. All rights reserved.
//

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
