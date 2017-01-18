//
//  AddTripViewController.m
//  HHWT
//
//  Created by sampath kumar on 07/02/16.
//  Copyright (c) 2016 Sam Software. All rights reserved.
//

#import "AddTripViewController.h"
#import "AddTripCollectionViewCell.h"
#import "AddTrip2CollectionViewCell.h"
#import "AppDelegate.h"
#import "DetailTripViewController.h"
#import "ExploredetailViewController.h"
#import "ListPlacesViewController.h"

@interface AddTripViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    AppDelegate *appdel;
    NSMutableArray *dateArray;
    NSDate *startDate;
    NSDate *endDate;
    NSDate *nextDate;
    NSDateComponents *dayDifference;
    NSUInteger dayOffset;
    NSString *selectedDate;
    NSMutableData *mutableData;

}

@end

@implementation AddTripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    appdel = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    dateArray = [NSMutableArray array];
    [self populateDates];
    [_collectionView reloadData];
}

-(void)populateDates
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *start = [df stringFromDate:appdel.startDate];
    NSString *end = [df stringFromDate:appdel.endDate];
    
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
    //    for (NSDate *date in dateArray) {
    //        NSLog(@"%@", [df stringFromDate:date]);
    //    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return dateArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == dateArray.count)
    {
        AddTrip2CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"trip2Cell" forIndexPath:indexPath];
        return cell;
    }else{
        AddTripCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"tripCell" forIndexPath:indexPath];
            NSDate *getDate =  dateArray[indexPath.row];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"dd"];
            NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
            [dateFormatter1 setDateFormat:@"EEE"];
            cell.lbldate.text =[df stringFromDate:getDate];
            cell.lblDay.text =[dateFormatter1 stringFromDate:getDate];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == dateArray.count)
    {
        showProgress(YES);
        [self performSelector:@selector(addDateToDB) withObject:nil afterDelay:0.2f];
        
    }else{
        showProgress(YES);
        NSDate *getDate =  dateArray[indexPath.row];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        selectedDate = [dateFormatter stringFromDate:getDate];
        [self performSelector:@selector(addDateToTrip) withObject:nil afterDelay:0.1f];
    }
}

-(void)addDateToDB
{
    NSString *urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/update_tripdetails.php"];
    NSString *parameter;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *startDate1 = [dateFormatter stringFromDate:appdel.startDate];
    NSString *endDate1 = [dateFormatter stringFromDate:nextDate];
    
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



-(void)addDateToTrip
{
    NSString *urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/trip_timingdetails.php"];
    NSString *parameter;
    
    parameter = [NSString stringWithFormat:@"fb_id=%@&tripid=%@&stime=%@&etime=%@&ttdate=%@&dataelementid=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"],[_getTripDic objectForKey:@"TripID"],@"9:00",@"9:00",selectedDate,_elementID];
    
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
        if([[jsonDict objectForKey:@"msg"] isEqualToString:@"Date added successfully"])
        {
            appdel.endDate = nextDate;
            [dateArray addObject:nextDate];
            [dayDifference setDay:dayOffset++];
            NSDate *d = [[NSCalendar currentCalendar] dateByAddingComponents:dayDifference toDate:startDate options:0];
            nextDate = d;
            [_collectionView reloadData];

        }else
        {
           
            [[[UIAlertView alloc] initWithTitle:@"HHWT" message:@"Trip Added successfully!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
        
            for (UIViewController *food in self.navigationController.viewControllers) {
                if ([food isKindOfClass:[ExploredetailViewController class]] || [food isKindOfClass:[ListPlacesViewController class]]) {
                    
                    [self.navigationController popToViewController:food animated:YES];
                }
            }
            
            
        }
    }else
    {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[jsonDict objectForKey:@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
    }

    showProgress(NO);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([alertView.message isEqualToString:@"Added Date successfully!"])
    {
        [self.navigationController popViewControllerAnimated:YES];
        
        
//        NSArray *viewControllers = [[self navigationController] viewControllers];
//        for( int i=0;i<[viewControllers count];i++){
//            id obj=[viewControllers objectAtIndex:i];
//            if([obj isKindOfClass:[DetailTripViewController class]]){
//                [[self navigationController] popToViewController:obj animated:YES];
//                return;
//            }
//        }
    }
}

@end
