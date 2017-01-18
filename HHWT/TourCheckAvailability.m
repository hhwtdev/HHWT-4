//
//  TourCheckAvailability.m
//  HHWT
//
//  Created by SampathKumar on 07/08/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import "TourCheckAvailability.h"
#import "PickerViewController.h"
#import "AppDelegate.h"
#import "specialreq.h"


@interface TourCheckAvailability ()<UITextFieldDelegate>{
    AppDelegate *appdel;
    NSMutableData *mutableData;
}
@property (weak, nonatomic) IBOutlet UILabel *lblAdult;
@property (weak, nonatomic) IBOutlet UILabel *lblChild;
@property (weak, nonatomic) IBOutlet UILabel *lblnfant;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewObj;

@end

@implementation TourCheckAvailability

- (void)viewDidLoad {
    [super viewDidLoad];
    [_btnDate setTitle:@"" forState:UIControlStateNormal];
    appdel = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    appdel.selectedTourDate = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if(appdel.selectedTourDate != nil)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *formatedDate = [dateFormatter stringFromDate:appdel.selectedTourDate];
        [_btnDate setTitle:formatedDate forState:UIControlStateNormal];
    }
}

- (IBAction)btnDateAction:(id)sender {
    _labelo.text=@"";
    
    PickerViewController *pic = [self.storyboard instantiateViewControllerWithIdentifier:PICKER_STORYBOARD_ID];
    pic.isTourPicker = YES;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
        [self presentViewController:pic animated:YES completion:nil];
    }else{
        [self.navigationController presentViewController:pic animated:YES completion:nil];
    }
}

- (IBAction)btnAdultAdd:(id)sender {
    _lblAdult.text = [NSString stringWithFormat:@"%d",[_lblAdult.text intValue] + 1];;
}

- (IBAction)btnAdultMinus:(id)sender {
    int totalVal = [_lblAdult.text intValue] - 1;
    _lblAdult.text = [NSString stringWithFormat:@"%d",(totalVal <= 0) ? 0 : totalVal];

}

- (IBAction)btnChildAdd:(id)sender {
    _lblChild.text = [NSString stringWithFormat:@"%d",[_lblChild.text intValue] + 1];;

}

- (IBAction)btnChildMinus:(id)sender {
    
    int totalVal = [_lblChild.text intValue] - 1;
    _lblChild.text = [NSString stringWithFormat:@"%d",(totalVal <= 0) ? 0 : totalVal];

}

- (IBAction)btnInfantAdd:(id)sender {
    _lblnfant.text = [NSString stringWithFormat:@"%d",[_lblnfant.text intValue] + 1];;

}
- (IBAction)btnInfantMinus:(id)sender {
    int totalVal = [_lblnfant.text intValue] - 1;
    _lblnfant.text = [NSString stringWithFormat:@"%d",(totalVal <= 0) ? 0 : totalVal];

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [_scrollViewObj setContentOffset:CGPointMake(0, 200) animated:YES];
    return YES;
}

- (IBAction)nextAction:(id)sender {
   /* NSString *urlString = [NSString stringWithFormat:@""]; //Please enter the API for check availabiltty here...
    NSString *parameter;
    parameter = [NSString stringWithFormat:@"id=1"]; // add params here...
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
    
    */
    
    int a=0;
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    //Valid email address
    
    if ([emailTest evaluateWithObject:_txt3.text] == YES)
    {
        a=1;
    }
    else
    {
        NSLog(@"email not in proper format");
    }
    
    if(([_txt1.text isEqual:@""])||([_txt2.text isEqual:@""])||(a==0))
    {
        if([_txt1.text isEqual:@""])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"HHWT"
                                                            message:@"Enter your Country"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
        }
        else if([_txt2.text isEqual:@""])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"HHWT"
                                                            message:@"Enter your Phone Number"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"HHWT"
                                                            message:@"Enter a valid Email Address"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
    }
    else
    {

    specialreq *dis = [self.storyboard instantiateViewControllerWithIdentifier:specialrequest];
    dis.selectedTour = _selectedTour;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
        [self showViewController:dis sender:nil];
    }else{
        [self.navigationController pushViewController:dis animated:YES];
    }
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
    }else {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[jsonDict objectForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
    }
    showProgress(NO);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}

@end
