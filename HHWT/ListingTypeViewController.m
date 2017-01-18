//
//  ListingTypeViewController.m
//  HHWT
//
//  Created by Apple on 08/11/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import "ListingTypeViewController.h"
#import "ListingTableViewCell.h"
#import "AddPlacesViewController1.h"
#import "AddPlaceTableViewCell.h"

@interface ListingTypeViewController () <UINavigationControllerDelegate>
{
    NSArray *listingArray;
}
@end

@implementation ListingTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.listTableView.delegate= self;
    self.listTableView.dataSource=self;
    
    listingArray=[NSArray arrayWithObjects:@"Things To do",@"Foods and drinks",@"Prayer Spaces", nil];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listingArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"listCell";
    
    ListingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    cell.textLbl.text=[listingArray objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * storyboardIdentifier = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardIdentifier bundle: [NSBundle mainBundle]];
   AddPlacesViewController1  * UIVC = [storyboard instantiateViewControllerWithIdentifier:@"AddPlacesViewControllerSSBID"];
    UIVC.fromVC  = true;
    UIVC.tableArray = [NSMutableArray arrayWithObjects:@"Address",@"Opens",@"e.g. : Closed on Sundays",@"Price Range(Optional)",@"Contact Number(Optonal)",@"Website URL(Optional)", nil];
    UIVC.imageArray = [NSMutableArray arrayWithObjects: [UIImage imageNamed:@"unmore.png"] , [UIImage imageNamed:@"unmore.png"], [UIImage imageNamed:@"unmore.png"], [UIImage imageNamed:@"Address.png"],[UIImage imageNamed:@"time.png"],[UIImage imageNamed:@"Price.png"], [UIImage imageNamed:@"Price.png"], [UIImage imageNamed:@"phone.png"],[UIImage imageNamed:@"web.png"], nil];
 
    if (indexPath.row == 1)
    {
        UIVC.index = @"4";
        [UIVC.tableArray insertObject:[listingArray objectAtIndex:indexPath.row] atIndex:0];
        [UIVC.tableArray insertObject:@"Category" atIndex:1];
        [UIVC.tableArray insertObject:@"Food Classification" atIndex:2];
        UIVC.isSelected = YES;

        
    }
    else{
        UIVC.index = @"3";
        [UIVC.tableArray insertObject:[listingArray objectAtIndex:indexPath.row] atIndex:0];
        [UIVC.tableArray insertObject:@"Category" atIndex:1];
        [UIVC.imageArray removeObjectAtIndex:1];
        UIVC.isSelected = YES;
    }
   
    NSLog(@"%@", UIVC.index);
    [self presentViewController:UIVC animated:YES completion:nil];
    
}
- (IBAction)backbtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
