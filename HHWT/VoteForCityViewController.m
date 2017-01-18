//
//  VoteForCityViewController.m
//  HHWT
//
//  Created by SampathKumar on 10/07/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import "VoteForCityViewController.h"
#import "VoteForCityTableViewCell.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"

@interface VoteForCityViewController ()<UITableViewDelegate, UITableViewDataSource, VoteForCityTableViewCellDelegate>
{
    NSMutableData *mutableData;
    NSMutableArray *cityListArray;
    NSIndexPath *selectedIndex;
}
@end

@implementation VoteForCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    cityListArray = [NSMutableArray new];
    showProgress(YES);
    [self performSelector:@selector(fetchCities) withObject:nil afterDelay:0.2f];
}

- (void)fetchCities {
    NSString *urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/get_vote_cities.php"];
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
    static NSString *MyIdentifier = @"voteCell";
    VoteForCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil)
    {
        cell = [[VoteForCityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:MyIdentifier];
    }
    cell.delegate = self;
    cell.indexPathVal = indexPath;
    
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
    return 120;
}

- (void) tappedVote:(NSIndexPath *)path
{
    showProgress(YES);
    selectedIndex = path;
    [self performSelector:@selector(delayToVote) withObject:nil afterDelay:1.0f];
}

-(void)delayToVote
{
    NSDictionary *dataDic = [cityListArray objectAtIndex:selectedIndex.row];
    NSString *prepareURLString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/tovote.php?cityid=%@&userid=%@",[dataDic objectForKey:@"sno"],[[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"]];
    
    NSURL *URL = [NSURL URLWithString:[prepareURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSData *getData = [NSData dataWithContentsOfURL:URL];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:getData options: NSJSONReadingMutableContainers error: nil];
    if([[jsonDict objectForKey:@"Status"] integerValue] == 1) {
        [[[UIAlertView alloc] initWithTitle:@"Info" message:[jsonDict objectForKey:@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
    }else {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[jsonDict objectForKey:@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
    }
    showProgress(NO);}

@end
