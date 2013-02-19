//
//  KiiAppSingleton.h
//  KiiPhotos
//
//  Created by Riza Alaudin Syah on 10/30/12.
//  Copyright (c) 2012 Kii Corporation. All rights reserved.
//  

#import <Foundation/Foundation.h>


@class KiiUser;
/* This is singleton class.
 
 */
@class Reachability,WBErrorNoticeView;
@interface KiiAppSingleton : NSObject{
    KiiUser* currentUser;
    
}

@property(nonatomic,strong) WBErrorNoticeView *errorNotice;
@property(nonatomic,strong) Reachability* internetReach;
@property(nonatomic,strong)     KiiUser* currentUser;
@property(nonatomic,strong) NSString* selectedCountry;
@property(nonatomic, strong) NSString* selectedObjectURI;
@property(nonatomic,assign) BOOL needToRefresh;
+(KiiAppSingleton*) sharedInstance;

-(void) registerToken;
-(BOOL) checkUserToken;
-(BOOL) loginWithToken;
-(void)doLogOut;
@end
