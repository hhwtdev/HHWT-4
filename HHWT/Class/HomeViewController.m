//
//  HomeViewController.m
//  HHWT
//
//  Created by  kumar on 04/02/16.
//  Copyright (c) 2016 Sam Software. All rights reserved.
//

#import "HomeViewController.h"
#import "MFSideMenu.h"
#import "MenuViewController.h"
#import "ExploreViewController.h"
#import "DestinationViewController.h"
#import "MyTripsViewController.h"
#import "webViewc.h"
#import "HomeCollectionViewCell.h"
#import "ReportViewController.h"
#import "ProfileViewController.h"
#import "FeedBackViewController.h"
#import "AddPlacesViewController.h"
#import "GuidesViewController.h"
#import "ReviewFirstViewController.h"
#import "ToursViewController.h"
@interface HomeViewController ()
{
    UIButton *aButton;
    NSArray *imgArray;
}
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionV;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;

    
    self.pageControl.currentPage = 0.0f;
    imgArray = [NSArray arrayWithObjects:@"explore.png",@"trip2.png",@"newtrip2.png",@"guides2.png",@"newPlace.png",@"feedbck.png",@"bug.png",@"prof.png",@"ios_review_180.png",@"",@"tours_180.png",@"", nil];
    
    UIImageView* img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topLogo.png"]];
    self.navigationItem.titleView = img;
    
    [self.navigationController.navigationBar setBarTintColor:THEME_COLOR];
    [self.navigationController.navigationBar setTranslucent:NO];
    UIColor *tintColor = [UIColor colorWithRed:119/255.0f green:197/255.0f blue:157/255.0f alpha:1.0f];
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSFontAttributeName:[UIFont fontWithName:@"Open Sans" size:22],
                                                                    NSForegroundColorAttributeName: tintColor
                                                                    };
    

}

#pragma mark - UICollectionViewDataSource methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return imgArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float widthVal = self.view.frame.size.width - 25;
    return CGSizeMake(widthVal/2 ,175);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"homeCell" forIndexPath:indexPath];
    cell.img.image = [UIImage imageNamed:[imgArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0)
        [self exploreAction:self];
    else if(indexPath.row == 1)
        [self myTripAction:self];
    else if(indexPath.row == 2)
        [self createTripAction:self];
    else if(indexPath.row == 3)
        [self myguide:self];
    else if(indexPath.row == 4)
        [self newPlace:self];
    else if(indexPath.row == 5)
        [self feedbck:self];
    else if(indexPath.row == 6)
        [self report:self];
    else if(indexPath.row == 7)
        [self profile:self];
    else if(indexPath.row == 8)
        [self review:self];
    else if(indexPath.row == 10)
        [self toursAction:self];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.collectionV.frame.size.width;
    if (self.collectionV.contentOffset.x == 745.0) {
        self.pageControl.currentPage = 2;
    }
    else
    {
    self.pageControl.currentPage = self.collectionV.contentOffset.x / pageWidth;
    }
}

- (IBAction)pageAction:(id)sender {
    
}



-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.hidesBackButton = YES;
}


-(void)viewWillDisappear:(BOOL)animated
{
    [aButton removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)exploreAction:(id)sender {
    
    ExploreViewController *exp = [self.storyboard instantiateViewControllerWithIdentifier:EXPLORE_STORYBOARD_ID];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
        [self showViewController:exp sender:nil];
    }else{
        [self.navigationController pushViewController:exp animated:YES];
    }
}

- (void)createTripAction:(id)sender {
    
    DestinationViewController *exp = [self.storyboard instantiateViewControllerWithIdentifier:DESTINATION_STORYBOARD_ID];
    exp.screenName = @"CreateTrip";
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
        [self showViewController:exp sender:nil];
    }else{
        [self.navigationController pushViewController:exp animated:YES];
    }
}

- (void)myTripAction:(id)sender {
    
    MyTripsViewController *exp = [self.storyboard instantiateViewControllerWithIdentifier:MY_TRIP_SUMMARY_STORYBOARD_ID];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
        [self showViewController:exp sender:nil];
    }else{
        [self.navigationController pushViewController:exp animated:YES];
    }
}

- (void)myguide:(id)sender {
    DestinationViewController *exp = [self.storyboard instantiateViewControllerWithIdentifier:DESTINATION_STORYBOARD_ID];
    exp.screenName = @"Guides";
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
        [self showViewController:exp sender:nil];
    }else{
        [self.navigationController pushViewController:exp animated:YES];
    }
}

- (void)newPlace:(id)sender {
    AddPlacesViewController *exp = [self.storyboard instantiateViewControllerWithIdentifier:ADD_PLACES_STORYBOARD_ID];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
        [self showViewController:exp sender:nil];
    }else{
        [self.navigationController pushViewController:exp animated:YES];
    }
}

- (void)report:(id)sender {
    ReportViewController *exp = [self.storyboard instantiateViewControllerWithIdentifier:REPORT_STORYBOARD_ID];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
        [self showViewController:exp sender:nil];
    }else{
        [self.navigationController pushViewController:exp animated:YES];
    }
}

- (void)profile:(id)sender {
    ProfileViewController *exp = [self.storyboard instantiateViewControllerWithIdentifier:PROFILE_STORYBOARD_ID];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
        [self showViewController:exp sender:nil];
    }else{
        [self.navigationController pushViewController:exp animated:YES];
    }
}

- (void)review:(id)sender {
    DestinationViewController *exp = [self.storyboard instantiateViewControllerWithIdentifier:DESTINATION_STORYBOARD_ID];
    exp.screenName = @"Reviews";
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
        [self showViewController:exp sender:nil];
    }else{
        [self.navigationController pushViewController:exp animated:YES];
    }
}

- (void)feedbck:(id)sender {
    FeedBackViewController *exp = [self.storyboard instantiateViewControllerWithIdentifier:FEED_BACK_STORYBOARD_ID];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
        [self showViewController:exp sender:nil];
    }else{
        [self.navigationController pushViewController:exp animated:YES];
    }
}

- (void)toursAction:(id)sender {
    ToursViewController *exp = [self.storyboard instantiateViewControllerWithIdentifier:TOURS_STORYBOARD_ID];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
        [self showViewController:exp sender:nil];
    }else{
        [self.navigationController pushViewController:exp animated:YES];
    }
}


@end
