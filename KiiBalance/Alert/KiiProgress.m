//
//  KiiProgress.m
//  KiiBalance
//
//  Created by Kii on 2015/11/18.
//  Copyright © 2015年 kii. All rights reserved.
//

#import "KiiProgress.h"

@implementation KiiProgress

+ (UIAlertController*)createWithMessage:(NSString*)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:[NSString stringWithFormat:@"%@\n\n\n", message]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = CGPointMake(130.5, 65.5);
    indicator.color = [UIColor blackColor];
    [indicator startAnimating];
    [alert.view addSubview:indicator];
    
    return alert;
}

@end
