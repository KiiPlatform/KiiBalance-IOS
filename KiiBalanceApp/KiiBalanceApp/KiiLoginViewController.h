//
//  KiiLoginViewController.h
//  KiiPhotos
//
//  Created by Riza Alaudin Syah on 10/30/12.
//  Copyright (c) 2012 Kii Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KiiLoginViewController : UIViewController <UIAlertViewDelegate,UITextFieldDelegate>{
    UITextField* userName;
    UITextField* userPassword;
    
}
@property(nonatomic,strong) IBOutlet UITextField* userName;
@property(nonatomic,strong) IBOutlet UITextField* userPassword;

-(IBAction) doLogin:(id)sender;
-(IBAction) doRegister:(id)sender;

@end
