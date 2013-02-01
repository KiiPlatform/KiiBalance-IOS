//
//  KiiBalanceViewController.m
//  KiiBalanceApp
//
//  Created by Riza Alaudin Syah on 11/13/12.
//  Copyright (c) 2012 Kii Corporation. All rights reserved.
//

#import "KiiBalanceViewController.h"
#import <KiiSDK/Kii.h>
#import "KiiAppSingleton.h"

@interface KiiBalanceViewController (){
    NSMutableArray* _itemData;
    NSInteger _total;
}
-(void) refreshData;
@end

@implementation KiiBalanceViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _itemData=[NSMutableArray arrayWithCapacity:0];
    
    [self refreshData];
    
   // [bucket ge]
    
}
-(void) refreshData{
    [_itemData removeAllObjects];
    
    KiiBucket *bucket = [[KiiUser currentUser] bucketWithName:@"expense"];
    KiiQuery *query=[KiiQuery queryWithClause:nil];
    KiiError* error;
   
    KiiQuery *nextQuery;
    
    
    NSArray *results = [bucket executeQuerySynchronous:query withError:&error andNext:&nextQuery];

    [_itemData addObjectsFromArray:results];
    _total=0;
    for(KiiObject* obj in results){
        NSNumber* amount=[[obj dictionaryValue] objectForKey:@"amount"];
        NSNumber* type=[[obj dictionaryValue] objectForKey:@"type"];
        if ([type integerValue]==1) {
            _total+=[amount integerValue];
        }else{
            _total-=[amount integerValue];
        }
        
    }
    self.totalLbl.text=[NSString stringWithFormat:@"%d",_total];
}

-(void)viewDidAppear:(BOOL)animated{
    if([KiiAppSingleton sharedInstance].nedToRefresh){
        [self refreshData];
        [self.tableView reloadData];
        
        [KiiAppSingleton sharedInstance].nedToRefresh=NO;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [_itemData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    KiiObject* obj=[_itemData objectAtIndex:indexPath.row];
    NSLog(@"%d",indexPath.row);
    
    NSString* itemName=[[obj dictionaryValue] objectForKey:@"name"];
    
    NSNumber* amount=[[obj dictionaryValue] objectForKey:@"amount"];
    
    NSNumber* type=[[obj dictionaryValue] objectForKey:@"type"];
    cell.textLabel.text=itemName;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%d",[amount integerValue]];
    if ([type integerValue]==1) {
        cell.imageView.image=[UIImage imageNamed:@"plus.jpg"];
    }else{
        cell.imageView.image=[UIImage imageNamed:@"minus.jpg"];
    }
    
    return cell;
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end