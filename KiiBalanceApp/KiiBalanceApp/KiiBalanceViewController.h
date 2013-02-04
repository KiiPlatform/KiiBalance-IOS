//
//  KiiBalanceViewController.h
//  KiiBalanceApp
//
//  Created by Riza Alaudin Syah on 11/13/12.
//  Copyright (c) 2012 Kii Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KiiBalanceViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
}

@property(nonatomic,strong) IBOutlet UITableView* tableView;
@property(nonatomic,strong) IBOutlet UILabel* totalLbl;

@end
