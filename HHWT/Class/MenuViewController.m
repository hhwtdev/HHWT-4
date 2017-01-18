//
//  MenuViewController.m
//  JRD
//
//  Created by  kumar on 24/12/15.
//  Copyright (c) 2015 Sam Info Tech. All rights reserved.
//

#import "MenuViewController.h"
#import "MFSideMenu.h"
#import "AppDelegate.h"
#import "ExploreViewController.h"
#import "HomeViewController.h"

@interface MenuViewController ()
{
    NSArray *menuListArray;
    NSArray *menuIconListArray;
    int selectedIndex;
}

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

   

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)exploreAction:(id)sender {
    selectedIndex = 1;
    [self performSelector:@selector(moveToSelectedScreen) withObject:nil afterDelay:0.0];
}

- (IBAction)createTripAction:(id)sender {
    selectedIndex = 2;
    [self performSelector:@selector(moveToSelectedScreen) withObject:nil afterDelay:0.0];
}

- (IBAction)myTripsAction:(id)sender {
    selectedIndex = 3;
    [self performSelector:@selector(moveToSelectedScreen) withObject:nil afterDelay:0.0];
}

- (IBAction)guideAction:(id)sender {
    selectedIndex = 4;
    [self performSelector:@selector(moveToSelectedScreen) withObject:nil afterDelay:0.0];
}

-(void)moveToSelectedScreen
{
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
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
