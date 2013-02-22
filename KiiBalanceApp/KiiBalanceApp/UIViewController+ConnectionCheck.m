//
//  UIViewController+ConnectionCheck.m
//  KiiBalanceApp
//
//  Created by Riza Alaudin Syah on 2/19/13.
//  Copyright (c) 2013 Kii Corporation. All rights reserved.
//

#import "UIViewController+ConnectionCheck.h"
#import "KiiAppSingleton.h"
#import "Reachability.h"
#import "WBErrorNoticeView.h"


@implementation UIViewController (ConnectionCheck)

-(BOOL) isNetworkConnected{
    if (nil==[KiiAppSingleton sharedInstance].internetReach ) {
        [KiiAppSingleton sharedInstance].internetReach  = [Reachability reachabilityForInternetConnection];
    }
    if (nil!=[KiiAppSingleton sharedInstance].errorNotice) {
        [[KiiAppSingleton sharedInstance].errorNotice dismissNotice];
    }
    NetworkStatus remoteHostStatus = [[KiiAppSingleton sharedInstance].internetReach currentReachabilityStatus];
    
    if(remoteHostStatus == NotReachable) {
        NSLog(@"not reachable");
        WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:self.view title:@"Network Error" message:@"Check your network connection."];
        notice.sticky = YES;
        [notice show];
        [KiiAppSingleton sharedInstance].errorNotice=notice;
        
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChanged:) name:kReachabilityChangedNotification object:nil];
    
    [[KiiAppSingleton sharedInstance].internetReach startNotifier];
    
    return remoteHostStatus != NotReachable;
}

- (void)networkChanged:(NSNotification *)notification
{
    Reachability* reachability=[KiiAppSingleton sharedInstance].internetReach;
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if(remoteHostStatus == NotReachable) {
        NSLog(@"not reachable");
        if (nil!=[KiiAppSingleton sharedInstance].errorNotice) {
            [[KiiAppSingleton sharedInstance].errorNotice dismissNotice];
        }
        WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:self.view title:@"Network Error" message:@"Check your network connection."];
        notice.sticky = YES;
        [notice show];
        [KiiAppSingleton sharedInstance].errorNotice=notice;
       
    }
    else {
        [[KiiAppSingleton sharedInstance].errorNotice dismissNotice];
        
        [KiiAppSingleton sharedInstance].needToRefresh=YES;
        [self viewDidAppear:NO];
    }
}

@end
