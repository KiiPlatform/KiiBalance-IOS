//
//  NSString+Validation.h
//  KiiBalanceApp
//
//  Created by Riza Alaudin Syah on 2/20/13.
//  Copyright (c) 2013 Kii Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Validation)
- (BOOL) emailIsValid;
- (BOOL) passwordIsValid;
- (BOOL) usernameIsValid;
- (BOOL) displaynameIsValid;
- (BOOL) phoneNumberIsValid;
@end
