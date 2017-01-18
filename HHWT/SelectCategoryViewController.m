//
//  SelectCategoryViewController.m
//  HHWT
//
//  Created by Apple on 08/11/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import "SelectCategoryViewController.h"
#import "CategoryTableViewCell.h"
#import "AddPlacesViewController1.h"

@interface SelectCategoryViewController ()
{
    NSArray *thingsArray;
    NSArray *foodsArray;
    NSArray *prayersArray;
}
@end

@implementation SelectCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.categoryTV.delegate=self;
    self.categoryTV.dataSource=self;
    thingsArray=[[NSArray alloc]initWithObjects:@"Amusement Parks",@"Boat tours & water Sports",@"Classes & workshops",@"Fun &Games",@"Museums",@"Nature & Parks",@"Nightlife",@"Outdoor Activities",@"Sights &Landmarks",@"Spas & Wellness",@"Theatre & Concerts",@"Tours & Activities",@"Transportation",@"Traveller Resources", nil];
    foodsArray=[[NSArray alloc]initWithObjects:@"Fusion",@"Vegetarian",@"Chinese",@"Japanese",@"Korean",@"Taiwanese",@"Hong Kong Cuisine",@"Philippine",@"Singaporean",@"Thai",@"Italian",@"Vietnamese",@"Mongolian",@"Western", nil];
    prayersArray=[[NSArray alloc]initWithObjects:@"Prayer Rooms",@"Mosque", nil];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (_thingsSelected == YES){
    return [thingsArray count];
    }
    else if (_foodSelected == YES)
    {
        return [foodsArray count];
        
    }
    else{
        return [prayersArray count];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"categoryCell";

    CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (_thingsSelected == YES){
        cell.titleLbl.text=[thingsArray objectAtIndex:indexPath.row];
    }
    else if (_foodSelected == YES)
    {
        cell.titleLbl.text=[foodsArray objectAtIndex:indexPath.row];
        
    }
    else{
        cell.titleLbl.text=[prayersArray objectAtIndex:indexPath.row];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * storyboardIdentifier = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardIdentifier bundle: [NSBundle mainBundle]];
    AddPlacesViewController1  * UIVC = [storyboard instantiateViewControllerWithIdentifier:@"AddPlacesViewControllerSSBID"];
    UIVC.fromVC  = true;
    UIVC.tableArray = [NSMutableArray arrayWithObjects: @"Address",@"Opens",@"e.g. : Closed on Sundays",@"Price Range(Optional)",@"Contact Number(Optonal)",@"Website URL(Optional)", nil];
    UIVC.imageArray = [NSMutableArray arrayWithObjects: [UIImage imageNamed:@"unmore.png"] , [UIImage imageNamed:@"unmore.png"], [UIImage imageNamed:@"unmore.png"], [UIImage imageNamed:@"Address.png"],[UIImage imageNamed:@"time.png"],[UIImage imageNamed:@"Price.png"], [UIImage imageNamed:@"Price.png"], [UIImage imageNamed:@"phone.png"],[UIImage imageNamed:@"web.png"], nil];
        UIVC.isSelected = YES;

    if (_thingsSelected == YES){
        UIVC.index = @"3";
        [UIVC.tableArray insertObject:@"Things To do" atIndex:0];
        [UIVC.tableArray insertObject:[thingsArray objectAtIndex:indexPath.row] atIndex:1];
        [UIVC.imageArray removeObjectAtIndex:1];
        

    }
    else if (_foodSelected == YES)
    {
        UIVC.index = @"4";
        [UIVC.tableArray insertObject:@"Foods and drinks" atIndex:0];
        [UIVC.tableArray insertObject:[foodsArray objectAtIndex:indexPath.row] atIndex:1];
        [UIVC.tableArray insertObject:@"Food Classification" atIndex:2];

        
    }
    else{
        UIVC.index = @"3";
        [UIVC.tableArray insertObject:@"Prayer Spaces" atIndex:0];
        [UIVC.tableArray insertObject:[prayersArray objectAtIndex:indexPath.row] atIndex:1];
        [UIVC.imageArray removeObjectAtIndex:1];

    }
    
    [self presentViewController:UIVC animated:YES completion:nil];
    
    
}
- (IBAction)backBtn:(id)sender {
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
