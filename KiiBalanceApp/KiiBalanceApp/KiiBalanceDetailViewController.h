//
//  KiiBalanceDetailViewController.h
//  KiiBalanceApp
//
//  Created by Riza Alaudin Syah on 11/13/12.
//  Copyright (c) 2012 Kii Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KiiObject;
@interface KiiBalanceDetailViewController : UITableViewController<UITextFieldDelegate>{
    
}

@property(nonatomic,weak) IBOutlet UITextField* itemName;
@property(nonatomic,weak) IBOutlet UITextField* itemAmount;
@property(nonatomic,weak) IBOutlet UITextField* amountCent;
@property(nonatomic,weak) IBOutlet UISegmentedControl* typeSegment;
@property(nonatomic,strong) KiiObject* selectedObject;
-(IBAction)saveAction:(id)sender;


@end
