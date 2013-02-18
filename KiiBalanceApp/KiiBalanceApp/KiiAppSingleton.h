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
@interface KiiAppSingleton : NSObject{
    KiiUser* currentUser;
    
}



@property(nonatomic,strong)     KiiUser* currentUser;

@property(nonatomic, strong) NSString* selectedObjectURI;
@property(nonatomic,assign) BOOL needToRefresh;
+(KiiAppSingleton*) sharedInstance;

-(void) registerToken;
-(BOOL) checkUserToken;
-(BOOL) loginWithToken;
-(void)doLogOut;
@end
