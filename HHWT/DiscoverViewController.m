//
//  DiscoverViewController.m
//  HHWT
//
//  Created by  kumar on 04/02/16.
//  Copyright (c) 2016 Sam Software. All rights reserved.
//

#import "DiscoverViewController.h"
#import "ExploredetailViewController.h"
#import "UIImageView+WebCache.h"

@interface DiscoverViewController ()

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",_selectedCityDictionary);
    
    NSString *imgURL;
    if([[_selectedCityDictionary objectForKey:@"img"] length] == 0)
        imgURL = @"";
    else
        imgURL = [_selectedCityDictionary objectForKey:@"img"];
    
    self.loadingIndicator.hidden = NO;
    [self.loadingIndicator startAnimating];
    [self.topImage sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"placeHolder.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.loadingIndicator.hidden = YES;
        [self.loadingIndicator stopAnimating];
    }];
    
    
    _lblTitle.text = [[_selectedCityDictionary objectForKey:@"city"] uppercaseString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)foodAction:(id)sender
{
    //Push to category screen for select fandoms...
    ExploredetailViewController *fd = [self.storyboard instantiateViewControllerWithIdentifier:FoodViewController_STORYBOARD_ID];
    fd.selectionID = SELECTION_FOOD;
    fd.cityID = [_selectedCityDictionary objectForKey:@"sno"];
    fd.selectedCityDictionary = _selectedCityDictionary;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
        [self showViewController:fd sender:nil];
    }else{
        [self.navigationController pushViewController:fd animated:YES];
    }
}

-(IBAction)thingsAction:(id)sender
{
    //Push to category screen for select fandoms...
    ExploredetailViewController *fd = [self.storyboard instantiateViewControllerWithIdentifier:FoodViewController_STORYBOARD_ID];
    fd.selectionID = SELECTION_THINGS;
    fd.cityID = [_selectedCityDictionary objectForKey:@"sno"];
    fd.selectedCityDictionary = _selectedCityDictionary;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
        [self showViewController:fd sender:nil];
    }else{
        [self.navigationController pushViewController:fd animated:YES];
    }
}

-(IBAction)prayerAction:(id)sender
{
    //Push to category screen for select fandoms...
    ExploredetailViewController *fd = [self.storyboard instantiateViewControllerWithIdentifier:FoodViewController_STORYBOARD_ID];
    fd.selectionID = SELECTION_PRAYER;
    fd.cityID = [_selectedCityDictionary objectForKey:@"sno"];
    fd.selectedCityDictionary = _selectedCityDictionary;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
        [self showViewController:fd sender:nil];
    }else{
        [self.navigationController pushViewController:fd animated:YES];
    }
}

-(IBAction)neighbourAction:(id)sender
{
    //Push to category screen for select fandoms...
    ExploredetailViewController *fd = [self.storyboard instantiateViewControllerWithIdentifier:FoodViewController_STORYBOARD_ID];
    fd.selectionID = SELECTION_NEIGHBOURHOOD;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
        [self showViewController:fd sender:nil];
    }else{
        [self.navigationController pushViewController:fd animated:YES];
    }
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
