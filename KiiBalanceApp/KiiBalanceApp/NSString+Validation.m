//
//  NSString+Validation.m
//  KiiBalanceApp
//
//  Created by Riza Alaudin Syah on 2/20/13.
//  Copyright (c) 2013 Kii Corporation. All rights reserved.
//

#import "NSString+Validation.h"

@implementation NSString (Validation)

- (BOOL) emailIsValid {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL) usernameIsValid {
    NSString *usernameRegex = @"[a-zA-Z0-9-_\\.]{3,64}";
    NSPredicate *userTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", usernameRegex];
    return [userTest evaluateWithObject:self];
}

- (BOOL) displaynameIsValid {
    NSString *usernameRegex = @"[A-Za-z]{1}[A-Za-z0-9-_]{3,49}";
    NSPredicate *userTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", usernameRegex];
    return [userTest evaluateWithObject:self];
}

- (BOOL) passwordIsValid {
    NSString *passwordRegex = @"[A-Za-z0-9\\@\\#\\$\\%\\^\\&]{4,}";
    NSPredicate *passTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    return [passTest evaluateWithObject:self];
}

- (BOOL) phoneNumberIsValid {
    NSString *phoneRegex = @"^\\+?[0-9]{7,20}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

@end
