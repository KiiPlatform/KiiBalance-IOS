//
//  KiiUserValidation.h
//  KiiPhotos
//
//  Created by Riza Alaudin Syah on 10/30/12.
//  Copyright (c) 2012 Kii Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KiiError;
@interface KiiUserValidation : NSObject

+(void) showError:(KiiError*) error;
+(BOOL) validateUserName:(NSString*) userName;
+(BOOL) validateUserPassword:(NSString*) password;
@end
