//
//  EditItemViewController.h
//  KiiBalance
//
//  Created by Kii on 2015/11/11.
//  Copyright © 2015年 kii. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KiiSDK/Kii.h>

typedef NS_ENUM(NSUInteger, EditItemViewMode) {
    EditItemViewModeAdd,
    EditItemViewModeEdit,
};

@interface EditItemViewController : UITableViewController

@property(weak) IBOutlet UIBarButtonItem *saveButton;
@property(weak) IBOutlet UITextField *amountText;
@property(weak) IBOutlet UITextField *nameText;
@property(weak) IBOutlet UILabel *typeLabel;

@property EditItemViewMode mode;
@property KiiObject *obj;

@property int type;

@end

