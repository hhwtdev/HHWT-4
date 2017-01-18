//
//  Explore2.m
//  HHWT
//
//  Created by SampathKumar on 16/10/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import "Explore2.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "FoodTableViewCell.h"
#import "ExploredetailViewController.h"
#import "TourDetailModel.h"
#import "FoodNewTableViewCell.h"
#import "ThingstoDoTableViewCell.h"
#import "NewDealsTableViewCell.h"
#import "DetailTableViewController.h"
#import "CreateTripViewController.h"
#import "TourDetail2.h"

#define Things_Active           1
#define Food_Active             2
#define Special_Deals_Active    3

@interface Explore2 () <UITableViewDelegate, UITableViewDataSource>
{
    int selectedButtonAction;
    NSMutableData *mutableData;
    NSMutableArray *dataArray1;
    NSMutableArray *dataArray2;
    NSMutableArray *dataArray3;
    UIColor *tintColor;
}

@end

@implementation Explore2

- (void)viewDidLoad {
    
    float screenWidth = [[UIScreen mainScreen] bounds].size.width;
    _tbl1Width.constant = screenWidth;
    _tbl2Width.constant = screenWidth;
    _tbl3Width.constant = screenWidth;
    
    
    _scrollBaseViewWidth.constant = screenWidth * 3;
    
    tintColor = [UIColor colorWithRed:50/255.0f green:204/255.0f blue:203/255.0f alpha:1.0f];

    [_btnFood setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_btnThingsToDo setTitleColor:tintColor forState:UIControlStateNormal];
    [_btnDeals setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    selectedButtonAction = Things_Active;
    _tblView1.scrollEnabled = NO;
    _tblView2.scrollEnabled = NO;
    _tblView3.scrollEnabled = NO;

    _tblView1.tableFooterView = [[UIView alloc] init];
    _tblView2.tableFooterView = [[UIView alloc] init];
    _tblView3.tableFooterView = [[UIView alloc] init];
    _lblDiscover.text = [@"Discover " stringByAppendingString:[[_selectedCityDictionary objectForKey:@"city"] uppercaseString]];
    
    UIImage *btnImage = [UIImage imageNamed:@"secondfood.png"];
    [_btnFood setImage:btnImage forState:UIControlStateNormal];
    
    UIImage *btnnnImage = [UIImage imageNamed:@"secondspecial.png"];
    [_btnDeals setImage:btnnnImage forState:UIControlStateNormal];
    
    UIImage *btnnImage = [UIImage imageNamed:@"secselthings.png"];
    [_btnThingsToDo setImage:btnnImage forState:UIControlStateNormal];
    

    NSLog(@"%@",_selectedCityDictionary);
    
    NSString *imgURL;
    if([[_selectedCityDictionary objectForKey:@"img"] length] == 0)
        imgURL = @"";
    else
        imgURL = [_selectedCityDictionary objectForKey:@"img"];
    NSString *citydetail;
    NSString *citydes;
    
    citydetail = [_selectedCityDictionary objectForKey:@"salutation"];
    citydes= [_selectedCityDictionary objectForKey:@"description"];
    
    _explorehead.text=citydetail;
    [_explorehead sizeToFit];
    
     _exploreexpl.numberOfLines = 0;

    _exploreexpl.text=citydes;
    [_exploreexpl sizeToFit];
    
    
    self.loading.hidden = NO;
    [self.loading startAnimating];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"placeHolder.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.loading.hidden = YES;
        [self.loading stopAnimating];
    }];
    
   // self.title = [_selectedCityDictionary objectForKey:@"city"];
    
    UIView *viewForNavigationBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [viewForNavigationBar setBackgroundColor:[UIColor clearColor]];
    
    
        
        UILabel *lblLogo = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-140, 0, 100, 23)];
        lblLogo.text = [_selectedCityDictionary objectForKey:@"city"];
        lblLogo.textColor = [UIColor whiteColor];
               [viewForNavigationBar addSubview:lblLogo];
          [lblLogo setFont:[UIFont systemFontOfSize:18]];
    lblLogo.textAlignment = NSTextAlignmentCenter;
    
    UILabel *lblLogo1 = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-140, 23, 100, 23)];
    lblLogo1.text = [_selectedCityDictionary objectForKey:@"country"];
    lblLogo1.textColor = [UIColor whiteColor];
    [lblLogo1 setFont:[UIFont systemFontOfSize:14]];
    lblLogo1.textAlignment = NSTextAlignmentCenter;
    [viewForNavigationBar addSubview:lblLogo1];
    
   self.navigationItem.titleView = viewForNavigationBar;
    
    [_tblView1 registerNib:[UINib nibWithNibName:@"ThingstoDoTableViewCell" bundle:nil] forCellReuseIdentifier:@"ThingstoDoTableViewCell"];
    [_tblView2 registerNib:[UINib nibWithNibName:@"FoodNewTableViewCell" bundle:nil] forCellReuseIdentifier:@"FoodNewTableViewCell"];
    [_tblView3 registerNib:[UINib nibWithNibName:@"NewDealsTableViewCell" bundle:nil] forCellReuseIdentifier:@"NewDealsTableViewCell"];
    

    showProgress(YES);
    [self performSelector:@selector(fetchData) withObject:nil afterDelay:0.2f];
    [super viewDidLoad];
}

- (IBAction)btnSelectionAction:(UIButton *)sender
{
    
    [self resetButton];
    float screenWidth = [[UIScreen mainScreen] bounds].size.width;

    if(sender.tag == Things_Active)
    {
        UIImage *btnImage = [UIImage imageNamed:@"secselthings.png"];
        [_btnThingsToDo setImage:btnImage forState:UIControlStateNormal];
        
        UIImage *btnnImage = [UIImage imageNamed:@"secondfood.png"];
        [_btnFood setImage:btnnImage forState:UIControlStateNormal];
        
        UIImage *btnnnImage = [UIImage imageNamed:@"secondspecial.png"];
        [_btnDeals setImage:btnnnImage forState:UIControlStateNormal];
        
        
        [_scroll setContentOffset:CGPointMake(0, 0) animated:YES];
        
        selectedButtonAction = Things_Active;
        
        if(dataArray1.count <= 0){
            [self resetButton];
            [_btnThingsToDo setTitleColor:tintColor forState:UIControlStateNormal];
            showProgress(YES);
            [self performSelector:@selector(fetchData) withObject:nil afterDelay:0.2f];
        }
        [_tblView1 reloadData];
    }
    else if(sender.tag == Food_Active)
    {
        UIImage *btnImage = [UIImage imageNamed:@"secondselfood.png"];
        [_btnFood setImage:btnImage forState:UIControlStateNormal];
        
        UIImage *btnnnImage = [UIImage imageNamed:@"secondspecial.png"];
        [_btnDeals setImage:btnnnImage forState:UIControlStateNormal];
        
        UIImage *btnnImage = [UIImage imageNamed:@"secondthings.png"];
        [_btnThingsToDo setImage:btnnImage forState:UIControlStateNormal];
        

        
        
        [_scroll setContentOffset:CGPointMake(screenWidth, 0) animated:YES];

        
        selectedButtonAction = Food_Active;
        if(dataArray2.count <= 0){
            [self resetButton];
            
            [_btnFood setTitleColor:tintColor forState:UIControlStateNormal];
            
            showProgress(YES);
            [self performSelector:@selector(fetchData) withObject:nil afterDelay:0.2f];
        }
        [_tblView2 reloadData];
    }
    else
    {
        UIImage *btnImage = [UIImage imageNamed:@"secondselspecial.png"];
        [_btnDeals setImage:btnImage forState:UIControlStateNormal];
        
        
        UIImage *btnnImage = [UIImage imageNamed:@"secondthings.png"];
        [_btnThingsToDo setImage:btnnImage forState:UIControlStateNormal];
        
        UIImage *btnnnImage = [UIImage imageNamed:@"secondfood.png"];
        [_btnFood setImage:btnnnImage forState:UIControlStateNormal];
        

        
        [_scroll setContentOffset:CGPointMake(screenWidth * 2, 0) animated:YES];

        
        selectedButtonAction = Special_Deals_Active;
        if(dataArray3.count <= 0){
            [self resetButton];
            
            [_btnDeals setTitleColor:tintColor forState:UIControlStateNormal];
            showProgress(YES);
            [self performSelector:@selector(fetchData) withObject:nil afterDelay:0.2f];
        }
        
        [_tblView3 reloadData];
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    float xVal = scrollView.contentOffset.x ;
   
    [self resetButton];

    if(xVal  == 0) {
        selectedButtonAction = Things_Active;
        [_btnThingsToDo setTitleColor:tintColor forState:UIControlStateNormal];

        if(dataArray1.count <= 0){
            showProgress(YES);
            [self performSelector:@selector(fetchData) withObject:nil afterDelay:0.2f];
        }
        [_tblView1 reloadData];
        
    }else if(xVal == pageWidth) {
        selectedButtonAction = Food_Active;
        [_btnFood setTitleColor:tintColor forState:UIControlStateNormal];
        
        UIImage *btnImage = [UIImage imageNamed:@"secondselfood.png"];
        [_btnFood setImage:btnImage forState:UIControlStateNormal];
        
        UIImage *btnnnImage = [UIImage imageNamed:@"secondspecial.png"];
        [_btnDeals setImage:btnnnImage forState:UIControlStateNormal];
        
        UIImage *btnnImage = [UIImage imageNamed:@"secondthings.png"];
        [_btnThingsToDo setImage:btnnImage forState:UIControlStateNormal];

         if(dataArray2.count <= 0){
             
             
             showProgress(YES);
             [self performSelector:@selector(fetchData) withObject:nil afterDelay:0.2f];
         }
        [_tblView2 reloadData];


    }else if(xVal == pageWidth * 2) {
        
        selectedButtonAction = Special_Deals_Active;
        [_btnDeals setTitleColor:tintColor forState:UIControlStateNormal];
        UIImage *btnImage = [UIImage imageNamed:@"secondselspecial.png"];
        [_btnDeals setImage:btnImage forState:UIControlStateNormal];
        
        
        UIImage *btnnImage = [UIImage imageNamed:@"secondthings.png"];
        [_btnThingsToDo setImage:btnnImage forState:UIControlStateNormal];
        
        UIImage *btnnnImage = [UIImage imageNamed:@"secondfood.png"];
        [_btnFood setImage:btnnnImage forState:UIControlStateNormal];


         if(dataArray3.count <= 0){
             
             showProgress(YES);
             [self performSelector:@selector(fetchData) withObject:nil afterDelay:0.2f];
         }
        
        [_tblView3 reloadData];

    }
    
    
}

-(void)fetchData
{
    NSString *urlString = @"";
    NSString *parameter = @"";
    
    if(selectedButtonAction == Things_Active) {
        
        urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/get_category_value_new.php"];
        parameter = [NSString stringWithFormat:@"cid=3&cityid=%@",[_selectedCityDictionary objectForKey:@"sno"]];
    }
    else if(selectedButtonAction == Food_Active) {
        
        urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/get_category_value_new.php"];
        parameter = [NSString stringWithFormat:@"cid=1&cityid=%@",[_selectedCityDictionary objectForKey:@"sno"]];
    }
    else {
        urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/tourcontent.php"];
        parameter = [NSString stringWithFormat:@"id=%@",[_selectedCityDictionary objectForKey:@"sno"]];
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

-(void)prepareToursSata:(NSDictionary *)jsonDict {
    
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:mutableData options: NSJSONReadingMutableContainers error: nil];
    
    if(selectedButtonAction == Things_Active)
    {
        if([[jsonDict objectForKey:@"Status"] integerValue] == 1)
        {
            dataArray1 = [NSMutableArray array];
            dataArray1 = [NSMutableArray arrayWithArray:[jsonDict objectForKey:@"categorylistvalues"]];
        }
    }
    else if(selectedButtonAction == Food_Active)
    {
        if([[jsonDict objectForKey:@"Status"] integerValue] == 1)
        {
            dataArray2 = [NSMutableArray array];
            dataArray2 = [NSMutableArray arrayWithArray:[jsonDict objectForKey:@"categorylistvalues"]];
        }
    }
    else if(selectedButtonAction == Special_Deals_Active)
    {
        if([[jsonDict objectForKey:@"success"] integerValue] == 1) {
            
            dataArray3 = [NSMutableArray array];
            
            if([[jsonDict objectForKey:@"tours_content"] count] > 0)
            {
                for(NSDictionary *getDic in [jsonDict objectForKey:@"tours_content"])
                {
                    TourDetailModel *modelData = [[TourDetailModel alloc]init];
                    modelData.contentString = [getDic objectForKey:@"content"];
                    modelData.addi_info = [getDic objectForKey:@"addi_info"];
                    modelData.cancellation_policy = [getDic objectForKey:@"cancellation_policy"];
                    modelData.departuredate = [getDic objectForKey:@"departuredate"];
                    modelData.departurepoint = [getDic objectForKey:@"departurepoint"];
                    modelData.departuretime = [getDic objectForKey:@"departuretime"];
                    modelData.duration = [getDic objectForKey:@"duration"];
                    modelData.currency = [getDic objectForKey:@"currency"];
                    modelData.enquiry = [getDic objectForKey:@"enquiry"];
                    
                    modelData.inclusionandexclusion = [getDic objectForKey:@"inclusionandexclusion"];
                    
                    modelData.highlights = [getDic objectForKey:@"highlights"];
                    modelData.tourID = [[getDic objectForKey:@"id"] intValue];
                    modelData.imgFour = [getDic objectForKey:@"image_four"];
                    modelData.imgThree = [getDic objectForKey:@"image_three"];
                    modelData.imgTwo = [getDic objectForKey:@"image_two"];
                    modelData.imgOne = [getDic objectForKey:@"image_one"];
                    modelData.location = [getDic objectForKey:@"location"];
                    modelData.number = [getDic objectForKey:@"number"];
                    modelData.overviews = [getDic objectForKey:@"overviews"];
                    modelData.rateVal = [getDic objectForKey:@"rate"];
                    modelData.returndetails = [getDic objectForKey:@"returndetails"];
                    modelData.sellingRateVal = [[getDic objectForKey:@"selling_rate"] intValue];
                    modelData.snoVal = [[getDic objectForKey:@"sno"] intValue];
                    modelData.subID = [[getDic objectForKey:@"sub_id"] intValue];
                    modelData.tourType = [getDic objectForKey:@"tour_type"];
                    modelData.tour_classification_one = [getDic objectForKey:@"tour_classification_one"];
                    modelData.tour_classification_two = [getDic objectForKey:@"tour_classification_two"];
                    modelData.tour_opt_info = [getDic objectForKey:@"tour_opt_info"];
                    modelData.tour_opt_link = [getDic objectForKey:@"tour_opt_link"];
                    modelData.website = [getDic objectForKey:@"website"];
                    modelData.whatcanyouexpect = [getDic objectForKey:@"whatcanyouexpect"];
                    
                    modelData.longOverview = [getDic objectForKey:@"long_overviews"];
                    modelData.overview1 = [getDic objectForKey:@"overview_one"];
                    modelData.overview2 = [getDic objectForKey:@"overview_two"];
                    modelData.totalReviews = [[getDic objectForKey:@"reviews"] intValue];
                    [dataArray3 addObject:modelData];
                }
            }
        }
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[jsonDict objectForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
    }
    [_tblView1 reloadData];
    [_tblView2 reloadData];
    [_tblView3 reloadData];

    showProgress(NO);
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tblView1)
    {
        if ([[dataArray1[indexPath.row] objectForKey:@"tours" ] integerValue] > 0)
        {
             return 150;
        }
        else
        {
            return 130;
        }
    }else if (tableView == _tblView2)
        
        if ([[dataArray2[indexPath.row] objectForKey:@"tours" ] integerValue] > 0)
        {
            return 150;
        }
        else
        {
            return 120;
        }
    
    else if (tableView == _tblView3)
        return 130;
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _tblView1){
        if(selectedButtonAction == Things_Active) {
            return  dataArray1.count >= 3 ? 3 : dataArray1.count;
        }
    }
    
    else if (tableView == _tblView2){
        if(selectedButtonAction == Food_Active){
            return  dataArray2.count >= 3 ? 3 : dataArray2.count;
        }
    }
    
    else if (tableView == _tblView3){
        if(selectedButtonAction == Special_Deals_Active)
        {
            return  dataArray3.count >= 3 ? 3 : dataArray3.count;
        }
        
    }
    
     return 0;
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
    //FoodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"foodCell"];

    if (tableView == _tblView1)
    {
        if(selectedButtonAction == Things_Active)
        {
             ThingstoDoTableViewCell *cell = [_tblView1 dequeueReusableCellWithIdentifier:@"ThingstoDoTableViewCell" forIndexPath:indexPath];
            [cell setDataList:[dataArray1 objectAtIndex:indexPath.row] index:indexPath];
           
            return cell;

        }
    }
    
    else if (tableView == _tblView2)
    {
        if(selectedButtonAction == Food_Active)
        {
             FoodNewTableViewCell *cell = [_tblView2 dequeueReusableCellWithIdentifier:@"FoodNewTableViewCell" forIndexPath:indexPath];
            [cell setDataList:[dataArray2 objectAtIndex:indexPath.row] index:indexPath];
            return cell;

        }
    }
    
    else if (tableView == _tblView3)
    {
        if(selectedButtonAction == Special_Deals_Active)
        {
            NewDealsTableViewCell *cell = [_tblView3 dequeueReusableCellWithIdentifier:@"NewDealsTableViewCell" forIndexPath:indexPath];
            TourDetailModel *getData = [dataArray3 objectAtIndex:indexPath.row];
            [cell setDataListTour:getData index:indexPath];
            return cell;
        }
    }
    
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return nil;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectedButtonAction == Special_Deals_Active)
    {
        TourDetailModel *getData = [dataArray3 objectAtIndex:indexPath.row];
        TourDetail2 *dis = [self.storyboard instantiateViewControllerWithIdentifier:TOURS_DETAIL2_STORYBOARD_ID];
        dis.selectedTour = getData;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8"))
        {
            [self showViewController:dis sender:nil];
        }
        else
        {
            [self.navigationController pushViewController:dis animated:YES];
        }
    }
    else
    {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        DetailTableViewController *detail = [story instantiateViewControllerWithIdentifier:@"DetailTableViewController"];
        detail.selectedCityDict = _selectedCityDictionary;
        if (selectedButtonAction == Things_Active)
        {
            detail.dictDetails = [dataArray1 objectAtIndex:indexPath.row];
        }
        else if (selectedButtonAction == Food_Active)
        {
            detail.dictDetails = [dataArray2 objectAtIndex:indexPath.row];
        }
        [self.navigationController pushViewController:detail animated:YES];
    }
}


-(void)resetButton
{
    
    [_btnFood setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_btnThingsToDo setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_btnDeals setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}



- (IBAction)exploreAllAction:(id)sender
{
    //Push to category screen for select fandoms...
    ExploredetailViewController *fd = [self.storyboard instantiateViewControllerWithIdentifier:FoodViewController_STORYBOARD_ID];
    if(selectedButtonAction  == Things_Active)
        fd.selectionID = SELECTION_THINGS;
    else
        fd.selectionID = SELECTION_FOOD;
    
    self.hidesBottomBarWhenPushed = YES;

    fd.cityID = [_selectedCityDictionary objectForKey:@"sno"];
    fd.selectedCityDictionary = _selectedCityDictionary;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
        [self showViewController:fd sender:nil];
    }else{
        [self.navigationController pushViewController:fd animated:YES];
    }
}

- (IBAction)TryTripPlannerAction:(id)sender {
    
    CreateTripViewController *dis = [self.storyboard instantiateViewControllerWithIdentifier:CREATE_TRIP_STORYBOARD_ID];
    dis.selectedCityDictionary =_selectedCityDictionary;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
        [self showViewController:dis sender:nil];
    }else{
        [self.navigationController pushViewController:dis animated:YES];
    }

    
}
@end
