//
//  MyTripsViewController.m
//  HHWT
//
//  Created by sampath kumar on 13/02/16.
//  Copyright (c) 2016 Sam Software. All rights reserved.
//

#import "MyTripsViewController.h"
#import "MyTripsTableViewCell.h"
#import "AppDelegate.h"
#import "TripSummaryViewController.h"
#import "DetailTripViewController.h"
#import "AddTripViewController.h"
#import "CreateTripViewController.h"
#import "UIImageView+WebCache.h"
#import "DestinationViewController.h"

#define ALERT_MSG @"You haven't created a trip yet! Do you want to create a new trip now?"

@interface MyTripsViewController () <UITableViewDataSource, UITableViewDelegate, MyTripsTableViewCellDelegate>
{
    NSMutableData *mutableData;
    NSMutableArray *dataArray;
    int selectedIndex;
    AppDelegate *appDel;
}

@end

@implementation MyTripsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _table.tableFooterView = [[UIView alloc] init];

    appDel = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    self.title = @"Trips";
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    dataArray = [NSMutableArray array];
    showProgress(YES);
    [self performSelector:@selector(fetchData) withObject:nil afterDelay:1.0f];
}

-(void)fetchData
{
    NSString *urlString;
    NSString *parameter;
    
    if(_isExploreActive == YES)
    {
        urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/user_trip_details_new.php"];
        parameter = [NSString stringWithFormat:@"fb_id=%@&cityid=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"],_cityID];
    }else{
        urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/user_trip_details.php"];
        parameter = [NSString stringWithFormat:@"fb_id=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"]];
    }
    
    NSData *parameterData = [parameter dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    [theRequest addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:parameterData];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if( connection )
    {
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
    if([[jsonDict objectForKey:@"status"] integerValue] == 1)
    {
        if([[jsonDict objectForKey:@"msg"] isEqualToString:@"Trip deleted"])
        {
            [[[UIAlertView alloc] initWithTitle:@"HHWT" message:@"Trip deleted successfully!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
        }else{
            if([AppDelegate isEmpty:[jsonDict objectForKey:@"result"]] == NO)
                dataArray = [NSMutableArray arrayWithArray:[jsonDict objectForKey:@"result"]];
        }
        [_table reloadData];
    }
    
    if(dataArray.count >0){
        _lblEmptyData.hidden = YES;
    }
    else{
        _lblEmptyData.hidden = NO;
        
        [[[UIAlertView alloc] initWithTitle:@"HHWT" message:ALERT_MSG delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"ok", nil] show];
        
    }
    showProgress(NO);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([alertView.message isEqualToString:@"Trip deleted successfully!"])
    {
        [dataArray removeObjectAtIndex:(int)selectedIndex];
        [_table reloadData];
    }else if ([alertView.message isEqualToString:ALERT_MSG])
    {
        if(buttonIndex == 1)
        {
            if([_cityID isEqualToString:@""] || [_cityID length]==0 || [_cityID isEqualToString:@"null"])
            {
                DestinationViewController *exp = [self.storyboard instantiateViewControllerWithIdentifier:DESTINATION_STORYBOARD_ID];
                exp.screenName = @"CreateTrip";
                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
                    [self showViewController:exp sender:nil];
                }else{
                    [self.navigationController pushViewController:exp animated:YES];
                }
            }else
            {
                CreateTripViewController *fd = [self.storyboard instantiateViewControllerWithIdentifier:CREATE_TRIP_STORYBOARD_ID];
                
                if([_elementID isEqual:@""])
                {
                    
                }
                else
                {
                    fd.dataele=_elementID;
                }
                
                fd.selectedCityDictionary = _selectedCityDictionary;
                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
                    [self showViewController:fd sender:nil];
                }else{
                    [self.navigationController pushViewController:fd animated:YES];
                }
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 118.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTripsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myTripCell"];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MyTripsTableViewCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    cell.delegate = self;
    cell.indexVal = (int)indexPath.row;
    
    NSDictionary *dataDic = [dataArray objectAtIndex:indexPath.row];
    NSString *rhea=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"createdon"]];

    rhea=[rhea substringToIndex:10];
    NSArray *components1 = [rhea componentsSeparatedByString:@"-"];
    
    NSString *day1 = components1[0];
    NSString *months = components1[1];
    NSString *year1 = components1[2];
    
    if([months isEqual:@"01"])
    {
        months=@"Jan";
    }
    else if([months isEqual:@"02"])
    {
        months=@"Feb";
    }
    else if([months isEqual:@"03"])
    {
        months=@"Mar";
        
    }
    else if([months isEqual:@"04"])
    {
        months=@"Apr";
        
    }
    else if([months isEqual:@"05"])
    {
        months=@"May";
        
    }
    else if([months isEqual:@"06"])
    {
        months=@"Jun";
        
    }
    else if ([months isEqual:@"07"])
    {
        months=@"Jul";
        
    }
    else if([months isEqual:@"08"])
    {
        months=@"Aug";
        
    }
    else if([months isEqual:@"09"])
    {
        months=@"Sep";
        
    }
    else if([months isEqual:@"10"])
    {
        months=@"Oct";
        
    }
    else if([months isEqual:@"11"])
    {
        months=@"Nov";
        
    }
    else
    {
        months=@"Dec";
        
    }

    cell.lblTripName.text = [NSString stringWithFormat:@"%@ : %@ : %@-%@",[dataDic objectForKey:@"tripname"],[dataDic objectForKey:@"city"],year1,months];
    NSString *govidate=[dataDic objectForKey:@"startingdate"];
    NSArray *components = [govidate componentsSeparatedByString:@"-"];
    NSString *day = components[0];
    NSString *month = components[1];
    NSString *year = components[2];
    
    if([month isEqual:@"01"])
    {
        month=@"Jan";
    }
    else if([month isEqual:@"02"])
    {
        month=@"Feb";
    }
    else if([month isEqual:@"03"])
    {
        month=@"Mar";
        
    }
    else if([month isEqual:@"04"])
    {
        month=@"Apr";
        
    }
    else if([month isEqual:@"05"])
    {
        month=@"May";
        
    }
    else if([month isEqual:@"06"])
    {
        month=@"Jun";
        
    }
    else if ([month isEqual:@"07"])
    {
        month=@"Jul";
        
    }
    else if([month isEqual:@"08"])
    {
        month=@"Aug";
        
    }
    else if([month isEqual:@"09"])
    {
        month=@"Sep";
        
    }
    else if([month isEqual:@"10"])
    {
        month=@"Oct";
        
    }
    else if([month isEqual:@"11"])
    {
        month=@"Nov";
        
    }
    else
    {
        month=@"Dec";
        
    }
    
   
    
    //cell.lblStartDate.text = [dataDic objectForKey:@"startingdate"];
    
    cell.lblStartDate.text = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    
    govidate=[dataDic objectForKey:@"endingdate"];
    
    components = [govidate componentsSeparatedByString:@"-"];
    
    day = components[0];
    month = components[1];
    year = components[2];
    
    if([month isEqual:@"01"])
    {
        month=@"Jan";
    }
    else if([month isEqual:@"02"])
    {
        month=@"Feb";
    }
    else if([month isEqual:@"03"])
    {
        month=@"Mar";
        
    }
    else if([month isEqual:@"04"])
    {
        month=@"Apr";
        
    }
    else if([month isEqual:@"05"])
    {
        month=@"May";
        
    }
    else if([month isEqual:@"06"])
    {
        month=@"Jun";
        
    }
    else if ([month isEqual:@"07"])
    {
        month=@"Jul";
        
    }
    else if([month isEqual:@"08"])
    {
        month=@"Aug";
        
    }
    else if([month isEqual:@"09"])
    {
        month=@"Sep";
        
    }
    else if([month isEqual:@"10"])
    {
        month=@"Oct";
        
    }
    else if([month isEqual:@"11"])
    {
        month=@"Nov";
        
    }
    else
    {
        month=@"Dec";
    }
    
    NSString *imgURL;
    if([[dataDic objectForKey:@"img"] length] == 0)
        imgURL = @"";
    else
        imgURL = [dataDic objectForKey:@"img"];
    
    cell.loadingIndictor.hidden = NO;
    [cell.loadingIndictor startAnimating];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"placeHolder.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        cell.loadingIndictor.hidden = YES;
        [cell.loadingIndictor stopAnimating];
    }];
    
    //cell.lblEndDate.text = [dataDic objectForKey:@"endingdate"];
    cell.lblEndDate.text = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dataDic = [dataArray objectAtIndex:indexPath.row];
    NSString *startDateStr = [dataDic objectForKey:@"startingdate"];
    NSString *endDateStr = [dataDic objectForKey:@"endingdate"];    
    
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date1 = [dateFormat dateFromString:startDateStr];
    NSDate *date2 = [dateFormat dateFromString:endDateStr];
    appDel.startDate = date1;
    appDel.endDate = date2;

     NSMutableDictionary *tripDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:endDateStr,@"EndDate",startDateStr,@"StartDate",[dataDic objectForKey:@"tripid"],@"TripID",[dataDic objectForKey:@"tripname"],@"TripName",[dataDic objectForKey:@"city"],@"CityName",[dataDic objectForKey:@"cityid"],@"CityID",[dataDic objectForKey:@"img"],@"Image", nil];
    
    if(_isExploreActive == YES)
    {
        AddTripViewController *fd = [self.storyboard instantiateViewControllerWithIdentifier:ADD_TRIP_STORYBOARD_ID];
        fd.getTripDic = tripDic;
        fd.elementID = _elementID;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
            [self showViewController:fd sender:nil];
        }else{
            [self.navigationController pushViewController:fd animated:YES];
        }
    }else{
        DetailTripViewController *exp = [self.storyboard instantiateViewControllerWithIdentifier:DETAIL_TRIP_STORYBOARD_ID];
        exp.getTripDic= tripDic;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
            [self showViewController:exp sender:nil];
        }else{
            [self.navigationController pushViewController:exp animated:YES];
        }
    }
}

-(void) btnDeleteTableViewCell:(UIButton *) button cell:(MyTripsTableViewCell *)cell
{
    selectedIndex = cell.indexVal;
    showProgress(YES);
    [self performSelector:@selector(deleteData) withObject:nil afterDelay:1.0f];
}

-(void)deleteData
{
    NSString *urlString;
    NSString *parameter;
    NSDictionary *dataDic = [dataArray objectAtIndex:(int)selectedIndex];

    urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/delete_trip.php"];
    parameter = [NSString stringWithFormat:@"fb_id=%@&tripid=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"],[dataDic objectForKey:@"tripid"]];
    
    NSData *parameterData = [parameter dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    [theRequest addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:parameterData];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if( connection )
    {
        mutableData = [[NSMutableData alloc] init];
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

- (IBAction)actionAdd:(id)sender {
    
    if([_cityID isEqualToString:@""] || [_cityID length]==0 || [_cityID isEqualToString:@"null"])
    {
        DestinationViewController *exp = [self.storyboard instantiateViewControllerWithIdentifier:DESTINATION_STORYBOARD_ID];
        exp.screenName = @"CreateTrip";
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
            [self showViewController:exp sender:nil];
        }else{
            [self.navigationController pushViewController:exp animated:YES];
        }
    }else
    {
        CreateTripViewController *fd = [self.storyboard instantiateViewControllerWithIdentifier:CREATE_TRIP_STORYBOARD_ID];
        
        if([_elementID isEqual:@""])
        {
            
        }
        else
        {
            fd.dataele=_elementID;
        }
        
        fd.selectedCityDictionary = _selectedCityDictionary;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
            [self showViewController:fd sender:nil];
        }else{
            [self.navigationController pushViewController:fd animated:YES];
        }
    }
}
@end
