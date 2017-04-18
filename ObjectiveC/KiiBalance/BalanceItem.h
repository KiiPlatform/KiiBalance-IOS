//
//  BalanceItem.h
//  KiiBalance
//
//  Created by Kii on 2015/11/19.
//  Copyright © 2015年 kii. All rights reserved.
//

#ifndef BalanceItem_h
#define BalanceItem_h

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSInteger, BalanceItemType) {
    BalanceItemTypeIncome = 1,
    BalanceItemTypeExpense = 2
};

extern NSString * const BalanceItemBucket;

extern NSString * const BalanceItemFieldAmount;
extern NSString * const BalanceItemFieldName;
extern NSString * const BalanceItemFieldType;
extern NSString * const BalanceItemFieldCreated;


#endif /* BalanceItem_h */
