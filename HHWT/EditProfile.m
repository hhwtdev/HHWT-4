//
//  EditProfile.m
//  HHWT
//
//  Created by SampathKumar on 18/09/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import "EditProfile.h"
#import "PopView.h"
#import "AppDelegate.h"

@interface EditProfile () <UITextFieldDelegate, PopViewDelegate>
{
    NSArray *countryArray;
    NSMutableData *mutRegisterData;
    NSURLConnection *registration;
}
@end

@implementation EditProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    
    countryArray =  @[@"Singapore",@"Malaysia",@"Brunei",@"Indonesia",@"Thailand",@"UAE",@"India"];
    
    [self prepareUI];
    
    _baseView.layer.borderWidth = 1.5f;
    _baseView.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

-(void)prepareUI
{
    _lblNote.hidden = YES;
    _datePicker.hidden = YES;
    
    if([_editType isEqualToString:@"Password"])
    {
        _txtField.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"Password"];
        [_txtField setPlaceholder:@"Edit your password"];
        
        [_btnObj setTitle:@"Change Password" forState:UIControlStateNormal];
        
        _lblTopTitle.text =@"Change Password";
        
    }
    else if([_editType isEqualToString:@"Name"])
    {
        _txtField.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"];
        [_txtField setPlaceholder:@"Edit your Name"];
        _lblNote.hidden = NO;
        [_btnObj setTitle:@"Change Name" forState:UIControlStateNormal];
        _lblTopTitle.text =@"Change Name";
        
    }
    else if([_editType isEqualToString:@"PhoneNumber"])
    {
        _txtField.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"PhoneNumber"];
        [_txtField setPlaceholder:@"Edit your PhoneNumber"];
        [_btnObj setTitle:@"Add Phone Number" forState:UIControlStateNormal];
        _lblTopTitle.text =@"Add Phone Number";
        
    }
    else if([_editType isEqualToString:@"Country"])
    {
        _txtField.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"Country"];
        [_txtField setPlaceholder:@"Edit your country"];
        [_btnObj setTitle:@"Change Country" forState:UIControlStateNormal];
        _lblTopTitle.text =@"Change Country";
        
    }
    else if([_editType isEqualToString:@"DOB"])
    {
        _datePicker.hidden = NO;
        _txtField.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"DOB"];
        [_txtField setPlaceholder:@"Edit your DOB"];
        [_btnObj setTitle:@"Add Date of Birth" forState:UIControlStateNormal];
        _lblTopTitle.text =@"Add Date of Birth";
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if([_editType isEqualToString:@"Country"]){
        [self preparePopUp:textField];
        return NO;
    }
    else if([_editType isEqualToString:@"DOB"]){
        return NO;
    }
    return YES;
}

-(void)preparePopUp:(UITextField *)txtx {
    
    PopView *fpPopView = [PopView loadNib];
    fpPopView.tag = 101;
    fpPopView.isCountryPopUp = YES;
    fpPopView.isCategoryPopup = YES;
    fpPopView.rectCountry = CGRectMake((self.view.frame.size.width - 240)/2, (self.view.frame.size.height - 300)/2, 240, 300);
    [fpPopView loadData:countryArray];
    [fpPopView setUPMenu];
    fpPopView.delegate = self;
    [fpPopView showMenuForView:txtx];
}

-(void)popViewDidDismiss:(PopView *)popView
{
    
}

-(void)popView:(PopView *)popView didSelectedAtIndex:(NSUInteger)selectedIndex
{
    NSLog(@"selcted country -- %@",countryArray[selectedIndex]);
    _txtField.text = countryArray[selectedIndex];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)btnAction:(id)sender {
    
    
    if([_txtField.text length]==0){
        [[[UIAlertView alloc] initWithTitle:@"Info" message:@"Please enter your data!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
        return;
    }
    
    
    
    if([_editType isEqualToString:@"Password"])
    {
        if([_txtField.text length]<6){
            [[[UIAlertView alloc] initWithTitle:@"Info" message:@"Please enter atleast 6 character!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
            return;
        }
        [[NSUserDefaults standardUserDefaults] setValue:_txtField.text forKey:@"Password"];
    }
    else if([_editType isEqualToString:@"Name"])
    {
        [[NSUserDefaults standardUserDefaults] setValue:_txtField.text forKey:@"UserName"];
        
    }
    else if([_editType isEqualToString:@"PhoneNumber"])
    {
        
        [[NSUserDefaults standardUserDefaults] setValue:_txtField.text forKey:@"PhoneNumber"];
        
    }
    else if([_editType isEqualToString:@"Country"])
    {
        
        [[NSUserDefaults standardUserDefaults] setValue:_txtField.text forKey:@"Country"];
        
    }
    else if([_editType isEqualToString:@"DOB"])
    {
        [[NSUserDefaults standardUserDefaults] setValue:_txtField.text forKey:@"DOB"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    showProgress(YES);
    
    NSString *urlString;
    NSString *parameter;
    
    urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/testingupdateprofile.php"];
    parameter = [NSString stringWithFormat:@"fb_id=%@&imgurl=%@&name=%@&email=%@&password=%@&dob=%@&country=%@&phonenumber=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"],
                 [[NSUserDefaults standardUserDefaults] valueForKey:@"UserProfilePic"],
                 [[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"],
                 [[NSUserDefaults standardUserDefaults] valueForKey:@"UserEmail"],
                 [[NSUserDefaults standardUserDefaults] valueForKey:@"Password"],
                 [[NSUserDefaults standardUserDefaults] valueForKey:@"DOB"],
                 [[NSUserDefaults standardUserDefaults] valueForKey:@"Country"],
                 [[NSUserDefaults standardUserDefaults] valueForKey:@"PhoneNumber"]];
    
    NSData *parameterData = [parameter dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    [theRequest addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:parameterData];
    registration = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if( registration )
    {
        mutRegisterData = [[NSMutableData alloc] init];
    }
}

#pragma mark –
#pragma mark NSURLConnection delegates

-(void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    [mutRegisterData setLength:0];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    [mutRegisterData appendData:data];
    
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:@"Error" message:ERROR_MSG delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
    showProgress(NO);
    return;
}

-(BOOL)isEmpty:(id)thing {
    return thing == nil || [(NSString *)thing isKindOfClass:[NSNull class]] || ([thing respondsToSelector:@selector(length)] && [(NSData *)thing length] == 0) || ([thing respondsToSelector:@selector(count)] && [(NSArray *)thing count] == 0);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:mutRegisterData options: NSJSONReadingMutableContainers error: nil];
    showProgress(NO);
    
    if([[jsonObject valueForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]]){
        [[[UIAlertView alloc] initWithTitle:@"Info" message:[jsonObject valueForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
    }
}


- (IBAction)dateChange:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *formatedDate = [dateFormatter stringFromDate:self.datePicker.date];
    _txtField.text = formatedDate;
}
@end
