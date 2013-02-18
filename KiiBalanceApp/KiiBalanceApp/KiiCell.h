//
//  KiiCell.h
//  KiiBalanceApp
//
//  Created by Riza Alaudin Syah on 2/14/13.
//  Copyright (c) 2013 Kii Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KiiCell : UITableViewCell

@property(nonatomic,weak) IBOutlet UILabel* amountlabel;
@property(nonatomic,weak) IBOutlet UILabel* namelabel;
@property(nonatomic,weak) IBOutlet UILabel* datelabel;
@property(nonatomic,weak) IBOutlet UIImageView* iconType;
@end
