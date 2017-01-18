//
//  FeedBackViewController.m
//  
//
//  Created by sampath kumar on 25/03/16.
//
//

#import "FeedBackViewController.h"
#import "AppDelegate.h"
#import "EDStarRating.h"
#import "PaceHolderTextView.h"

@interface FeedBackViewController ()<EDStarRatingProtocol>
{
    NSMutableData *mutableData;
    NSMutableDictionary *answers;
}

@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Feedback";
    
    // Do any additional setup after loading the view.
    answers = [[NSMutableDictionary alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewChange:) name:UITextViewTextDidChangeNotification object:nil];
    _tblView.layer.borderWidth = 1.0f;
    _tblView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _tblView.layer.cornerRadius = 5.0f;
    
    _ratingsView.rating = 0.0f;
    _txtView.text = @"Write your message here...";
    _txtView.textColor = [UIColor lightGrayColor];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if([_txtView.text isEqualToString:@"Write your message here..."]){
        _txtView.text = @"";
        _txtView.textColor = [UIColor blackColor];
    }
    return YES;
}

- (IBAction)tappedView:(id)sender {
    [_txtView resignFirstResponder];
}


- (IBAction)submit:(id)sender {
    NSLog(@"%f",_ratingsView.rating);
    
    if(_txtView.text.length >0 && _ratingsView.rating > 0.0 && ![_txtView.text isEqualToString:@"Write your message here..."])
    {
        [_txtView resignFirstResponder];
        showProgress(YES);
        NSString *urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/feedbackuser.php"];
        NSString *parameter;
        parameter = [NSString stringWithFormat:@"contents=%@&star=%f",_txtView.text,_ratingsView.rating];
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
    else{
        NSString *str;
        if([_txtView.text isEqualToString:@"Write your message here..."])
            str = @"Please enter your feedback";
        else
            str = _txtView.text.length == 0 ? @"Please enter your feedback" : @"Please give a rating";
        
        [[[UIAlertView alloc] initWithTitle:@"HHWT" message:str delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
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
        [[[UIAlertView alloc] initWithTitle:@"HHWT" message:@"Sucessfully reported!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
        _ratingsView.rating = 0.0f;
        _txtView.text = @"";
    }else
    {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[jsonDict objectForKey:@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
    }
    showProgress(NO);
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"heading" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }
    else if (indexPath.row == 1)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"question" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *lbl1 = (UILabel *)[cell viewWithTag:10];
        UILabel *lbl2 = (UILabel *)[cell viewWithTag:20];
        EDStarRating *start = (EDStarRating *)[cell viewWithTag:30];
        start.accessibilityValue = @"Q1";
        
        start.backgroundColor  = [UIColor clearColor];
        start.starImage = [[UIImage imageNamed:@"star-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        start.starHighlightedImage = [[UIImage imageNamed:@"star-highlighted-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        start.maxRating = 5.0;
        start.delegate = self;
        start.horizontalMargin = 15.0;
        start.editable=YES;
        start.displayMode=EDStarRatingDisplayHalf;
        [start  setNeedsDisplay];
        start.tintColor = [UIColor colorWithRed:232.0/255.0 green:192.0/255.0 blue:4.0/255.0 alpha:1.0];
        
        lbl1.text = @"Q1";
        lbl2.text = @"This app is useful for my trip planning(1 - 5 stars)";
        
        return cell;
    }
    else if (indexPath.row == 2)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"question" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *lbl1 = (UILabel *)[cell viewWithTag:10];
        UILabel *lbl2 = (UILabel *)[cell viewWithTag:20];
        EDStarRating *start = (EDStarRating *)[cell viewWithTag:30];
        start.accessibilityValue = @"Q2";
        
        start.backgroundColor  = [UIColor clearColor];
        start.starImage = [[UIImage imageNamed:@"star-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        start.starHighlightedImage = [[UIImage imageNamed:@"star-highlighted-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        start.maxRating = 5.0;
        start.delegate = self;
        start.horizontalMargin = 15.0;
        start.editable=YES;
        start.displayMode=EDStarRatingDisplayHalf;
        [start  setNeedsDisplay];
        start.tintColor = [UIColor colorWithRed:232.0/255.0 green:192.0/255.0 blue:4.0/255.0 alpha:1.0];
        lbl1.text = @"Q2";
        lbl2.text = @"It is easy to find the best things to do, places to eat and prayer spaces in this app.(1 - 5 stars)";
        
        return cell;
    }
    else if (indexPath.row == 3)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"question" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *lbl1 = (UILabel *)[cell viewWithTag:10];
        UILabel *lbl2 = (UILabel *)[cell viewWithTag:20];
        EDStarRating *start = (EDStarRating *)[cell viewWithTag:30];
        
        start.backgroundColor  = [UIColor clearColor];
        start.starImage = [[UIImage imageNamed:@"star-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        start.starHighlightedImage = [[UIImage imageNamed:@"star-highlighted-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        start.maxRating = 5.0;
        start.delegate = self;
        start.horizontalMargin = 15.0;
        start.editable=YES;
        start.displayMode=EDStarRatingDisplayHalf;
        [start  setNeedsDisplay];
        start.tintColor = [UIColor colorWithRed:232.0/255.0 green:192.0/255.0 blue:4.0/255.0 alpha:1.0];
        start.accessibilityValue = @"Q3";
        
        lbl1.text = @"Q3";
        lbl2.text = @"I will recommend this app to my friend.(1 - 5 stars)";
        
        return cell;
    }
    else if (indexPath.row == 4)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"comment" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *lbl1 = (UILabel *)[cell viewWithTag:10];
        PaceHolderTextView *textView = (PaceHolderTextView *)[cell viewWithTag:20];
        
        textView.layer.borderWidth = 1.0f;
        textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        textView.layer.cornerRadius = 5.0f;
        textView.placeholder = @"Write your messsage here...";
        textView.accessibilityValue = @"Q4";
        lbl1.text = @"What would you like else would you like to see in the app?";
        
        
        return cell;
    }
    else if (indexPath.row == 5)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"comment" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *lbl1 = (UILabel *)[cell viewWithTag:10];
        PaceHolderTextView *textView = (PaceHolderTextView *)[cell viewWithTag:20];
        
        textView.layer.borderWidth = 1.0f;
        textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        textView.layer.cornerRadius = 5.0f;
        textView.placeholder = @"Write your messsage here...";
        textView.accessibilityValue = @"Q5";
        lbl1.text = @"Say something nice to the team";
        return cell;
    }
    else if (indexPath.row == 6)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contact" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        UILabel *lbl1 = (UILabel *)[cell viewWithTag:10];
//        lbl1.text = @"I would like to be contacted by the HHWT team with regard to my response.";
        return cell;
    }
    else
    {
        return nil;
    }
}

-(void)starsSelectionChanged:(EDStarRating*)control rating:(float)rating
{
    [answers setObject:[NSString stringWithFormat:@"%.1f",rating] forKey:control.accessibilityValue];
}

- (IBAction)actionYes:(id)sender {
    [answers setObject:@"Yes" forKey:@"Q6"];
    UITableViewCell *cell = [_tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
    UIView *view1 = [cell viewWithTag:20];
    UIView *view2 = [cell viewWithTag:30];
    
    UIImageView *img1 = (UIImageView *)[view1 viewWithTag:10];
    UIImageView *img2 = (UIImageView *)[view2 viewWithTag:10];
        img1.image = [UIImage imageNamed:@"checked_checkbox"];
        img2.image = [UIImage imageNamed:@"unchecked_checkbox"];
    
}

- (IBAction)actionNo:(id)sender {
    
    [answers setObject:@"No" forKey:@"Q6"];
    UITableViewCell *cell = [_tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
    UIView *view1 = [cell viewWithTag:20];
    UIView *view2 = [cell viewWithTag:30];
    
    UIImageView *img1 = (UIImageView *)[view1 viewWithTag:10];
    UIImageView *img2 = (UIImageView *)[view2 viewWithTag:10];
            img2.image = [UIImage imageNamed:@"checked_checkbox"];
        img1.image = [UIImage imageNamed:@"unchecked_checkbox"];
    

    
    
    
}

- (IBAction)actionSubmit:(id)sender {
    
    
    if(answers.count == 6)
    {
        [self.view endEditing:YES];
        showProgress(YES);
        NSString *urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/feedbackuser.php"];
        NSString *parameter;
        parameter = [NSString stringWithFormat:@"userid=%@&question1=%@&question2=%@&question3=%@&question4=%@&question5=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"],answers[@"Q1"],answers[@"Q2"], answers[@"Q3"], answers[@"Q4"], answers[@"Q5"]];
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
    else{
        NSString *str;
        if([_txtView.text isEqualToString:@"Write your message here..."])
            str = @"Please enter your feedback";
        else
            str = _txtView.text.length == 0 ? @"Please enter your feedback" : @"Please give a rating";
        
        [[[UIAlertView alloc] initWithTitle:@"HHWT" message:str delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
    }
    
}

- (void)textViewChange:(NSNotification *)notification
{
    UITextView *txtView = (UITextView *)[notification object];
    [answers setObject:txtView.text forKey:txtView.accessibilityValue];
}
@end
