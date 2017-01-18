//
//  GuidesViewController.m
//  HHWT
//
//  Created by Dipin on 20/04/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import "GuidesViewController.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "GuideDetailsViewController.h"

#define showProgress(a)             [AppDelegate showProgressForState:a]

@interface GuidesViewController ()
{
    NSArray *guides;
}
@end

@implementation GuidesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tblView.tableFooterView = [[UIView alloc] init];
    self.title = @"Guides";
}

- (void)viewWillAppear:(BOOL)animated
{
    showProgress(YES);
    NSString  *urlPath    = [NSString stringWithFormat:@"http://www.everestitservices.com/hhwt_webservice/guidesfetch.php"];
    
    NSString *parameter = [NSString stringWithFormat:@"cityid=%@",[_selectedCityDictionary objectForKey:@"sno"]];
    NSData *parameterData = [parameter dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    [[NetworkManager sharedManager] getvalueFromServerForURL:urlPath withDataMessage:parameterData completionHandler:^(NSError *error, NSDictionary *dic) {
        if(error) {
            NSLog(@"error : %@", [error description]);
        } else {
            if ([dic[@"status"] isEqualToNumber:[NSNumber numberWithInteger:1]]) {
                guides = dic[@"msg"];
                [_tblView reloadData];
            }
        }
        showProgress(NO);
    }];
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
    return guides.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    UIImageView *imgView = (UIImageView *)[cell viewWithTag:10];
    UILabel *lbl = (UILabel *)[cell viewWithTag:20];
    UIActivityIndicatorView *activityIndication = (UIActivityIndicatorView *)[cell viewWithTag:30];
    
    NSDictionary *dict = guides[indexPath.row];
    NSString *imgURL;
    if([dict[@"guidecover"] length] == 0)
        imgURL = @"";
    else
        imgURL = dict[@"guidecover"];
    
    activityIndication.hidden = NO;
    [activityIndication startAnimating];
    [imgView sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"placeHolder.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        activityIndication.hidden = YES;
        [activityIndication stopAnimating];
    }];
    
    lbl.text = dict[@"guides"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GuideDetailsViewController *details = [self.storyboard instantiateViewControllerWithIdentifier:@"GuideDetailsViewController"];
    details.dictGuides = guides[indexPath.row];
    details.selectedCityDictionary = _selectedCityDictionary;
    self.hidesBottomBarWhenPushed = YES;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
        [self showViewController:details sender:nil];
    }else{
        [self.navigationController pushViewController:details animated:YES];
    }
    
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    NSIndexPath *indexPath = (NSIndexPath *)sender;
//    GuideDetailsViewController *details = (GuideDetailsViewController *)segue.destinationViewController;
//    details.dictGuides = guides[indexPath.row];
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
