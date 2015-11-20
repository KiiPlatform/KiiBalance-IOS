//
//  KiiAlert.h
//  KiiBalance
//
//  Created by Kii on 2015/11/19.
//  Copyright © 2015年 kii. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KiiAlert : NSObject

+ (UIAlertController*)createWithTitle:(NSString*)title andMessage:(NSString*)message;

@end
