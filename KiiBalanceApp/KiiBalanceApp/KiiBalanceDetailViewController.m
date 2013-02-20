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
    [self isNetworkConected];
    
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
        NSString* amountStr=[NSString stringWithFormat:@"%d",[amount integerValue]];
        if ([amountStr length]>2) {
            self.itemAmount.text=[amountStr substringToIndex:[amountStr length]-2];
            self.amountCent.text=[amountStr substringFromIndex:[amountStr length]-2];
        }else{
            self.amountCent.text=amountStr;
        }
        
        
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
*/
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}




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
#define MAXLENGTH 2

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    int maxLength=99;
    if (textField==_amountCent) {
        
        maxLength=2;
   
    }else if(textField==_itemAmount){
        maxLength=10;
    }
    
    else{
        return YES;
    }
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    return newLength <= maxLength || returnKey;
}
-(IBAction)saveAction:(id)sender{
    if ([_itemName.text isEqualToString:@""]) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Name is mandatory" message:@"Please fill name field" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
        
    }
    KiiBucket *bucket = [[KiiUser currentUser] bucketWithName:@"balance_book"];
    KiiObject *object = [bucket createObject];
    
    if (nil!=_selectedObject) {
        object=_selectedObject;
    }
    if ([_itemAmount.text isEqualToString:@""]) {
        _itemAmount.text=@"0";
    }
    NSString* amountStr;
    switch ([_amountCent.text length]) {
        case 0:
            amountStr=[NSString stringWithFormat:@"%@0",self.itemAmount.text];
            break;
        case 1:
            amountStr=[NSString stringWithFormat:@"%@%@0",self.itemAmount.text,self.amountCent.text];
            break;
        case 2:
        
        default:
            amountStr=[NSString stringWithFormat:@"%@%@",self.itemAmount.text,self.amountCent.text];
            break;
    }
    
    [object setObject:[NSNumber numberWithLong:[amountStr longLongValue]] forKey:@"amount"];
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
        [KiiAppSingleton sharedInstance].needToRefresh=YES;

        

    } completionBlock:^(){
        [hud removeFromSuperview];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    
   
}

-(IBAction)deleteAction:(id)sender{
    
    
    
    if (nil==_selectedObject) {
        return;
        
    }
    MBProgressHUD* hud=[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    [hud showAnimated:YES whileExecutingBlock:^(){
        KiiObject* object=_selectedObject;
        NSError* error=nil;
        [object deleteSynchronous:&error];
        [KiiAppSingleton sharedInstance].needToRefresh=YES;
        
    } completionBlock:^(){
        
        [hud removeFromSuperview];
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
    
}

@end
