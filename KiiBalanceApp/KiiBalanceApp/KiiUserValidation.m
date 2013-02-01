//
//  KiiUserValidation.m
//  KiiPhotos
//
//  Created by Riza Alaudin Syah on 10/30/12.
//  Copyright (c) 2012 Kii Corporation. All rights reserved.
//

#import "KiiUserValidation.h"
#import <KiiSDK/Kii.h>

@implementation KiiUserValidation

+(BOOL) validateUserName:(NSString*) userName{
    
    return YES;
}
+(BOOL) validateUserPassword:(NSString*) password{
    
    return YES;
}
+(void) showError:(KiiError*) error{
    
    switch (error.code) {
        
        case 302:
            //invalid grant (password not match)
            break;
        case 307:
            //Invalid username format
            /*
             Invalid username format. The username must be 5-50 alphanumeric characters - the first character must be a letter.
             */
            break;
        case 306:
            //Invalid user
            /*
             Invalid user object. Please ensure the credentials were entered properly.
             */
            break;
        case 503:
            //user already exist
            
            break;
            
        default:
            NSLog(@"%d",error.code);
            break;
    }
    NSLog(@"%@",error.description);
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"Error" message:error.description delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}
@end
