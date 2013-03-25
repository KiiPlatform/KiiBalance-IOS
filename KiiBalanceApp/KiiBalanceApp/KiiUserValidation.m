//
//  KiiUserValidation.m
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

#import "KiiUserValidation.h"
#import <KiiSDK/Kii.h>

@implementation KiiUserValidation


+(void) showError:(NSError*) error{
    
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
