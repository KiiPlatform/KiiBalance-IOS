//
//  KiiAppSingleton.m
//  KiiPhotos
//
//  Created by Riza Alaudin Syah on 10/30/12.
//  Copyright (c) 2012 Kii Corporation. All rights reserved.
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

#import "KiiAppSingleton.h"
#import <KiiSDK/Kii.h>
#import "Reachability.h"
#import "WBErrorNoticeView.h"

#define Kii_TOKEN_KEY @"KII_TOKEN"
@implementation KiiAppSingleton

@synthesize currentUser=_currentUser;

+(KiiAppSingleton*) sharedInstance {
    
    static KiiAppSingleton *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[KiiAppSingleton alloc] init];
        sharedInstance.internetReach=[Reachability reachabilityForInternetConnection];
        
    });
    return sharedInstance;
}

-(void) registerToken {
    //register KiiUser token to ns user default
    
    if (nil==_currentUser) {
        return;
    }
    
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    [prefs setObject:[self.currentUser accessToken] forKey:Kii_TOKEN_KEY];
    
}
-(BOOL) checkUserToken{
    //get KiiUser token from nsuser default
    [self.currentUser accessToken];
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    return [prefs objectForKey:Kii_TOKEN_KEY]!=nil;
    
}
-(BOOL) loginWithToken{
    //execute login with token
    
    KiiError* error;
    
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    NSString* token=[prefs objectForKey:Kii_TOKEN_KEY];
    _currentUser=[KiiUser authenticateWithTokenSynchronous:token andError:&error];
    
    if (error==nil) {
        
        return YES;
    }
    
    return NO;
}
-(void)doLogOut{
    //logout operation, remove KiiUser token from nsuserdefault
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    [prefs removeObjectForKey:Kii_TOKEN_KEY];
    _currentUser=nil;
    
}

@end
