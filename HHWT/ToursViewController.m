//
//  ToursViewController.m
//  HHWT
//
//  Created by SampathKumar on 28/07/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import "ToursViewController.h"
#import "AppDelegate.h"
#import "ExploreTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ToursDetail.h"

@interface ToursViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableData *mutableData;
    NSMutableArray *cityListArray;
}

@end

@implementation ToursViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Tour";
    
    cityListArray = [NSMutableArray new];
    showProgress(YES);
    [self performSelector:@selector(fetchCities) withObject:nil afterDelay:0.2f];
}

- (void)fetchCities {
    NSString *urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/tourcities.php"];
//    NSString *parameter;
//    parameter = [NSString stringWithFormat:@"id=1"];
//    NSData *parameterData = [parameter dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    [theRequest addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPMethod:@"POST"];
//    [theRequest setHTTPBody:parameterData];
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
        [_tableViw reloadData];
    }else {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[jsonDict objectForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
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
    ToursDetail *dis = [self.storyboard instantiateViewControllerWithIdentifier:TOURS_DETAIL_STORYBOARD_ID];
    dis.selectedCityDictionary = dataDic;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
        [self showViewController:dis sender:nil];
    }else{
        [self.navigationController pushViewController:dis animated:YES];
    }
}

@end

