//
//  DestinationViewController.m
//  HHWT
//
//  Created by sampath kumar on 06/02/16.
//  Copyright (c) 2016 Sam Software. All rights reserved.
//

#import "DestinationViewController.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "ExploreTableViewCell.h"
#import "CreateTripViewController.h"
#import "GuidesViewController.h"
#import "ReviewFirstViewController.h"
#import "ExploredetailViewController.h"

@interface DestinationViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableData *mutableData;
    NSMutableArray *cityListArray;
}
@end

@implementation DestinationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Select a City";
    
    cityListArray = [NSMutableArray new];
    showProgress(YES);
    [self performSelector:@selector(fetchCities) withObject:nil afterDelay:0.2f];
}

- (void)fetchCities {
    NSString *urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/get_cities.php"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    [theRequest addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPMethod:@"POST"];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if( connection ) {
        mutableData = [[NSMutableData alloc] init];
    }
}

#pragma mark –
#pragma mark NSURLConnection delegates

-(void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    [mutableData setLength:0];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [mutableData appendData:data];
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    showProgress(NO);
    [[[UIAlertView alloc] initWithTitle:@"Error" message:ERROR_MSG delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
    return;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:mutableData options: NSJSONReadingMutableContainers error: nil];
    if([[jsonDict objectForKey:@"Status"] integerValue] == 1) {
        cityListArray = [NSMutableArray arrayWithArray:[jsonDict objectForKey:@"categorylist"]];
        [_tableView reloadData];
    }else {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[jsonDict objectForKey:@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
    }
    showProgress(NO);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return cityListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"exploreCell";
    ExploreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil)
    {
        cell = [[ExploreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:MyIdentifier];
    }
    
    NSDictionary *dataDic = [cityListArray objectAtIndex:indexPath.row];
    NSString *imgURL;
    if([[dataDic objectForKey:@"img"] length] == 0)
        imgURL = @"";
    else
        imgURL = [dataDic objectForKey:@"img"];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"placeHolder.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    cell.lblTitle.text = [[dataDic objectForKey:@"city"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dataDic = [cityListArray objectAtIndex:indexPath.row];
    if([_screenName isEqualToString:@"Guides"] && _screenName.length > 0)
    {
        GuidesViewController *exp = [self.storyboard instantiateViewControllerWithIdentifier:GUIDE_STORYBOARD_ID];
        exp.selectedCityDictionary = dataDic;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
            [self showViewController:exp sender:nil];
        }else{
            [self.navigationController pushViewController:exp animated:YES];
        }
    }else if([_screenName isEqualToString:@"Reviews"] && _screenName.length > 0){
        
        ExploredetailViewController *fd = [self.storyboard instantiateViewControllerWithIdentifier:FoodViewController_STORYBOARD_ID];
        fd.toReviewPage = @"YES";
        //fd.selectionID = SELECTION_THINGS;
        fd.cityID = [dataDic objectForKey:@"sno"];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
            [self showViewController:fd sender:nil];
        }else{
            [self.navigationController pushViewController:fd animated:YES];
        }
    }
    else{
        CreateTripViewController *dis = [self.storyboard instantiateViewControllerWithIdentifier:CREATE_TRIP_STORYBOARD_ID];
        dis.selectedCityDictionary = dataDic;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
            [self showViewController:dis sender:nil];
        }else{
            [self.navigationController pushViewController:dis animated:YES];
        }
    }
}

@end
