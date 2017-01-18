//
//  ListPlacesViewController.m
//  HHWT
//
//  Created by Dipin on 20/04/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import "ListPlacesViewController.h"
#import "UIImageView+WebCache.h"
#import "FoodDetailViewController.h"


@interface ListPlacesViewController ()
{
}
@end

@implementation ListPlacesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tblView.tableFooterView = [[UIView alloc] init];
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

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)navSingleTap
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _lists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    UIImageView *imgView = (UIImageView *)[cell viewWithTag:10];
    UILabel *lbl = (UILabel *)[cell viewWithTag:20];
    UILabel *lblNew = (UILabel *)[cell viewWithTag:40];
    UIActivityIndicatorView *activityIndication = (UIActivityIndicatorView *)[cell viewWithTag:30];
    
    NSDictionary *dict = _lists[indexPath.row];
    NSString *imgURL;
    if(dict[@"photo"] == [NSNull null])
        imgURL = @"";
    else
        imgURL = dict[@"photo"];
    
    activityIndication.hidden = NO;
    [activityIndication startAnimating];
    [imgView sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"placeHolder.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        activityIndication.hidden = YES;
        [activityIndication stopAnimating];
    }];
    
    lbl.text = dict[@"name"] != [NSNull null] ? dict[@"name"] : @"";
    lblNew.text = dict[@"activity"] != [NSNull null] ? dict[@"activity"] : @"";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [_lists objectAtIndex:indexPath.row];
    showProgress(YES);
    FoodDetailViewController *fd = [self.storyboard instantiateViewControllerWithIdentifier:FoodDetailViewController_STORYBOARD_ID];
    fd.selectionID = [[dic objectForKey:@"dataelementid"] intValue];
    fd.selectionType = 4;
    fd.cityID = [_selectedCityDictionary objectForKey:@"sno"];
    fd.selectedCityDictionary = _selectedCityDictionary;

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
        [self showViewController:fd sender:nil];
    }else{
        [self.navigationController pushViewController:fd animated:YES];
    }
    showProgress(NO);
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
