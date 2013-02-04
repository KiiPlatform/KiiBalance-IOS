//
//  KiiBalanceDetailViewController.m
//  KiiBalanceApp
//
//  Created by Riza Alaudin Syah on 11/13/12.
//  Copyright (c) 2012 Kii Corporation. All rights reserved.
//

#import "KiiBalanceDetailViewController.h"
#import <KiiSDK/Kii.h>
#import "KiiAppSingleton.h"
#import "MBProgressHUD.h"

@interface KiiBalanceDetailViewController (){

}

@end

@implementation KiiBalanceDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    self.itemAmount.inputAccessoryView = numberToolbar;
    if (nil!=_selectedObject) {
        self.itemName.text=[[_selectedObject dictionaryValue] objectForKey:@"name"];
        NSNumber* amount=[[_selectedObject dictionaryValue] objectForKey:@"amount"];
        self.itemAmount.text=[NSString stringWithFormat:@"%d",[amount integerValue]];
        
        NSNumber* type=[[_selectedObject dictionaryValue] objectForKey:@"type"];
        
        self.typeSegment.selectedSegmentIndex=[type integerValue]-1;
        
    }
    
}
-(void)cancelNumberPad{
    [self.itemAmount resignFirstResponder];
    self.itemAmount.text = @"";
}

-(void)doneWithNumberPad{
   
    [self.itemAmount resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

-(IBAction)saveAction:(id)sender{
    KiiBucket *bucket = [[KiiUser currentUser] bucketWithName:@"expense"];
    KiiObject *object = [bucket createObject];
    
    if (nil!=_selectedObject) {
        object=_selectedObject;
    }
    
    [object setObject:[NSNumber numberWithLong:[self.itemAmount.text longLongValue]] forKey:@"amount"];
    [object setObject:self.itemName.text forKey:@"name"];
    
    NSInteger type=self.typeSegment.selectedSegmentIndex==0?1:2;
    [object setObject:[NSNumber numberWithInt:type] forKey:@"type"];
    
    MBProgressHUD* hud=[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    
    [hud showAnimated:YES whileExecutingBlock:^(){
    
        NSError* error;
        [object saveSynchronous:&error];

        if(nil!=error){
            
            NSLog(@"%@",[error description]);
            
        }
        [KiiAppSingleton sharedInstance].nedToRefresh=YES;

        

    } completionBlock:^(){
        [hud removeFromSuperview];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    
   
}

@end
