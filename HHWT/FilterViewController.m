//
//  FilterViewController.m
//  HHWT
//
//  Created by Dipin on 19/05/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import "FilterViewController.h"



@interface FilterViewController ()
{
    NSArray *starArray;
    
}
@end

@implementation FilterViewController

@synthesize checkedActivities;
@synthesize checkedStarValue;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *tintColor = [UIColor colorWithRed:119/255.0f green:197/255.0f blue:157/255.0f alpha:1.0f];
    
    [self.navigationController.navigationBar setBarTintColor:THEME_COLOR];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.navigationBar.tintColor = tintColor;
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSFontAttributeName:[UIFont fontWithName:@"Open Sans" size:22],
                                                                    NSForegroundColorAttributeName: tintColor
                                                                    };
    
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topLogo.png"]];
    self.navigationItem.titleView = img;
    
    UITapGestureRecognizer *navSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navSingleTap)];
    navSingleTap.numberOfTapsRequired = 1;
    [self.navigationItem.titleView  setUserInteractionEnabled:YES];
    [self.navigationItem.titleView addGestureRecognizer:navSingleTap];
    
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
    
    starArray = @[@"1", @"2", @"3", @"4", @"5"];
    
    
    // Do any additional setup after loading the view.
}

- (void)navSingleTap
{
    [self.view endEditing:YES];
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        
        
        UICollectionView *collectionView = (UICollectionView *)[cell viewWithTag:20];
        
        for (NSLayoutConstraint *constraint in collectionView.constraints) {
            if ([constraint.identifier isEqualToString:@"collectionHeight1"]) {
                constraint.constant = 135;
                [self.view needsUpdateConstraints];
            }
        }
        
        return cell;
    }
    else if (indexPath.row == 1)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        UICollectionView *collectionView = (UICollectionView *)[cell viewWithTag:30];
        
        for (NSLayoutConstraint *constraint in collectionView.constraints) {
            if ([constraint.identifier isEqualToString:@"collectionHeight2"]) {
                constraint.constant = _activityArray.count%2 == 0 ? (_activityArray.count/2) * 40 : (_activityArray.count/2 + 1) * 45;
                [self.view needsUpdateConstraints];
            }
        }
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"save" forIndexPath:indexPath];
        
        return cell;
    }
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView.tag == 20) {
        return 5;
    }
    else
    {
        return _activityArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 20) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        
        UIImageView *imgView = (UIImageView *)[cell viewWithTag:100];
        UILabel *lblTitile = (UILabel *)[cell viewWithTag:200];
        lblTitile.text = [NSString stringWithFormat:@"%@ Star",starArray[indexPath.item]];
        if ([checkedStarValue containsObject:[starArray objectAtIndex:indexPath.item]]) {
            imgView.image = [UIImage imageNamed:@"checked_checkbox"];
        }
        else
        {
            imgView.image = [UIImage imageNamed:@"unchecked_checkbox"];
        }
        
        
        return cell;
        
    }
    else
    {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        
        UIImageView *imgView = (UIImageView *)[cell viewWithTag:100];
        UILabel *lblTitile = (UILabel *)[cell viewWithTag:200];
        lblTitile.text = _activityArray[indexPath.item];
        if ([checkedActivities containsObject:[_activityArray objectAtIndex:indexPath.item]]) {
            imgView.image = [UIImage imageNamed:@"checked_checkbox"];
        }
        else
        {
            imgView.image = [UIImage imageNamed:@"unchecked_checkbox"];
        }
        return cell;
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 20) {
        if (![checkedStarValue containsObject:[starArray objectAtIndex:indexPath.item]]) {
            [checkedStarValue addObject:[starArray objectAtIndex:indexPath.item]];
        }
        else
        {
            [checkedStarValue removeObject:[starArray objectAtIndex:indexPath.item]];
        }
        [collectionView reloadData];
    }
    else
    {
        if (![checkedActivities containsObject:[_activityArray objectAtIndex:indexPath.item]]) {
            [checkedActivities addObject:[_activityArray objectAtIndex:indexPath.item]];
        }
        else
        {
            [checkedActivities removeObject:[_activityArray objectAtIndex:indexPath.item]];
        }
        [collectionView reloadData];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Adjust cell size for orientation
    
    return CGSizeMake([UIScreen mainScreen].bounds.size.width/2 - 20, 35);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)actionSave:(id)sender {
    
    [_delegate getSelectedFilters:checkedStarValue withActivityFilter:checkedActivities];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
