//
//  FoodClassificationViewController.m
//  HHWT
//
//  Created by Apple on 08/11/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import "FoodClassificationViewController.h"
#import "FoodClassificationTableViewCell.h"
#import "AddPlacesViewController1.h"

@interface FoodClassificationViewController ()
{
    NSArray *foodClassificationArray;
}
@end

@implementation FoodClassificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.foodTV.delegate=self;
    self.foodTV.dataSource=self;
    foodClassificationArray=[[NSArray alloc]initWithObjects:@"Halal meat",@"Seafood",@"Vegetarian",@"Alcohol Served", nil];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [foodClassificationArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"foodClassificationCell";
    
    FoodClassificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    cell.titleLbl.text=[foodClassificationArray objectAtIndex:indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * storyboardIdentifier = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardIdentifier bundle: [NSBundle mainBundle]];
    AddPlacesViewController1  * UIVC = [storyboard instantiateViewControllerWithIdentifier:@"AddPlacesViewControllerSSBID"];
    UIVC.fromVC  = true;
    UIVC.tableArray = [NSMutableArray arrayWithObjects: @"Address",@"Opens",@"e.g. : Closed on Sundays",@"Price Range(Optional)",@"Contact Number(Optonal)",@"Website URL(Optional)", nil];
    UIVC.imageArray = [NSMutableArray arrayWithObjects: [UIImage imageNamed:@"unmore.png"] , [UIImage imageNamed:@"unmore.png"], [UIImage imageNamed:@"unmore.png"], [UIImage imageNamed:@"Address.png"],[UIImage imageNamed:@"time.png"],[UIImage imageNamed:@"Price.png"], [UIImage imageNamed:@"Price.png"], [UIImage imageNamed:@"phone.png"],[UIImage imageNamed:@"web.png"], nil];
    
   
        UIVC.index = @"4";
        [UIVC.tableArray insertObject:@"Foods and drinks" atIndex:0];
        [UIVC.tableArray insertObject:_categoryName atIndex:1];
        [UIVC.tableArray insertObject:[foodClassificationArray objectAtIndex:indexPath.row] atIndex:2];
        

    
    [self presentViewController:UIVC animated:YES completion:nil];
    
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
