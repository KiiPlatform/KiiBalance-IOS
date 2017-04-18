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
#import "TitleViewController.h"
#import "AppDelegate.h"
#import "KiiProgress.h"
#import <KiiSDK/Kii.h>

@interface TitleViewController ()

@end

@implementation TitleViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // If user already logged in, go to data listing screen.
    [KiiUser authenticateWithStoredCredentials:^(KiiUser *user, NSError *error) {
        if (error != nil) {
            // Show the title screen.
            return;
        }

        // Show the data listing screen.
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [app showBalanceList];
    }];
}

@end
