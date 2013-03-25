//
//  KiiCell.h
//  KiiBalanceApp
//
//  Created by Riza Alaudin Syah on 2/14/13.
//  Copyright (c) 2013 Kii Corporation. All rights reserved.
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

#import <UIKit/UIKit.h>

@interface KiiCell : UITableViewCell

@property(nonatomic,weak) IBOutlet UILabel* amountlabel;
@property(nonatomic,weak) IBOutlet UILabel* namelabel;
@property(nonatomic,weak) IBOutlet UILabel* datelabel;
@property(nonatomic,weak) IBOutlet UIImageView* iconType;
@end
