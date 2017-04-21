//
//
// Copyright 2017 Kii Corporation
// http://kii.com
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
//
#import <UIKit/UIKit.h>
#import <KiiSDK/Kii.h>

typedef NS_ENUM(NSUInteger, EditItemViewMode) {
    EditItemViewModeAdd,
    EditItemViewModeEdit,
};

@protocol DoneEditDelegate
- (void)addItem: (KiiObject*)object;
- (void)updateItem: (KiiObject*)object;
- (void)deleteItem: (KiiObject*)object;
@end

@interface EditItemViewController : UITableViewController

@property(weak) IBOutlet UIBarButtonItem *saveButton;
@property(weak) IBOutlet UITextField *amountText;
@property(weak) IBOutlet UITextField *nameText;
@property(weak) IBOutlet UILabel *typeLabel;

@property EditItemViewMode mode;
@property NSString *objectId;
@property NSString *name;
@property int type;
@property int amount;

@property(weak) id<DoneEditDelegate> doneEditDelegate;

@end
