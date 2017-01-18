//
//  EditDateViewController.m
//  HHWT
//
//  Created by sampath kumar on 20/02/16.
//  Copyright (c) 2016 Sam Software. All rights reserved.
//

#import "EditDateViewController.h"
#import "AppDelegate.h"

@interface EditDateViewController ()
{
    NSDate *selectedStartDate;
    NSDate *selectedEndDate;

    AppDelegate *appdel;
    BOOL isStartDateActive;
    NSMutableData *mutableData;
    
}
@end
@implementation EditDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    isStartDateActive = YES;
    appdel = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    _txtStart.text = [dateFormatter stringFromDate:appdel.startDate];
    _txtEnd.text = [dateFormatter stringFromDate:appdel.endDate];
    selectedStartDate =appdel.startDate;
    selectedEndDate =appdel.endDate;
    _datePicker.date = appdel.startDate;
    _txtTripName.text = [_getTripDic objectForKey:@"TripName"];
    
    _txtTripName.layer.borderColor = THEME_COLOR.CGColor;
    _txtTripName.layer.borderWidth = 1.0f;
    [_txtTripName becomeFirstResponder];
}

- (IBAction)selectedDate:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *formatedDate = [dateFormatter stringFromDate:self.datePicker.date];
    
    if(isStartDateActive){
        self.txtStart.text = formatedDate;
        selectedStartDate= self.datePicker.date;
    }
    else{
        self.txtEnd.text = formatedDate;
        selectedEndDate= self.datePicker.date;
    }
}

-(void)addDateToDB
{
    if([_txtTripName.text length] == 0 || [_txtTripName.text isEqualToString:@""])
    {
        [[[UIAlertView alloc] initWithTitle:@"Info" message:@"Please fill all the fgields" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/update_tripdetails.php"];
    NSString *parameter;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *startDate1 = [dateFormatter stringFromDate:selectedStartDate];
    NSString *endDate1 = [dateFormatter stringFromDate:selectedEndDate];
    
    parameter = [NSString stringWithFormat:@"tripid=%@&fb_id=%@&tripname=%@&sdate=%@&edate=%@&tripdes=%@",[_getTripDic objectForKey:@"TripID"],[[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"],_txtTripName.text,startDate1,endDate1,@""];
    
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
    showProgress(NO);
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:mutableData options: NSJSONReadingMutableContainers error: nil];
    if([[jsonDict objectForKey:@"status"] integerValue] == 1)
    {
        appdel.startDate = selectedStartDate;
        appdel.endDate = selectedEndDate;
        [_detailTripClass.getTripDic setObject:_txtTripName.text forKey:@"TripName"];
        [_detailTripClass.getTripDic setObject:_txtEnd.text forKey:@"EndDate"];
        [_detailTripClass.getTripDic setObject:_txtStart.text forKey:@"StartDate"];
        
    }else
    {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[jsonDict objectForKey:@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _datePicker.hidden = NO;
    if(textField == _txtStart){
        [_txtTripName resignFirstResponder];
        isStartDateActive = YES;
        _txtStart.layer.borderColor = THEME_COLOR.CGColor;
        _txtStart.layer.borderWidth = 1.0f;
        
        _txtEnd.layer.borderWidth = 0.0f;
        _txtTripName.layer.borderWidth = 0.0f;
        
        [_datePicker setMinimumDate:nil];

        
    }else if(textField == _txtEnd){
        [_txtTripName resignFirstResponder];
        isStartDateActive = NO;
        _txtEnd.layer.borderColor = THEME_COLOR.CGColor;
        _txtEnd.layer.borderWidth = 1.0f;
        
        _txtStart.layer.borderWidth = 0.0f;
        _txtTripName.layer.borderWidth = 0.0f;
        
        [_datePicker setMinimumDate:appdel.startDate];
    }else{
        _datePicker.hidden = YES;
        _txtTripName.layer.borderColor = THEME_COLOR.CGColor;
        _txtTripName.layer.borderWidth = 1.0f;
        
        _txtStart.layer.borderWidth = 0.0f;
        _txtEnd.layer.borderWidth = 0.0f;
        return YES;
    }
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)done:(id)sender {
    showProgress(YES);
    [self performSelector:@selector(addDateToDB) withObject:nil afterDelay:0.2f];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
