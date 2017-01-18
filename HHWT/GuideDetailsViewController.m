//
//  GuideDetailsViewController.m
//  HHWT
//
//  Created by Dipin on 20/04/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import "GuideDetailsViewController.h"
#import "UIImageView+WebCache.h"
#import "ListPlacesViewController.h"

@interface GuideDetailsViewController ()

@end

@implementation GuideDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tblView.tableFooterView = [[UIView alloc] init];
    self.title = @"Guides";

    
   // [_tblView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (_tblView.contentSize.height > _tblView.frame.size.height) {
        _tblView.scrollEnabled = YES;
    }
    else
    {
        _tblView.scrollEnabled = NO;
    }
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
    if (_dictGuides[@"tips"] != nil) {
        return 5;
    }
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"imgView" forIndexPath:indexPath];
        
    
        UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:100];
        UIActivityIndicatorView *activityIndication = (UIActivityIndicatorView *)[cell viewWithTag:200];
        
        NSString *imgURL;
        if(_dictGuides[@"guidecover"] == nil)
            imgURL = @"";
        else
            imgURL = _dictGuides[@"guidecover"];
        
        activityIndication.hidden = NO;
        [activityIndication startAnimating];
        [imgView sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"placeHolder.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            activityIndication.hidden = YES;
            [activityIndication stopAnimating];
        }];
        
        return cell;
    }
    else if (indexPath.row == 1)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"heading" forIndexPath:indexPath];
        
        UILabel *lbl = (UILabel *)[cell viewWithTag:50];
        lbl.text = _dictGuides[@"guides"];
        return cell;
    }
    else if (indexPath.row == 2)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"description" forIndexPath:indexPath];
        UILabel *lbl = (UILabel *)[cell viewWithTag:40];
        lbl.text = _dictGuides[@"description"];
        return cell;
    }
    else if (indexPath.row == 3)
    {
        if (_dictGuides[@"tips"] == nil) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"list" forIndexPath:indexPath];
            return cell;
            
        }
        else
        {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tips" forIndexPath:indexPath];
        UILabel *lbl = (UILabel *)[cell viewWithTag:30];
        lbl.text = _dictGuides[@"tips"];
        return cell;
        }
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"list" forIndexPath:indexPath];
        return cell;
    }
}

-(void)navSingleTap
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)actionListPlaces:(id)sender {
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ListPlacesViewController *lists = [story instantiateViewControllerWithIdentifier:@"ListPlacesViewController"];
    lists.lists = _dictGuides[@"result"];
    lists.selectedCityDictionary = _selectedCityDictionary;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
        [self showViewController:lists sender:nil];
    }else{
        [self.navigationController pushViewController:lists animated:YES];
    }
}
@end
