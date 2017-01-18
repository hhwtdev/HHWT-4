//
//  MyTabbbarController.m
//  HHWT
//
//  Created by SampathKumar on 19/10/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import "MyTabbbarController.h"
#import "MoreTabBarTableViewCell.h"
#import "AppDelegate.h"

@interface MyTabbbarController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView* tabBarTableView;
@property (nonatomic,weak) id <UITableViewDelegate> currentTableViewDelegate;

@end

@implementation MyTabbbarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setDelegate:self];

    UIColor *tintColor = [UIColor colorWithRed:50/255.0f green:204/255.0f blue:203/255.0f alpha:1.0f];
    [[UITabBar appearance] setTintColor:tintColor];
    
    [self costumizeMoreTableView];
}

-(void)costumizeMoreTableView
{
    _tabBarTableView = (UITableView *)self.moreNavigationController.topViewController.view;
    _tabBarTableView.backgroundColor = [UIColor colorWithRed:240/255.0f green:239/255.0f blue:244/255.0f alpha:1.0f];
    _currentTableViewDelegate = _tabBarTableView.delegate;
    _tabBarTableView.delegate = self;
    _tabBarTableView.dataSource = self;
    [_tabBarTableView registerNib:[UINib nibWithNibName:@"MoreTabBarTableViewCell" bundle:nil] forCellReuseIdentifier:@"MoreTabBarTableViewCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"PROFILE";
            break;
        case 1:
            sectionName = @"COMMUNITY";
            break;
        case 2:
            sectionName = @"OTHERS";
            break;
            // ...
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 90;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section == 0)
        return 1;
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MoreTabBarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoreTabBarTableViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.lblHeightConstraintTitle.constant = 22.0f;

    cell.lblDetail.hidden = NO;
    if(indexPath.section == 0)
    {
        cell.lblTitle.text = [AppDelegate isEmpty:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"]] ? @"UserName" :  [[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"];
        cell.lblDetail.text = @"View Your profile";
        //cell.img.image=[UIImage imageNamed:@"edii.png"];
    }
    else{
        cell.imgWidthConstrint.constant = 40.0f;
        
        cell.lblDetail.hidden = YES;
        cell.lblHeightConstraintTitle.constant = 38.0f;
        
        if(indexPath.section == 1){
            if(indexPath.row == 0){
                cell.lblTitle.text = @"Add new place";
            }
            else if(indexPath.row == 1){
                cell.lblTitle.text = @"Add a review";
            }
        }
        else if(indexPath.section == 2) {
            
            cell.imgWidthConstrint.constant = 0.0f;

            
            
            if(indexPath.row == 0)
                cell.lblTitle.text = @"Provide app feedback";
            else if(indexPath.row == 1)
                cell.lblTitle.text = @"Report a bug";

        }
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if(indexPath.section == 1)
    {
        if(indexPath.row == 0){
            cell.img.image=[UIImage imageNamed:@"addareview.png"];
        }
        else if(indexPath.row == 1){
            cell.img.image=[UIImage imageNamed:@"addnewplace.png"];
        }
       
    }
    
    if(indexPath.section == 0)
        
    {
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"UserProfilePic"] length]>0 && ![[[NSUserDefaults standardUserDefaults] valueForKey:@"UserProfilePic"] isEqualToString:@""]){
    }
    
    cell.img.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserProfilePic"]]]];
        
    }
        
        
    
    
    
    
   

    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath{
    int rowVal = 0;
    if(indexPath.section == 0)
    {
        rowVal = 0;
    }
    else{
        if(indexPath.section == 1){
            if(indexPath.row == 0){
                rowVal = 1;
            }
            else if(indexPath.row == 1){
                rowVal = 2;
            }
        }
        else if(indexPath.section == 2) {
            if(indexPath.row == 0)
                rowVal = 3;
            else if(indexPath.row == 1)
                rowVal = 4;
        }
    }
    
    NSIndexPath *preparedIndexPath = [NSIndexPath indexPathForRow:rowVal inSection:0];
    [_currentTableViewDelegate tableView:tableView didSelectRowAtIndexPath:preparedIndexPath];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
