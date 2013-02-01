//
//  KiiBalanceDetailViewController.h
//  KiiBalanceApp
//
//  Created by Riza Alaudin Syah on 11/13/12.
//  Copyright (c) 2012 Kii Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KiiBalanceDetailViewController : UITableViewController<UITextFieldDelegate>{
    
}

@property(nonatomic,strong) IBOutlet UITextField* itemName;
@property(nonatomic,strong) IBOutlet UITextField* itemAmount;

@property(nonatomic,strong) IBOutlet UISegmentedControl* typeSegment;

-(IBAction)saveAction:(id)sender;


@end
