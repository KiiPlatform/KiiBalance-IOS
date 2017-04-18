//
//  BalanceListViewController.h
//  KiiBalance
//
//  Created by Kii on 2015/11/11.
//  Copyright © 2015年 kii. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BalanceListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property(weak) IBOutlet UIBarButtonItem *logoutItem;
@property(weak) IBOutlet UIBarButtonItem *addItem;
@property(weak) IBOutlet UITableView *tableView;

@property NSMutableArray *array;
@end
