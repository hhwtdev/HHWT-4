
//
//  TripSummaryViewController.m
//  HHWT
//
//  Created by sampath kumar on 09/02/16.
//  Copyright (c) 2016 Sam Software. All rights reserved.
//

#import "TripSummaryViewController.h"
#import "AppDelegate.h"
#import "TripSummaryTableViewCell.h"
#import "DateCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "NotesViewController.h"

@interface TripSummaryViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate, TripSummaryTableViewCellDelegate>
{
    AppDelegate *appdel;
    NSMutableArray *dateArray;
    NSMutableArray *tripDataArray;
    NSDictionary *allDataDic;

    NSDate *startDate;
    NSDate *endDate;
    NSDate *nextDate;
    NSDateComponents *dayDifference;
    NSUInteger dayOffset;
    NSMutableData *mutableData;
    int selectedIndex;
    
    NSString *selectedDate;
}
@end

@implementation TripSummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _lblEmptyData.hidden = YES;
    
    NSString *imgURL;
    imgURL = _selectedCityDictionary == nil || [_selectedCityDictionary isEqual:nil] ? [_getTripDic objectForKey:@"Image"] : [_selectedCityDictionary objectForKey:@"img"];
    [self.topImage sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"placeHolder.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    
    _lblTop.text =  (_selectedCityDictionary == nil) || ([_selectedCityDictionary isEqual:nil]) ? [[_getTripDic objectForKey:@"CityName"] uppercaseString] : [[_selectedCityDictionary objectForKey:@"city"] uppercaseString];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.lblTop.frame.size.height - 1.2, self.lblTop.intrinsicContentSize.width, 1.2f);
    bottomBorder.backgroundColor = [UIColor whiteColor].CGColor;
    [self.lblTop.layer addSublayer:bottomBorder];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(60, 50);
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    [self.collectionV setPagingEnabled:NO];
    [self.collectionV setCollectionViewLayout:flowLayout];
    
    appdel = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    dateArray = [NSMutableArray array];
    tripDataArray = [NSMutableArray array];
    allDataDic = [NSDictionary dictionary];
    [self populateDates];
    [_collectionV reloadData];
    
    mutableData = [NSMutableData data];
    showProgress(YES);
    [self performSelector:@selector(getTripData) withObject:nil afterDelay:0.1f];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)populateDates
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *start = [df stringFromDate:appdel.startDate];
    NSString *end = [df stringFromDate:appdel.endDate];
    selectedDate = start;
    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
    [df2 setDateFormat:@"dd EEE"];
    _lblDay.text = [NSString stringWithFormat:@"Day 1 - %@",[df2 stringFromDate:appdel.startDate]];
    
    startDate = [df dateFromString:start];
    endDate = [df dateFromString:end];
    dayDifference = [[NSDateComponents alloc] init];
    
    dayOffset = 1;
    nextDate = startDate;
    do {
        [dateArray addObject:nextDate];
        [dayDifference setDay:dayOffset++];
        NSDate *d = [[NSCalendar currentCalendar] dateByAddingComponents:dayDifference toDate:startDate options:0];
        nextDate = d;
    } while([nextDate compare:endDate] == NSOrderedAscending);
    
    if(![startDate isEqualToDate:endDate])
    {
        [dateArray addObject:nextDate];
        [dayDifference setDay:dayOffset++];
        NSDate *d = [[NSCalendar currentCalendar] dateByAddingComponents:dayDifference toDate:startDate options:0];
        nextDate = d;
    }
    
    [df setDateStyle:NSDateFormatterFullStyle];
}

-(void)getTripData
{
    NSString *urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/trip_full_details.php"];
    NSString *parameter;

    if(_getTripDic)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *startDate1 = [dateFormatter stringFromDate:appdel.startDate];
        
        parameter = [NSString stringWithFormat:@"tripid=%@&fb_id=%@&date=%@",[_getTripDic objectForKey:@"TripID"],[[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"],startDate1];
    }else{
        parameter = [NSString stringWithFormat:@"tripid=%@&fb_id=%@&date=%@",_tripID,[[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"],_getStartDate];
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
        if([[jsonDict objectForKey:@"msg"] isEqualToString:@"Trip Timing deleted"])
        {
            [tripDataArray removeObjectAtIndex:(int)selectedIndex];
            [[[UIAlertView alloc] initWithTitle:@"HHWT" message:@"Element deleted successfully!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
        }
        else if([[jsonDict objectForKey:@"msg"] isEqualToString:@"Date added successfully"])
        {
         
        }
        else
        {
            [tripDataArray removeAllObjects];
            allDataDic = [NSDictionary dictionary];
            if([jsonDict objectForKey:@"result"] != [NSNull null])
            {
                tripDataArray = [NSMutableArray arrayWithArray:[jsonDict objectForKey:@"result"]];
                allDataDic = jsonDict;
            }else{
            }
        }
        
        if(tripDataArray.count>0)
        {
           _lblEmptyData.hidden = YES;
        }else{
            _lblEmptyData.hidden = NO;
        }
      
        [_tableV reloadData];
    }else
    {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[jsonDict objectForKey:@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
    }
    showProgress(NO);
}




-(void)addDate1ToDB
{
    NSString *urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/update_tripdetails.php"];
    NSString *parameter;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *startDate1 = [dateFormatter stringFromDate:appdel.startDate];
    NSString *endDate1 = [dateFormatter stringFromDate:appdel.endDate];
    
    parameter = [NSString stringWithFormat:@"tripid=%@&fb_id=%@&tripname=%@&sdate=%@&edate=%@&tripdes=%@",[_getTripDic objectForKey:@"TripID"],[[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"],[_getTripDic objectForKey:@"TripName"],startDate1,endDate1,@""];
    
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

//#pragma mark –
//#pragma mark NSURLConnection delegates
//
//-(void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
//{
//    [mutableData setLength:0];
//}
//
//-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
//{
//    [mutableData appendData:data];
//}
//
//-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
//{
//    showProgress(NO);
//    
//    [[[UIAlertView alloc] initWithTitle:@"Error" message:ERROR_MSG delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
//    return;
//}
//
//-(void)connectionDidFinishLoading:(NSURLConnection *)connection
//{
//    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:mutableData options: NSJSONReadingMutableContainers error: nil];
//    if([[jsonDict objectForKey:@"status"] integerValue] == 1)
//    {
//    }else
//    {
//        [[[UIAlertView alloc] initWithTitle:@"Error" message:[jsonDict objectForKey:@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
//    }
//}
//

- (IBAction)addDateAction:(id)sender {
    [dateArray addObject:nextDate];
    appdel.endDate = nextDate;
    [dayDifference setDay:dayOffset++];
    NSDate *d = [[NSCalendar currentCalendar] dateByAddingComponents:dayDifference toDate:startDate options:0];
    nextDate = d;
    [_collectionV reloadData];
    showProgress(YES);
    [self performSelector:@selector(addDate1ToDB) withObject:nil afterDelay:1.0f];

    [self.collectionV scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:dateArray.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

#pragma mark - UICollectionViewDataSource methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return dateArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"dateCell" forIndexPath:indexPath];
    NSDate *getDate =  dateArray[indexPath.row];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd"];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"EEE"];
    cell.lblDate.text =[df stringFromDate:getDate];
    cell.lblDays.text =[dateFormatter1 stringFromDate:getDate];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    showProgress(YES);
    NSString *urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/trip_full_details.php"];
    NSString *parameter;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    selectedDate = [dateFormatter stringFromDate:dateArray[indexPath.row]];
    
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd EEE"];
    
    _lblDay.text = [NSString stringWithFormat:@"Day %ld - %@", indexPath.row + 1,[df stringFromDate:dateArray[indexPath.row]]];

    
    
    if(_getTripDic)
    {
        parameter = [NSString stringWithFormat:@"tripid=%@&fb_id=%@&date=%@",[_getTripDic objectForKey:@"TripID"],[[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"],selectedDate];
    }else{
         parameter = [NSString stringWithFormat:@"tripid=%@&fb_id=%@&date=%@",_tripID,[[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"],selectedDate];
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tripDataArray.count;
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
    TripSummaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tripCell"];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"TripSummaryTableViewCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    cell.delegate = self;
    cell.indexVal = (int)indexPath.row;

    
    NSDictionary *dataDic = [tripDataArray objectAtIndex:indexPath.row];
    NSArray *photosArray = (NSArray *)[dataDic objectForKey:@"photos"];
    NSString *imgURL;
    if(photosArray.count == 0)
        imgURL = @"";
    else
        imgURL = [[photosArray objectAtIndex:0] valueForKey:@"photourl"];
    [cell.img sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"placeHolder.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    
//    [[dic1 objectForKey:@"address"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    cell.lblName.text = [[[tripDataArray objectAtIndex:indexPath.row] objectForKey:@"name"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                         
    cell.lblOpen.text = [[[tripDataArray objectAtIndex:indexPath.row] objectForKey:@"openhrs"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
   
    cell.lblClose.text = [[[tripDataArray objectAtIndex:indexPath.row] objectForKey:@"closehrs"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
   
    
    
//    if([[[[tripDataArray objectAtIndex:indexPath.row] objectForKey:@"foodclassification"] objectAtIndex:0] count]>0)
//    {
//        cell.lblFood.text = [[[[tripDataArray objectAtIndex:indexPath.row] objectForKey:@"foodclassification"] objectAtIndex:0] objectForKey:@"foodclassificationvalues"];
//    }
     cell.lblFood.text = @"VEG";
    cell.ratingView.rating = [[[tripDataArray objectAtIndex:indexPath.row] objectForKey:@"weight"] floatValue];
    cell.ratingView.userInteractionEnabled = NO;
    
    if ([[tripDataArray objectAtIndex:indexPath.row][@"notes"] integerValue] != 0) {
        cell.btnAddNotes.backgroundColor = [UIColor colorWithRed:253.0/255.0 green:120.0/255.0 blue:34.0/255.0 alpha:1.0];
        [cell.btnAddNotes setTitle:@"View Notes" forState:UIControlStateNormal];
    }
    else
    {
        cell.btnAddNotes.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:183.0/255.0 blue:4.0/255.0 alpha:1.0];
        [cell.btnAddNotes setTitle:@"Add Notes" forState:UIControlStateNormal];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void) btnDeleteTableViewCell:(UIButton *) button cell:(TripSummaryTableViewCell*)cell
{
    selectedIndex = cell.indexVal;
    showProgress(YES);
    [self performSelector:@selector(deleteData) withObject:nil afterDelay:1.0f];
}

-(void) btnAddNotes:(UIButton *) button cell:(TripSummaryTableViewCell*)cell
{
    NSDictionary *dataDic = [tripDataArray objectAtIndex:cell.indexVal];
    NotesViewController *exp = [self.storyboard instantiateViewControllerWithIdentifier:NOTES_STORYBOARD_ID];
    NSString *str =[dataDic objectForKey:@"tripelid"];
    exp.sno = str;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
        [self showViewController:exp sender:nil];
    }else{
        [self.navigationController pushViewController:exp animated:YES];
    }

}

-(void)deleteData
{
    NSString *urlString;
    NSString *parameter;
    NSDictionary *dataDic = [tripDataArray objectAtIndex:(int)selectedIndex];
    
    urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/delete_trip_timing.php"];
    
    if(_getTripDic)
    {
        parameter = [NSString stringWithFormat:@"fb_id=%@&tripid=%@&date=%@&dataelementid=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"],[_getTripDic objectForKey:@"TripID"],selectedDate,[dataDic objectForKey:@"sno"]];

    }else{
        parameter = [NSString stringWithFormat:@"fb_id=%@&tripid=%@&date=%@&dataelementid=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"],_tripID,selectedDate,[dataDic objectForKey:@"sno"]];

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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
