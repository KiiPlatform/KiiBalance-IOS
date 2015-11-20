//
//  KiiAlert.m
//  KiiBalance
//
//  Created by Kii on 2015/11/19.
//  Copyright © 2015年 kii. All rights reserved.
//

#import "KiiAlert.h"

@implementation KiiAlert

+ (UIAlertController*)createWithTitle:(NSString*)title andMessage:(NSString*)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
    [alert addAction:okAction];
    return alert;
}

@end
