//
//  KiiViewController.m
//  KiiPhotos
//
//  Created by Riza Alaudin Syah on 10/30/12.
//  Copyright (c) 2012 Kii Corporation. All rights reserved.
//

#import "KiiViewController.h"
#import "KiiAppSingleton.h"

@interface KiiViewController ()

@end

@implementation KiiViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void) viewDidAppear:(BOOL)animated{
    if ([[KiiAppSingleton sharedInstance] checkUserToken]&&[[KiiAppSingleton sharedInstance] loginWithToken]) {
        [self performSegueWithIdentifier:@"mainSegue" sender:nil];
    }else{
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)canPerformUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender{
    return YES;
}
- (IBAction)returnActionForSegue:(id)returnSegue {
    
    [[KiiAppSingleton sharedInstance] doLogOut];
    
}

@end
