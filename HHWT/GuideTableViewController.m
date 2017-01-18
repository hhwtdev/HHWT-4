//
//  GuideTableViewController.m
//  HHWT
//
//  Created by Priya on 04/11/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import "GuideTableViewController.h"
#import "ExploreTableViewCell.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "ExploreNewCell.h"
#import "GuidesViewController.h"

#define showProgress(a)             [AppDelegate showProgressForState:a]

@interface GuideTableViewController ()
{
    NSMutableData *mutableData;
    NSMutableArray *cityListArray;
}
@end

@implementation GuideTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.title = @"Guides";
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
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
        [self.tableView reloadData];
    }else {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[jsonDict objectForKey:@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
    }
    showProgress(NO);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cityListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GuideCell" forIndexPath:indexPath];
    
    UIImageView *imgView = (UIImageView *)[cell viewWithTag:10];
    UILabel *lbl = (UILabel *)[cell viewWithTag:20];
    UIActivityIndicatorView *activityIndication = (UIActivityIndicatorView *)[cell viewWithTag:30];
    
    NSDictionary *dataDic = [cityListArray objectAtIndex:indexPath.row];
    NSString *imgURL;
    if([[dataDic objectForKey:@"img"] length] == 0)
        imgURL = @"";
    else
        imgURL = [dataDic objectForKey:@"img"];
    [imgView sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"placeHolder.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    lbl.text = [[dataDic objectForKey:@"city"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dataDic = [cityListArray objectAtIndex:indexPath.row];
    GuidesViewController *exp = [self.storyboard instantiateViewControllerWithIdentifier:GUIDE_STORYBOARD_ID];
    exp.selectedCityDictionary = dataDic;
    self.hidesBottomBarWhenPushed = YES;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
        [self showViewController:exp sender:nil];
    }else{
        [self.navigationController pushViewController:exp animated:YES];
    }
    self.hidesBottomBarWhenPushed=NO;
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
