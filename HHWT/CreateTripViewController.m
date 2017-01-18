//
//  CreateTripViewController.m
//  HHWT
//
//  Created by sampath kumar on 06/02/16.
//  Copyright (c) 2016 Sam Software. All rights reserved.
//

#import "CreateTripViewController.h"
#import "PickerViewController.h"
#import "AppDelegate.h"
#import "DetailTripViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "UIImageView+WebCache.h"
#import "AddTripViewController.h"

#define  SHARE_MESSAGE      @"message"
#define  SHARE_IMAGE        @"picture"
#define  SHARE_LINK         @"link"
#define  FB_GRAPH_PATH      @"/me/feed"
#define  PICTURE_URL        @""

@interface CreateTripViewController ()<UITextFieldDelegate>
{
    BOOL isStartDateActive;
    AppDelegate *appdel;
    NSMutableData *mutableData;
    NSMutableDictionary *tripDic;
    NSString *cityID;
}

@end

@implementation CreateTripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Create Trip";

    cityID = _selectedCityDictionary ==  nil ? _cityIDFromMyTrips : [_selectedCityDictionary objectForKey:@"sno"] ;
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.startDate.frame.size.height - 1.0, self.startDate.frame.size.width+5, 1.0f);
    bottomBorder.backgroundColor = THEME_COLOR.CGColor;
    [self.startDate.layer addSublayer:bottomBorder];
    
    CALayer *bottomBorder1 = [CALayer layer];
    bottomBorder1.frame = CGRectMake(0.0f, self.endDate.frame.size.height - 1.0, self.endDate.frame.size.width+5, 1.0f);
    bottomBorder1.backgroundColor = THEME_COLOR.CGColor;
    [self.endDate.layer addSublayer:bottomBorder1];
    
    self.tripName.layer.borderWidth=0.8f;
    self.tripName.layer.borderColor=[UIColor colorWithRed:136/255.0f green:165/255.0f blue:156/255.0f alpha:1.0f].CGColor;
    self.tripName.layer.masksToBounds = YES;
    
    NSString *imgURL;
    imgURL = [_selectedCityDictionary objectForKey:@"img"];
    [self.topImage sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"placeHolder.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    
    self.tripName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter Trip Name" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    self.startDate.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Start Date" attributes:@{NSForegroundColorAttributeName: THEME_COLOR}];
    
    self.endDate.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"End Date" attributes:@{NSForegroundColorAttributeName: THEME_COLOR}];
    
    self.btnCreateTrip.layer.cornerRadius = 3.0f;
    self.btnCreateTrip.layer.masksToBounds = YES;
    appdel = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    appdel.selectedDate = nil;
    appdel.startDate = nil;
    appdel.endDate = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *formatedDate = [dateFormatter stringFromDate:appdel.selectedDate];
    
    if(isStartDateActive)
    {
        appdel.startDate = appdel.selectedDate;
        self.startDate.text = formatedDate;
    }else{
        appdel.endDate = appdel.selectedDate;
        self.endDate.text = formatedDate;
    }
}

- (IBAction)tapAction:(id)sender {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == self.startDate)
    {
        isStartDateActive = YES;
        [self pickerAction];
        return NO;
    }else if(textField == self.endDate)
    {
        isStartDateActive = NO;
        [self pickerAction];
        return NO;
    }else{
        if(appdel.window.frame.size.height == 480)
            [_scroll setContentOffset:CGPointMake(0, 100) animated:YES];
        else if(appdel.window.frame.size.height == 568)
            [_scroll setContentOffset:CGPointMake(0, 50) animated:YES];
    }
    return YES;
}

- (IBAction)startDateAction:(id)sender {
    [self.view endEditing:YES];
    isStartDateActive = YES;
    [self pickerAction];
}
- (IBAction)endDateAction:(id)sender {
    [self.view endEditing:YES];
    isStartDateActive = NO;
    [self pickerAction];
}

-(void)pickerAction
{
    PickerViewController *pic = [self.storyboard instantiateViewControllerWithIdentifier:PICKER_STORYBOARD_ID];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
        [self presentViewController:pic animated:YES completion:nil];
    }else{
        [self.navigationController presentViewController:pic animated:YES completion:nil];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [_scroll setContentOffset:CGPointMake(0, 0) animated:YES];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)createTripAction:(id)sender {
    if([self.startDate.text length] > 0 && [self.endDate.text length]  && [_tripName.text length]>0)
    {
        showProgress(YES);
        [self performSelector:@selector(tripRegister) withObject:nil afterDelay:0.1f];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"HHWT" message:@"Please fill Trip details!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
        [alert show];
    }
}

-(void)tripRegister
{
    NSString *urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/trip_register_new.php"];
    NSString *parameter;
    parameter = [NSString stringWithFormat:@"fb_id=%@&tripname=%@&sdate=%@&edate=%@&cityid=%@&tripdes=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"], _tripName.text,_startDate.text,_endDate.text,cityID,@""];
    NSData *parameterData = [parameter dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    [theRequest addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:parameterData];
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
    if([[jsonDict objectForKey:@"status"] integerValue] == 1)
    {
        //[self autoShareContentToFacebook];
        showProgress(NO);
        [[[UIAlertView alloc] initWithTitle:@"HHWT" message:@"New trip created!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
        tripDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[jsonDict objectForKey:@"endingdate"],@"EndDate",[jsonDict objectForKey:@"startingdate"],@"StartDate",[jsonDict objectForKey:@"tripid"],@"TripID",[jsonDict objectForKey:@"tripname"],@"TripName", nil];
    }else
    {
        showProgress(NO);
       [[[UIAlertView alloc] initWithTitle:@"Error" message:[jsonDict objectForKey:@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
    }
    
}

-(void)autoShareContentToFacebook{
    NSLog(@"Facebook AutoShare Running in Background");
    NSString *contentDesc = [NSString stringWithFormat:@"I am going to Seoul in %d days time via",[self totalDays:appdel.startDate andDate:appdel.endDate]];
    NSString *urlStr = @"www.hhwt.io";
    NSString *picURL = PICTURE_URL;
    
    //If Facebook permission avialable will start Autoshare here..
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:FB_GRAPH_PATH
                                  parameters:@{SHARE_MESSAGE:contentDesc, SHARE_LINK:urlStr, SHARE_IMAGE: picURL}
                                  HTTPMethod:@"POST"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        // Insert your code here
        if(error){
            //If any error occurs will ask permission to user here...
            [self askFacebookPermission];
        }else{
            
            showProgress(NO);
            [[[UIAlertView alloc] initWithTitle:@"HHWT" message:@"New trip created!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
            
            
            //Successfully to complete autoshare here..
            NSLog(@"---------- Facebook AutoShare successfull ----------");
        }
    }];
}

-(void)askFacebookPermission{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithPublishPermissions:@[@"publish_actions"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            NSLog(@"%@",error.description);
        }else if (result.isCancelled) {
            NSLog(@"Permission Cancelled");
            
            showProgress(NO);
            [[[UIAlertView alloc] initWithTitle:@"HHWT" message:@"New trip created!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
            
        }else {
            NSLog(@"Permission granted");
            [self autoShareContentToFacebook];
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([alertView.message isEqualToString:@"New trip created!"])
    {
        if(buttonIndex == 0)
        {
            
            if([_dataele isEqual:@""])
                
            {
            _tripName.text=@"";
            _startDate.text=@"";
            _endDate.text=@"";

            DetailTripViewController *exp = [self.storyboard instantiateViewControllerWithIdentifier:DETAIL_TRIP_STORYBOARD_ID];
            exp.getTripDic= tripDic;
            exp.selectedCityDictionary = _selectedCityDictionary;
                self.hidesBottomBarWhenPushed = YES;

            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
                [self showViewController:exp sender:nil];
            }else{
                [self.navigationController pushViewController:exp animated:YES];
            }
            
            }
            else
            {
            
                
                AddTripViewController *exp = [self.storyboard instantiateViewControllerWithIdentifier:addtripss];
                exp.getTripDic= tripDic;
                exp.elementID = _dataele;
                self.hidesBottomBarWhenPushed = YES;

                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
                    [self showViewController:exp sender:nil];
                }else{
                    [self.navigationController pushViewController:exp animated:YES];
                }

                
                
            }
            
            
            
        }
    }
}

- (int)totalDays:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    return (int)[difference day];
}


@end
