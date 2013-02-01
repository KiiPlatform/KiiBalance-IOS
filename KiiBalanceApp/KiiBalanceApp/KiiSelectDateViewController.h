//
//  KiiSelectDateViewController.h
//  KiiBalanceApp
//
//  Created by Riza Alaudin Syah on 11/13/12.
//  Copyright (c) 2012 Kii Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KiiSelectDateViewController : UIViewController

@property(nonatomic,strong) IBOutlet UIDatePicker* picker;

-(IBAction)saveDate:(id)sender;

@end
