//
//  ExploredetailViewController.m
//  HHWT
//
//  Created by Priya on 04/11/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import "ExploredetailViewController.h"
#import "AppDelegate.h"
#import "FoodDetailViewController.h"
#import "PopView.h"
#import "LocationViewController.h"
#import "FilterViewController.h"
#import "ReviewTableViewController.h"
#import "UIImageView+WebCache.h"
#import "ThingstoDoTableViewCell.h"
#import "FoodNewTableViewCell.h"
#import "NewDealsTableViewCell.h"
#import "FoodNewTableViewCell.h"
#import "NewFilterViewController.h"
#import "DetailTableViewController.h"
#import "TourDetail2.h"

#define Things_Active           1
#define Food_Active             2
#define Special_Deals_Active    3

@interface ExploredetailViewController ()
{
    NSMutableData *mutableData;
    NSMutableArray *dataArray;
    NSMutableArray *dataArray3;
    NSMutableArray *originalData;
    NSMutableArray *activityArray;
    NSMutableArray *checkedStarValues;
    NSMutableArray *checkedActivities;
    UIColor *tintColor;
     NSInteger selectedButtonAction;
    NSMutableDictionary *dictDetailPage;
    UIBarButtonItem *btnFilter;
    UIBarButtonItem *btnSearch;

}

@end

@implementation ExploredetailViewController

-(void)resetButton
{
    
    [_btnFoods setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_btnThings setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_btnDeals setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    self.lastContentOffsetXval = scrollView.contentOffset.x;
    self.lastContentOffsetYval = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    if (self.lastContentOffsetXval < _scrollView.contentOffset.x || self.lastContentOffsetXval > _scrollView.contentOffset.x)
    {
        CGFloat pageWidth = _scrollView.frame.size.width;
        float xVal = _scrollView.contentOffset.x;
        [self resetButton];
        
        if(xVal  == 0)
        {
            NSLog(@"Things");
            btnFilter.enabled=true;
            btnSearch.enabled=true;
            _selectionID = SELECTION_THINGS;
            selectedButtonAction = Things_Active;
            
            [_btnThings setImage:[UIImage imageNamed:@"Thingstodothirdpageselect.png"] forState:UIControlStateNormal];
            [_btnFoods setImage:[UIImage imageNamed:@"secondfood.png"] forState:UIControlStateNormal];
            [_btnDeals setImage:[UIImage imageNamed:@"secondspecial.png"] forState:UIControlStateNormal];
            
            showProgress(YES);
            [self performSelector:@selector(fetchData) withObject:nil afterDelay:0.2f];
        }
        else if(xVal == pageWidth)
        {
            NSLog(@"Foods");
            btnFilter.enabled=true;
            btnSearch.enabled=true;
            _selectionID = SELECTION_FOOD;
            selectedButtonAction = Food_Active;
            
            [_btnThings setImage:[UIImage imageNamed:@"secondthings.png"] forState:UIControlStateNormal];
            [_btnFoods setImage:[UIImage imageNamed:@"foodanddrinks.png"] forState:UIControlStateNormal];
            [_btnDeals setImage:[UIImage imageNamed:@"secondspecial.png"] forState:UIControlStateNormal];
            
            showProgress(YES);
            [self performSelector:@selector(fetchData) withObject:nil afterDelay:0.2f];
        }
        else if(xVal == pageWidth * 2)
        {
            NSLog(@"Deals");
            btnFilter.enabled=false;
            btnSearch.enabled=false;
            selectedButtonAction = Special_Deals_Active;
            
            [_btnThings setImage:[UIImage imageNamed:@"secondthings.png"] forState:UIControlStateNormal];
            [_btnFoods setImage:[UIImage imageNamed:@"secondthings.png"] forState:UIControlStateNormal];
            [_btnDeals setImage:[UIImage imageNamed:@"specialdeals.png"] forState:UIControlStateNormal];
            
            showProgress(YES);
            [self performSelector:@selector(fetchData) withObject:nil afterDelay:0.2f];
            
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Scroll View
    scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.tabView.frame.size.height, self.view.frame.size.width, self.viewThings.frame.size.height)];
    scroll.backgroundColor=[UIColor clearColor];
    scroll.delegate=self;
    scroll.pagingEnabled=YES;
    scroll.directionalLockEnabled = YES;
    scroll.alwaysBounceVertical = NO;
    scroll.alwaysBounceHorizontal = YES;
    [scroll setContentSize:CGSizeMake(scroll.frame.size.width*3, scroll.frame.size.height)];
    

    CGFloat x=0;
    for(int i=1;i<4;i++)
    {
        if (i == 1)
        {
            self.viewThings.frame =CGRectMake(x+0, 0, self.view.frame.size.width, self.view.frame.size.height-self.tabView.frame.size.height);
            [scroll addSubview:self.viewThings];
        }
        if (i ==2)
        {
            self.viewFood.frame =CGRectMake(x+0, 0, self.view.frame.size.width, self.view.frame.size.height-self.tabView.frame.size.height);
            [scroll addSubview:self.viewFood];
        }
        if (i ==3)
        {
            self.viewDeals.frame =CGRectMake(x+0, 0, self.view.frame.size.width, self.view.frame.size.height-self.tabView.frame.size.height);
            [scroll addSubview:self.viewDeals];
        }
        x+=self.view.frame.size.width;
    }
    [self.view addSubview:scroll];
   
    //Table Datas//
    
    _tableThings.tableFooterView = [[UIView alloc] init];
    _tableFoods.tableFooterView = [[UIView alloc] init];
    _tablenewDeals.tableFooterView = [[UIView alloc] init];
    
    selectedButtonAction = Things_Active;
    [_btnThings setImage:[UIImage imageNamed:@"Thingstodothirdpageselect.png"] forState:UIControlStateNormal];
    [_btnFoods setImage:[UIImage imageNamed:@"secondfood.png"] forState:UIControlStateNormal];
    [_btnDeals setImage:[UIImage imageNamed:@"secondspecial.png"] forState:UIControlStateNormal];

    dictDetailPage = [[NSMutableDictionary alloc] init];
    dataArray = [NSMutableArray array];
    originalData= [NSMutableArray array];
    activityArray = [[NSMutableArray alloc] init];
    checkedActivities = [[NSMutableArray alloc] init];
    checkedStarValues = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5", nil];
    
    showProgress(YES);
    [self performSelector:@selector(fetchData) withObject:nil afterDelay:0.2f];

    [_tableFoods registerNib:[UINib nibWithNibName:@"FoodNewTableViewCell" bundle:nil] forCellReuseIdentifier:@"FoodNewTableViewCell"];
    [_tablenewDeals registerNib:[UINib nibWithNibName:@"NewDealsTableViewCell" bundle:nil] forCellReuseIdentifier:@"NewDealsTableViewCell"];
    [_tableThings registerNib:[UINib nibWithNibName:@"ThingstoDoTableViewCell" bundle:nil] forCellReuseIdentifier:@"ThingstoDoTableViewCell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyFilter:) name:@"ApplyFilter" object:nil];
    
    
    //Header//
    
    btnFilter = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"filter.png"] style:UIBarButtonItemStylePlain target:self action:@selector(actionFilter:)];
    btnSearch = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Search Icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(actionSearch:)];
    
    NSArray *barArray = [[NSArray alloc] initWithObjects:btnFilter, btnSearch, nil];
    self.navigationItem.rightBarButtonItems = barArray;
    
    UIView *viewForNavigationBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [viewForNavigationBar setBackgroundColor:[UIColor clearColor]];
    
    UILabel *lblLogo = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-130, 0, 100, 23)];
    lblLogo.text = [_selectedCityDictionary objectForKey:@"city"];
    lblLogo.textColor = [UIColor whiteColor];
    [viewForNavigationBar addSubview:lblLogo];
    [lblLogo setFont:[UIFont systemFontOfSize:18]];
    lblLogo.textAlignment = NSTextAlignmentCenter;
    
    UILabel *lblLogo1 = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-130, 23, 100, 23)];
    lblLogo1.text = [_selectedCityDictionary objectForKey:@"country"];
    lblLogo1.textColor = [UIColor whiteColor];
    [lblLogo1 setFont:[UIFont systemFontOfSize:14]];
    lblLogo1.textAlignment = NSTextAlignmentCenter;
    [viewForNavigationBar addSubview:lblLogo1];
    
    self.navigationItem.titleView = viewForNavigationBar;

}

- (void) applyFilter:(NSNotification *) notification
{
    [_tableThings reloadData];
    [_tableFoods reloadData];
}


-(void)prepareCategory
{
    NSString *selectionTitle;
    if(self.selectionID == SELECTION_FOOD)
    {
        selectionTitle = @"Food";
    }else if(self.selectionID == SELECTION_PRAYER)
    {
        selectionTitle = @"Prayer";
    }else if(self.selectionID == SELECTION_NEIGHBOURHOOD)
    {
        selectionTitle = @"Neighbourhood";
    }else if(self.selectionID == SELECTION_THINGS)
    {
        selectionTitle = @"Things to do";
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)fetchData
{
    NSString *urlString;
    NSString *parameter;
    
    if(_isSearcSeoulActive == YES)
    {
        urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/search.php"];
        parameter = [NSString stringWithFormat:@"searchvalue=%@&cityid=%@",_getSearchSeoulText,_cityID];
    }
    else
    {
        if([_getDistrict length] > 0)
        {
            urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/get_category_value_bydistrict.php"];
            parameter = [NSString stringWithFormat:@"cid=%d&district=%@&cityid=%@",_selectionID,_getDistrict,_cityID];
        }
            else if (selectedButtonAction == Special_Deals_Active)
            {
                urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/tourcontent.php"];
                parameter = [NSString stringWithFormat:@"id=%@",[_selectedCityDictionary objectForKey:@"sno"]];

            }
        else
        {
            urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/get_category_value_new.php"];
            parameter = [NSString stringWithFormat:@"cid=%d&cityid=%@",_selectionID,_cityID];
        }
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
    [dataArray removeAllObjects];
    [originalData removeAllObjects];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:mutableData options: NSJSONReadingMutableContainers error: nil];
     if(selectedButtonAction == Special_Deals_Active)
    {
        if([[jsonDict objectForKey:@"success"] integerValue] == 1)
        {
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
                [_tablenewDeals reloadData];
            }
        }
    }
    else
    {
    
         if([[jsonDict objectForKey:@"Status"] integerValue] == 1)
         {
             _lblEmptyData.hidden = YES;
             dataArray = [NSMutableArray arrayWithArray:[jsonDict objectForKey:@"categorylistvalues"]];
             originalData = [NSMutableArray arrayWithArray:[jsonDict objectForKey:@"categorylistvalues"]];
             [activityArray removeAllObjects];
             [checkedActivities removeAllObjects];
             for (NSDictionary *dict in originalData) {
                 if (![activityArray containsObject:dict[@"activity"]])
                 {
                     [activityArray addObject:dict[@"activity"]];
                 }
             }
             [checkedActivities addObjectsFromArray:activityArray];
             
             if ([_toReviewPage isEqualToString:@"YES"])
             {
                 //[self performSelector:@selector(popAlert) withObject:nil afterDelay:0.5];
             }
             
         }
         else
         {
             _lblEmptyData.text = [jsonDict objectForKey:@"msg"];
             _lblEmptyData.hidden = NO;
         }
         if (_selectionID == SELECTION_THINGS)
         {
             [_tableThings reloadData];
         }
         else if (_selectionID == SELECTION_FOOD)
         {
             [_tableFoods reloadData];
         }
         
     }
     showProgress(NO);
}



#pragma mark - TableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _tableThings)
    {
        return dataArray.count;
    }
    else if (tableView == _tableFoods)
    {
        return dataArray.count;
    }
    else{
        return dataArray3.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (tableView == _tableThings)
    {
        

            ThingstoDoTableViewCell *cell = [_tableThings dequeueReusableCellWithIdentifier:@"ThingstoDoTableViewCell" forIndexPath:indexPath];
            [cell setDataList:[dataArray objectAtIndex:indexPath.row] index:indexPath];
        
            
            return cell;
            

       
    }
    else if (tableView == _tableFoods)
    {
        FoodNewTableViewCell *cell2 = [_tableFoods dequeueReusableCellWithIdentifier:@"FoodNewTableViewCell" forIndexPath:indexPath];
        
        NSDictionary *dictFood = dataArray[indexPath.row];
        
        NSArray *photosArray = (NSArray *)[dictFood objectForKey:@"photos"];
        NSString *imgURL;
        if(photosArray.count == 0)
            imgURL = @"";
        else
            imgURL = [[photosArray objectAtIndex:0] valueForKey:@"photourl"];
        
        cell2.activityIndicator.hidden = NO;
        [cell2.activityIndicator startAnimating];
        [cell2.imageViewPhoto sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"placeHolder.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            cell2.activityIndicator.hidden = YES;
            [cell2.activityIndicator stopAnimating];
        }];
        cell2.lbtTitle.text = [dictFood objectForKey:@"name"];
        cell2.lblCountry.text = [dictFood objectForKey:@"foodttags"];
        cell2.lblRatingLabel.text = [dictFood objectForKey:@"rating"];
        cell2.lblDetail.text = [dictFood objectForKey:@"foodctags"];
        cell2.starRating.canEdit = NO;
        cell2.starRating.maxRating = 5;
        cell2.starRating.rating = [[dictFood objectForKey:@"weight"] floatValue];
        
        NSString *toursNumber =[NSString stringWithFormat:@"%@",[dictFood objectForKey:@"tours"]];
        if (![toursNumber isEqualToString:@"0"])
        {
            if (![toursNumber isEqualToString:@"1"])
            {
                cell2.specialDealsImage.hidden = FALSE;
                cell2.specialDealsLabel.hidden = FALSE;
                cell2.specialDealsLabel.text = [NSString stringWithFormat:@"%@ Special Deals Available >", [dictFood objectForKey:@"tours"]];
            }
            else
            {
                cell2.specialDealsImage.hidden = FALSE;
                cell2.specialDealsLabel.hidden = FALSE;
                cell2.specialDealsLabel.text = [NSString stringWithFormat:@"%@ Special Deal Available >", [dictFood objectForKey:@"tours"]];
            }
        }
        else
        {
            cell2.specialDealsImage.hidden = TRUE;
            cell2.specialDealsLabel.hidden = TRUE;
        }
        return cell2;
    }
    else
    {
        NewDealsTableViewCell *cell3 = (NewDealsTableViewCell *)[_tablenewDeals dequeueReusableCellWithIdentifier:@"NewDealsTableViewCell" forIndexPath:indexPath];
        TourDetailModel *getData = [dataArray3 objectAtIndex:indexPath.row];
        [cell3 setDataListTour:getData index:indexPath];
        return cell3;

    }
    return nil;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _tablenewDeals)
    {
        
        TourDetailModel *getData = [dataArray3 objectAtIndex:indexPath.row];
        TourDetail2 *dis = [self.storyboard instantiateViewControllerWithIdentifier:TOURS_DETAIL2_STORYBOARD_ID];
        dis.selectedTour = getData;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
            [self showViewController:dis sender:nil];
        }else{
            [self.navigationController pushViewController:dis animated:YES];
        }
    }
    else
    {
    dictDetailPage = dataArray[indexPath.row];
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    DetailTableViewController *detail = [story instantiateViewControllerWithIdentifier:@"DetailTableViewController"];
    detail.selectedCityDict = _selectedCityDictionary;
    detail.dictDetails = dictDetailPage;
    [self.navigationController pushViewController:detail animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableThings)
    {
        if ([[dataArray[indexPath.row] objectForKey:@"tours" ] integerValue] > 0)
        {
            return 170;
        }
        else
        {
            return 130;
        }
    }
    else if (tableView == _tableFoods)
    {
        if ([[dataArray[indexPath.row] objectForKey:@"tours" ] integerValue] > 0)
        {
            return 150;
        }
        else
        {
            return 120;
        }
        
    }
    else if (tableView == _tablenewDeals)
        return 130;
    
    return 0;
}




#pragma mark - Actions

- (IBAction)actionThings:(id)sender
{
    [self resetButton];
    [scroll setContentOffset:CGPointMake(0, 0) animated:YES];
    
    btnFilter.enabled=true;
    btnSearch.enabled=true;
    _selectionID = SELECTION_THINGS;
    selectedButtonAction = Things_Active;
    
    [_btnThings setImage:[UIImage imageNamed:@"Thingstodothirdpageselect.png"] forState:UIControlStateNormal];
    [_btnFoods setImage:[UIImage imageNamed:@"secondfood.png"] forState:UIControlStateNormal];
    [_btnDeals setImage:[UIImage imageNamed:@"secondspecial.png"] forState:UIControlStateNormal];
    
    showProgress(YES);
    [self performSelector:@selector(fetchData) withObject:nil afterDelay:0.2f];
}
- (IBAction)actionFoods:(id)sender
{
    [self resetButton];
    float screenWidth = [[UIScreen mainScreen] bounds].size.width;
    [scroll setContentOffset:CGPointMake(screenWidth, 0) animated:YES];
    
    btnFilter.enabled=true;
    btnSearch.enabled=true;
    _selectionID = SELECTION_FOOD;
    selectedButtonAction = Food_Active;
    
    [_btnThings setImage:[UIImage imageNamed:@"secondthings.png"] forState:UIControlStateNormal];
    [_btnFoods setImage:[UIImage imageNamed:@"foodanddrinks.png"] forState:UIControlStateNormal];
    [_btnDeals setImage:[UIImage imageNamed:@"secondspecial.png"] forState:UIControlStateNormal];
    
    showProgress(YES);
    [self performSelector:@selector(fetchData) withObject:nil afterDelay:0.2f];
}
- (IBAction)actionDeals:(id)sender
{
    [self resetButton];
    float screenWidth = [[UIScreen mainScreen] bounds].size.width;
    [scroll setContentOffset:CGPointMake(screenWidth * 2, 0) animated:YES];
    
    btnFilter.enabled=false;
    btnSearch.enabled=false;
    selectedButtonAction = Special_Deals_Active;
    
    [_btnThings setImage:[UIImage imageNamed:@"secondthings.png"] forState:UIControlStateNormal];
    [_btnFoods setImage:[UIImage imageNamed:@"secondthings.png"] forState:UIControlStateNormal];
    [_btnDeals setImage:[UIImage imageNamed:@"specialdeals.png"] forState:UIControlStateNormal];
    
    showProgress(YES);
    [self performSelector:@selector(fetchData) withObject:nil afterDelay:0.2f];
}

- (IBAction)actionFilter:(id)sender
{
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    NewFilterViewController *filter = [story instantiateViewControllerWithIdentifier:@"NewFilterViewController"];
    filter.selectedIndex = selectedButtonAction;
    filter.selectedCityDictionary = _selectedCityDictionary;
    filter.selectionID =_selectionID;
    filter.cityID = _cityID;
    [self.navigationController pushViewController:filter animated:YES];
}


- (IBAction)actionSearch:(id)sender
{
    
}


@end
