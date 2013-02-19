//
//  KiiAppSingleton.m
//  KiiPhotos
//
//  Created by Riza Alaudin Syah on 10/30/12.
//  Copyright (c) 2012 Kii Corporation. All rights reserved.
//

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
        
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

-(void) registerToken {
   
    if (nil==_currentUser) {
        return;
    }
    
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    [prefs setObject:[self.currentUser accessToken] forKey:Kii_TOKEN_KEY];
    
}
-(BOOL) checkUserToken{
    [self.currentUser accessToken];
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    return [prefs objectForKey:Kii_TOKEN_KEY]!=nil;
    
}
-(BOOL) loginWithToken{
    
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
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    [prefs removeObjectForKey:Kii_TOKEN_KEY];
    _currentUser=nil;
    
}

@end
