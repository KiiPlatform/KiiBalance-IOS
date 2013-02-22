//
//  UIViewController+ConnectionCheck.h
//  KiiBalanceApp
//
//  Created by Riza Alaudin Syah on 2/19/13.
//  Copyright (c) 2013 Kii Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UIViewController (ConnectionCheck)

-(BOOL) isNetworkConnected;
- (void)networkChanged:(NSNotification *)notification;
@end
