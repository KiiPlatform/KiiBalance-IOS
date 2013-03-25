//
//  UIViewController+ConnectionCheck.m
//  KiiBalanceApp
//
//  Created by Riza Alaudin Syah on 2/19/13.
//  Copyright (c) 2013 Kii Corporation. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

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
