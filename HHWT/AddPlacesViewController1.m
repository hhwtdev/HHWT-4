//
//  AddPlacesViewController1.m
//  HHWT
//
//  Created by Apple on 07/11/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import "AddPlacesViewController1.h"
#import "AddPlaceTableViewCell.h"
#import "SelectCategoryViewController.h"
#import "AppDelegate.h"
#import "Utility.h"
#import "FoodClassificationViewController.h"

@interface AddPlacesViewController1 () <UINavigationControllerDelegate>
{
}
@end

@implementation AddPlacesViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.imgaeBackView.layer.borderColor = [UIColor blackColor].CGColor;
    self.imgaeBackView.layer.borderWidth= 2.5;
    

    self.tableView.delegate= self;
    self.tableView.dataSource=self;
    //_fromVC = false;
    NSLog(@"%@", _tableArray);
    NSLog(@"%lu", (unsigned long)[_tableArray count]);
    NSLog(@"%@", _index);


    if (_fromVC == false){ 
    _tableArray = [NSMutableArray arrayWithObjects:@"Listing Type",@"Address",@"Opens",@"e.g. : Closed on Sundays",@"Price Range(Optional)",@"Contact Number(Optional)",@"Website URL(Optional)", nil];
        _index = @"2";

   _imageArray = [NSMutableArray arrayWithObjects: [UIImage imageNamed:@"unmore.png"] , [UIImage imageNamed:@"Addresss.png"],[UIImage imageNamed:@"time.png"], [UIImage imageNamed:@"Price.png"],[UIImage imageNamed:@"Price.png"], [UIImage imageNamed:@"phone.png"],[UIImage imageNamed:@"web.png"], nil];
    }
 
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"placeCell";
    
    AddPlaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (_tableArray.count == 7){
    if (indexPath.row == [_index integerValue])
    {
        cell.imgView.image = [_imageArray objectAtIndex:indexPath.row];
        cell.titleLbl.text = [_tableArray objectAtIndex:indexPath.row];
        cell.hoursLbl.text = @"00:00";
        cell.titleLbl1.text = @"Closes";
        cell.hoursLbl1.text = @"00:00";
    }
    else if (indexPath.row == 3){
        cell.imgView.image = [UIImage imageNamed:@""];//[imageArray objectAtIndex:indexPath.row];
        cell.titleLbl.text = [_tableArray objectAtIndex:indexPath.row];
        cell.titleLbl1.hidden = YES;
        cell.hoursLbl.hidden = YES;
        cell.hoursLbl1.hidden = YES;
    }
    else{
        
        cell.imgView.image = [_imageArray objectAtIndex:indexPath.row];
        cell.titleLbl.text = [_tableArray objectAtIndex:indexPath.row];
        cell.titleLbl1.hidden = YES;
        cell.hoursLbl.hidden = YES;
        cell.hoursLbl1.hidden = YES;
    }
}
    else if (_tableArray.count == 9){
    if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 5)
        
{
        cell.imgView.image = [UIImage imageNamed:@""];//[imageArray objectAtIndex:indexPath.row];
        cell.titleLbl.text = [_tableArray objectAtIndex:indexPath.row];
    if (_isSelected == YES){
        cell.titleLbl.textColor = [UIColor blackColor];
    }
        cell.titleLbl1.hidden = YES;
        cell.hoursLbl.hidden = YES;
        cell.hoursLbl1.hidden = YES;
    }
      else  if (indexPath.row == [_index integerValue])
        {
            cell.imgView.image = [_imageArray objectAtIndex:indexPath.row];
            cell.titleLbl.text = [_tableArray objectAtIndex:indexPath.row];
            cell.hoursLbl.text = @"00:00";
            cell.titleLbl1.text = @"Closes";
            cell.hoursLbl1.text = @"00:00";
        }
    else{
        
        cell.imgView.image = [_imageArray objectAtIndex:indexPath.row];
        cell.titleLbl.text = [_tableArray objectAtIndex:indexPath.row];
        cell.titleLbl1.hidden = YES;
        cell.hoursLbl.hidden = YES;
        cell.hoursLbl1.hidden = YES;
    }
        
    }
    else{
        if (indexPath.row == [_index integerValue])
        {
            cell.imgView.image = [_imageArray objectAtIndex:indexPath.row];
            cell.titleLbl.text = [_tableArray objectAtIndex:indexPath.row];
            cell.hoursLbl.text = @"00:00";
            cell.titleLbl1.text = @"Closes";
            cell.hoursLbl1.text = @"00:00";
        }
        else if (indexPath.row == 4 || indexPath.row == 1){
            cell.imgView.image = [UIImage imageNamed:@""];//[imageArray objectAtIndex:indexPath.row];
            cell.titleLbl.text = [_tableArray objectAtIndex:indexPath.row];
            if (_isSelected == YES){
                cell.titleLbl.textColor = [UIColor blackColor];
            }
            cell.titleLbl1.hidden = YES;
            cell.hoursLbl.hidden = YES;
            cell.hoursLbl1.hidden = YES;
        }
        else{
            
            cell.imgView.image = [_imageArray objectAtIndex:indexPath.row];
            cell.titleLbl.text = [_tableArray objectAtIndex:indexPath.row];
            cell.titleLbl1.hidden = YES;
            cell.hoursLbl.hidden = YES;
            cell.hoursLbl1.hidden = YES;
        }

        
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        NSString * storyboardIdentifier = @"Main";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardIdentifier bundle: [NSBundle mainBundle]];
        UIViewController * UIVC = [storyboard instantiateViewControllerWithIdentifier:@"listingTypeVC"];
        
        [self presentViewController:UIVC animated:YES completion:nil];
    }
    else if(indexPath.row == 1 || [[_tableArray objectAtIndex:1] isEqualToString:@"Category"])
    {
        NSString * storyboardIdentifier = @"Main";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardIdentifier bundle: [NSBundle mainBundle]];
        SelectCategoryViewController * UIVC = [storyboard instantiateViewControllerWithIdentifier:@"selectCategoryVC"];
       // SelectCategoryViewController * UIVC = [[SelectCategoryViewController alloc] initWithNibName:@"selectCategoryVC" bundle:nil];
        if ([[_tableArray objectAtIndex:0] isEqualToString:@"Things To do"])
        {
            UIVC.thingsSelected = YES;
        }
        else if ([[_tableArray objectAtIndex:0] isEqualToString:@"Foods and drinks"])
        {
            UIVC.foodSelected = YES;
        }
        else
        {
            UIVC.palySelected =  YES;
        }
        [self presentViewController:UIVC animated:YES completion:nil];
       // [self.navigationController pushViewController:UIVC animated:YES];
    }
    else if (indexPath.row == 2 && [[_tableArray objectAtIndex:2] isEqualToString:@"Food Classification"]){
        NSString * storyboardIdentifier = @"Main";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardIdentifier bundle: [NSBundle mainBundle]];
        FoodClassificationViewController * UIVC = [storyboard instantiateViewControllerWithIdentifier:@"foodClassificationVC"];
        UIVC.categoryName = [_tableArray objectAtIndex:1];
        [self presentViewController:UIVC animated:YES completion:nil];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
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
