//
//  DetailTripViewController.m
//  HHWT
//
//  Created by sampath kumar on 07/02/16.
//  Copyright (c) 2016 Sam Software. All rights reserved.
//

#import "DetailTripViewController.h"
#import "AppDelegate.h"
#import "DateCollectionViewCell.h"
#import "ExploredetailViewController.h"
#import "TripSummaryViewController.h"
#import "EditDateViewController.h"
#import "UIImageView+WebCache.h"

@interface DetailTripViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate>
{
    AppDelegate *appdel;
    NSMutableArray *dateArray;
    
    NSDate *startDate;
    NSDate *endDate;
    NSDate *nextDate;
    NSDateComponents *dayDifference;
    NSUInteger dayOffset;
    NSMutableData *mutableData;
    NSDate *selectedDate;
}
@end

@implementation DetailTripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *imgURL;
    imgURL = _selectedCityDictionary == nil || [_selectedCityDictionary isEqual:nil] ? [_getTripDic objectForKey:@"Image"] : [_selectedCityDictionary objectForKey:@"img"];
    [self.topImage sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"placeHolder.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    
    _lblTop.text =  (_selectedCityDictionary == nil) || ([_selectedCityDictionary isEqual:nil]) ? [[_getTripDic objectForKey:@"CityName"] uppercaseString] : [[_selectedCityDictionary objectForKey:@"city"] uppercaseString];
    
    _txtSearchSeoul.placeholder = [NSString stringWithFormat:@"Search %@ here",_lblTop.text];

    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.lblTop.frame.size.height - 1.2, _lblTop.intrinsicContentSize.width, 1.2f);
    bottomBorder.backgroundColor = [UIColor whiteColor].CGColor;
    [self.lblTop.layer addSublayer:bottomBorder];
    
    CALayer *bottomBorder1 = [CALayer layer];
    bottomBorder1.frame = CGRectMake(0.0f, self.lbl2.frame.size.height - 1.0, self.lbl2.frame.size.width, 1.0f);
    bottomBorder1.backgroundColor = [UIColor colorWithRed:66/255.0f green:105/255.0f blue:141/255.0f alpha:1.0f].CGColor;
    [self.lbl2.layer addSublayer:bottomBorder1];

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(60, 50);
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    [self.collectionV setPagingEnabled:NO];
    [self.collectionV setCollectionViewLayout:flowLayout];
    
    appdel = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    UIBarButtonItem *editBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editBothDate)];
    self.navigationItem.rightBarButtonItem = editBtn;
    
    UIImage* image3 = [UIImage imageNamed:@"editCal.png"];
    CGRect frameimg = CGRectMake(0,0, 30,30);
    
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(editBothDate)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *mailbutton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    self.navigationItem.rightBarButtonItem =mailbutton;
}

-(void)editBothDate
{
    EditDateViewController *pic = [self.storyboard instantiateViewControllerWithIdentifier:EditDate_STORYBOARD_ID];
    pic.getTripDic = _getTripDic;
    pic.detailTripClass = self;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
        [self presentViewController:pic animated:YES completion:nil];
    }else{
        [self.navigationController presentViewController:pic animated:YES completion:nil];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _lblTripName.text = [_getTripDic objectForKey:@"TripName"];
    dateArray = [NSMutableArray array];
    [self populateDates];
    [_collectionV reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)dealloc
{
    appdel.startDate = nil;
    appdel.endDate = nil;
    appdel.selectedDate = nil;
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
}

- (IBAction)addDateAction:(id)sender {
    
    selectedDate = nextDate;
    
    
    [_txtSearchSeoul resignFirstResponder];
    showProgress(YES);
    [self performSelector:@selector(addDateToDB) withObject:nil afterDelay:1.0f];
   
}

-(void)addDateToDB
{
    NSString *urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/update_tripdetails.php"];
    NSString *parameter;
   
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *startDate1 = [dateFormatter stringFromDate:appdel.startDate];
    NSString *endDate1 = [dateFormatter stringFromDate:selectedDate];

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
        [dateArray addObject:nextDate];
        appdel.endDate = nextDate;
        [dayDifference setDay:dayOffset++];
        NSDate *d = [[NSCalendar currentCalendar] dateByAddingComponents:dayDifference toDate:startDate options:0];
        nextDate = d;
        [_collectionV reloadData];
        [self.collectionV scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:dateArray.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
    }else
    {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[jsonDict objectForKey:@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)food:(id)sender
{
    //Push to category screen for select fandoms...
    ExploredetailViewController *fd = [self.storyboard instantiateViewControllerWithIdentifier:FoodViewController_STORYBOARD_ID];
    fd.selectionID = SELECTION_FOOD;
    fd.getTripDic = _getTripDic;
    fd.cityID = _selectedCityDictionary == nil ? [_getTripDic objectForKey:@"CityID"] :  [_selectedCityDictionary objectForKey:@"sno"];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
        [self showViewController:fd sender:nil];
    }else{
        [self.navigationController pushViewController:fd animated:YES];
    }
}



-(IBAction)things:(id)sender
{
    //Push to category screen for select fandoms...
    ExploredetailViewController *fd = [self.storyboard instantiateViewControllerWithIdentifier:FoodViewController_STORYBOARD_ID];
    fd.selectionID = SELECTION_THINGS;
    fd.getTripDic = _getTripDic;
    fd.cityID = _selectedCityDictionary == nil ? [_getTripDic objectForKey:@"CityID"] :  [_selectedCityDictionary objectForKey:@"sno"];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
        [self showViewController:fd sender:nil];
    }else{
        [self.navigationController pushViewController:fd animated:YES];
    }
}

-(IBAction)prayer:(id)sender
{
    //Push to category screen for select fandoms...
    ExploredetailViewController *fd = [self.storyboard instantiateViewControllerWithIdentifier:FoodViewController_STORYBOARD_ID];
    fd.selectionID = SELECTION_PRAYER;
    fd.getTripDic = _getTripDic;
    fd.cityID = _selectedCityDictionary == nil ? [_getTripDic objectForKey:@"CityID"] :  [_selectedCityDictionary objectForKey:@"sno"];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
        [self showViewController:fd sender:nil];
    }else{
        [self.navigationController pushViewController:fd animated:YES];
    }
}


-(IBAction)tripSummary:(id)sender
{
    [_txtSearchSeoul resignFirstResponder];
    //Push to category screen for select fandoms...
    TripSummaryViewController *fd = [self.storyboard instantiateViewControllerWithIdentifier:TRIP_SUMMARY_STORYBOARD_ID];
    fd.getTripDic = _getTripDic;
    fd.selectedCityDictionary = _selectedCityDictionary;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
        [self showViewController:fd sender:nil];
    }else{
        [self.navigationController pushViewController:fd animated:YES];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(appdel.window.frame.size.height == 480)
        [_scroll setContentOffset:CGPointMake(0, 100) animated:YES];
    else if(appdel.window.frame.size.height == 568)
        [_scroll setContentOffset:CGPointMake(0, 50) animated:YES];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_scroll setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    if([_txtSearchSeoul.text length]>0){
        _txtSearchSeoul.text = @"";
        [self callSearchAction];
    }else{
        [[[UIAlertView alloc] initWithTitle:@"HHWT" message:@"Please enter your text!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
    }
    return YES;
}

- (IBAction)tapAction:(id)sender {
    [_scroll setContentOffset:CGPointMake(0, 0) animated:YES];
    [_txtSearchSeoul resignFirstResponder];
}

-(void)callSearchAction
{
    //Push to category screen for select fandoms...
    ExploredetailViewController *fd = [self.storyboard instantiateViewControllerWithIdentifier:FoodViewController_STORYBOARD_ID];
    fd.selectionID = SELECTION_THINGS;
    fd.getTripDic = _getTripDic;
    fd.isSearcSeoulActive = YES;
    fd.cityID = [_getTripDic objectForKey:@"CityID"];
    fd.getSearchSeoulText = _txtSearchSeoul.text;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
        [self showViewController:fd sender:nil];
    }else{
        [self.navigationController pushViewController:fd animated:YES];
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


@end
