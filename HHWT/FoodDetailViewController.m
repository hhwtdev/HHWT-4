//
//  FoodDetailViewController.m
//  HHWT
//
//  Created by sampath kumar on 05/02/16.
//  Copyright (c) 2016 Sam Software. All rights reserved.
//

#import "FoodDetailViewController.h"
#import "FoodDetailCollectionViewCell.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "ASStarRatingView.h"
#import "AddTripViewController.h"
#import "ExploredetailViewController.h"
#import "MyTripsViewController.h"
#import "CommentsTableViewCell.h"
#import "LocationViewController.h"

@interface FoodDetailViewController ()<UITextFieldDelegate, UIAlertViewDelegate>
{
    NSMutableData *mutableData,*mutableData1;
    double latitude;
    double longitude;
    NSMutableArray *dataArray;
    NSArray *photosArray;
    NSString *elementID;
    NSArray *nearByDataArray;
    NSDictionary *dic;
    NSMutableArray *commentsArray;
    NSURLConnection *insertCommentsConnection;
    NSURLConnection *viewCommentsConnection;

}

@end

@implementation FoodDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    for (NSLayoutConstraint *constraints in _heights) {
        constraints.constant = 0;
        [self.view needsUpdateConstraints];
    }
    
    
    commentsArray = [[NSMutableArray alloc]init];
    _contraintFoodViewHeight.constant = 0.0f;
    _viewFood.hidden = YES;
//    if(_selectionType == SELECTION_FOOD){
//        _viewFood.hidden = NO;
//        _lblInfo.text = @"Restaurant info";
//        _imgInfo.image = [UIImage imageNamed:@"food.png"];
//        _contraintFoodViewHeight.constant = 76.0f;
//    }
//    else if(_selectionType == SELECTION_PRAYER){
//        _lblInfo.text = @"Prayers info";
//        _imgInfo.image = [UIImage imageNamed:@"prayers.png"];
//    }
//    else if(_selectionType == SELECTION_THINGS){
//        _lblInfo.text = @"Attraction info";
//        _imgInfo.image = [UIImage imageNamed:@"things.png"];
//    }
//    else if(_selectionType == SELECTION_NEIGHBOURHOOD){
//        _lblInfo.text = @"Information";
//        _imgInfo.image = [UIImage imageNamed:@"neighbourhood.png"];
//    }
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(self.view.frame.size.width-18, 184);
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    [self.collectionView setPagingEnabled:YES];
    [self.collectionView setCollectionViewLayout:flowLayout];
    self.pageControl.numberOfPages = 4.0f;
    dataArray = [NSMutableArray array];
    nearByDataArray = [NSArray array];
    
    self.mapView.layer.borderWidth = 1.5f;
    self.mapView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
    showProgress(YES);
    [self performSelector:@selector(fetchData) withObject:nil afterDelay:0.2f];
    
    [self performSelector:@selector(fetchComments) withObject:nil afterDelay:1.0f];

}

-(void)fetchComments
{
    showProgress(YES);
    NSString *urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/viewcomments.php"];
    NSString *appendMessage = [NSString stringWithFormat:@"dataelement=%d",_selectionID];
    NSString *parameter;
    parameter = [NSString stringWithFormat:@"%@",appendMessage];
    NSData *parameterData = [parameter dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    [theRequest addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:parameterData];
    viewCommentsConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if(viewCommentsConnection)
    {
        mutableData1 = [[NSMutableData alloc] init];
    }
}

-(IBAction)addComments:(id)sender;
{
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"HHWT" message:@"Please enter your review" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    [av textFieldAtIndex:0].delegate = self;
    [av show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if([alertView.message isEqualToString:@"Please enter your review"])
    {
        if (buttonIndex == 1) {
            NSString *getComments= [alertView textFieldAtIndex:0].text;
            if ([getComments length]>0)
            {
                showProgress(YES);
                NSString *urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/insertcomments.php"];
                NSString *appendMessage = [NSString stringWithFormat:@"dataelement=%d&fbid=%@&name=%@&comments=%@",_selectionID,[[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"],[[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"],getComments];
                NSString *parameter;
                parameter = [NSString stringWithFormat:@"%@",appendMessage];
                NSData *parameterData = [parameter dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
                NSURL *url = [NSURL URLWithString:urlString];
                NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
                [theRequest addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
                [theRequest setHTTPMethod:@"POST"];
                [theRequest setHTTPBody:parameterData];
                insertCommentsConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
                if( insertCommentsConnection )
                {
                    mutableData1 = [[NSMutableData alloc] init];
                }
 
            }
        }
    }else if([alertView.message isEqualToString:@"Successfully added your review"]) {
        if (buttonIndex == 0) {
            [self performSelector:@selector(fetchComments) withObject:nil afterDelay:0.0];

        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [commentsArray count] > 0 ? [commentsArray count] : 1.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"commentsCell";
    
    CommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[CommentsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:MyIdentifier];
    }
    
    if([commentsArray count] == 0)
    {
        cell.lblComments.text = @"No data available";
        cell.lblComments.textAlignment = NSTextAlignmentCenter;
    }else{
        cell.lblComments.textAlignment = NSTextAlignmentLeft;
        cell.lblName.textAlignment = NSTextAlignmentLeft;
        cell.lblName.text =  [NSString stringWithFormat:@"Name: %@",[[commentsArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
        cell.lblComments.text = [[commentsArray objectAtIndex:indexPath.row] objectForKey:@"comments"];   
    }
    return cell;
}


- (IBAction)loadMap:(id)sender {
    NSString* url = [NSString stringWithFormat:@"http://maps.apple.com/?ll=%f,%f",latitude, longitude];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:url]];
}

- (IBAction)webLink:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[dic objectForKey:@"website"]]];
}

-(void)fetchData
{
    NSString *urlString;
    NSString *parameter;
    
    if([_getDistrict length] > 0)
    {
        urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/get_category_value_bydistrict.php"];
        parameter = [NSString stringWithFormat:@"cid=%d&district=%@",_selectionID,_getDistrict];
    }
    else
    {
        urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/get_nearby_elements.php"];
        parameter = [NSString stringWithFormat:@"did=%d",_selectionID];
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
    if([connection isEqual:insertCommentsConnection] || [connection isEqual:viewCommentsConnection])
    {
        [mutableData1 setLength:0];

    }else{
        [mutableData setLength:0];
  
    }
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if([connection isEqual:insertCommentsConnection] || [connection isEqual:viewCommentsConnection])
    {
        [mutableData1 appendData:data];

    }else{
        [mutableData appendData:data];
  
    }
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    showProgress(NO);
     [[[UIAlertView alloc] initWithTitle:@"Error" message:ERROR_MSG delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
    return;
}

-(BOOL)isEmpty:(id)thing {
    return thing == nil || [(NSString *)thing isKindOfClass:[NSNull class]] || ([thing respondsToSelector:@selector(length)] && [(NSData *)thing length] == 0) || ([thing respondsToSelector:@selector(count)] && [(NSArray *)thing count] == 0);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if([connection isEqual:insertCommentsConnection])
    {
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:mutableData1 options: NSJSONReadingMutableContainers error: nil];

        if([[jsonDict objectForKey:@"status"] integerValue] == 1)
        {
            [[[UIAlertView alloc] initWithTitle:@"HHWT" message:@"Successfully added your comments" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        }
        showProgress(NO);
    }else if([connection isEqual:viewCommentsConnection])
    {
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:mutableData1 options: NSJSONReadingMutableContainers error: nil];
        if([self isEmpty:[jsonDict objectForKey:@"msg"]])
        {
            
        }else{
            [commentsArray removeAllObjects];
            NSArray *arr = [jsonDict objectForKey:@"msg"];
            if(arr.count >0)
            {
                commentsArray = [NSMutableArray arrayWithArray:arr];
            }
        }
       
        [_commentsTable reloadData];
        showProgress(NO);
    }
    else
    {
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:mutableData options: NSJSONReadingMutableContainers error: nil];

        if([[jsonDict objectForKey:@"Status"] integerValue] == 1)
        {
            nearByDataArray = [jsonDict objectForKey:@"nearbyelements"];
            
            dataArray = [NSMutableArray arrayWithArray:[jsonDict objectForKey:@"categorylistvalues"]];
            dic = [dataArray objectAtIndex:0];
            photosArray = (NSArray *)[dic objectForKey:@"photos"];
            elementID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sno"]];
            _lblOpen.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"openhrs"]];
            _lblClose.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"closehrs"]];
            
            self.pageControl.numberOfPages = photosArray.count;
            [self setupData:dic];
            [_collectionView reloadData];
        }else{
            showProgress(NO);
        }
    }
}

-(void)setupData:(NSDictionary *)dic1
{
    self.lblCountry.text = [[dic1 objectForKey:@"name"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    self.lblAddres1.text = [[dic1 objectForKey:@"address"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.lblAddress2.text = [[dic1 objectForKey:@"state"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.lblPhNo.text = [[dic1 objectForKey:@"phone"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.lblWeb.text = [[dic1 objectForKey:@"website"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.lblDesc.text = [[dic1 objectForKey:@"description"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(self.lblWeb.text.length == 0)
    {
        self.lblWeb.text = @"Link not available";
  
    }else{
        NSMutableAttributedString *yourString = [[NSMutableAttributedString alloc] initWithString:self.lblWeb.text];
        [yourString addAttribute:NSUnderlineStyleAttributeName
                           value:[NSNumber numberWithInt:1]
                           range:(NSRange){0,self.lblWeb.text.length}];
        self.lblWeb.attributedText = [yourString copy];
    }
    
    //self.imgReviewer.image = [dic objectForKey:@"country"];
    //self.lblReviewerName.text = [dic objectForKey:@"country"];
        
    self.starRatings.canEdit = NO;
    self.starRatings.maxRating = 5;
    self.starRatings2.canEdit = NO;
    self.starRatings2.maxRating = 5;
    self.starRatings.rating = [[dic1 objectForKey:@"weight"] floatValue];
    self.starRatings2.rating = [[dic1 objectForKey:@"weight"] floatValue];
    latitude = [[dic1 objectForKey:@"latitude"] doubleValue];
    longitude = [[dic1 objectForKey:@"longitude"] doubleValue];
    
    if(nearByDataArray.count == 0)
    {
        _lblFoodCount.text = [NSString stringWithFormat:@"(0)"];
        _lblPrayerCount.text = [NSString stringWithFormat:@"(0)"];
        _lblThingsCount.text = [NSString stringWithFormat:@"(0)"];
    }
    
    for(NSDictionary *dic2  in nearByDataArray)
    {
        if([[dic2 objectForKey:@"categoryid"] integerValue] == 1)
        {
            _lblFoodCount.text = [NSString stringWithFormat:@"(%ld)",(long)[[dic2 objectForKey:@"totalno"] integerValue]];
        }else if([[dic2 objectForKey:@"categoryid"] integerValue] == 2)
        {
            _lblPrayerCount.text = [NSString stringWithFormat:@"(%ld)",(long)[[dic2 objectForKey:@"totalno"] integerValue]];

        }else if([[dic2 objectForKey:@"categoryid"] integerValue] == 3)
        {
            _lblThingsCount.text = [NSString stringWithFormat:@"(%ld)",(long)[[dic2 objectForKey:@"totalno"] integerValue]];
        }else if([[dic2 objectForKey:@"categoryid"] integerValue] == 4)
        {
        }
    }
    
     if(_selectionType == SELECTION_FOOD1){
         NSArray *arr1 = [[dic objectForKey:@"foodtype"] valueForKey:@"foodtypevalues"];
         NSArray *arr2 = [[dic objectForKey:@"foodclassification"] valueForKey:@"foodclassificationvalues"];
         
         
         NSString *appendStr = [arr1 componentsJoinedByString:@", "];
         appendStr = [appendStr stringByAppendingString:[NSString stringWithFormat:@", %@",[arr2 componentsJoinedByString:@", "]]];

        _lblFoodType.text = [dic1 objectForKey:@"timeremaining"];
         
         if(arr2 != nil & arr2.count > 0)
             _lblFoodClassifi.text = appendStr;
     }
    
    
    
    MKCoordinateRegion region;
    CLLocation *locObj = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(latitude , longitude)
                                                       altitude:0
                                             horizontalAccuracy:0
                                               verticalAccuracy:0
                                                      timestamp:[NSDate date]];
    region.center = locObj.coordinate;
    MKCoordinateSpan span;
    span.latitudeDelta  = 1; 
    span.longitudeDelta = 1;
    region.span = span;
    [self.mapView setRegion:region animated:YES];
    
    MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc] init];
    myAnnotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    myAnnotation.title = [dic objectForKey:@"address"];
    [self.mapView addAnnotation:myAnnotation];
    showProgress(NO);
}

#pragma mark - UICollectionViewDataSource methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return photosArray.count == 0 ? 1 : photosArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FoodDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"foodCell" forIndexPath:indexPath];
    
    NSString *imgURL;
    if(photosArray.count>0)
       // imgURL= [[photosArray objectAtIndex:indexPath.row] valueForKey:@"photourl"];
         imgURL= [[photosArray objectAtIndex:indexPath.row] valueForKey:@"bigurl"];
    else
        imgURL = @"";
    
    
    cell.loadingIndi.hidden = NO;
    [cell.loadingIndi startAnimating];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"placeHolder.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        cell.loadingIndi.hidden = YES;
        [cell.loadingIndi stopAnimating];
    }];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *imgURL;
    if(photosArray.count>0)
        imgURL= [[photosArray objectAtIndex:indexPath.row] valueForKey:@"crediturl"];
    else
        imgURL = @"";
    
    if([imgURL length] > 0)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:imgURL]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.collectionView.frame.size.width;
    self.pageControl.currentPage = self.collectionView.contentOffset.x / pageWidth;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)mapAction:(id)sender
{
    NSLog(@"Data %@",_selectedLocationDict);
    NSLog(@"getTripDic %@",_getTripDic);
    NSLog(@"selectionType %d",_selectionID);
    
    LocationViewController *exp = [self.storyboard instantiateViewControllerWithIdentifier:LOCATION_STORYBOARD_ID];
    exp.getData = [[NSMutableArray alloc] initWithObjects:_selectedLocationDict, nil];
    exp.getTripDic =_getTripDic;
    exp.selectionType = _selectionID;
    
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
        [self showViewController:exp sender:nil];
    }else{
        [self.navigationController pushViewController:exp animated:YES];
    }
}


- (IBAction)foodAction:(id)sender {
    if([[[nearByDataArray objectAtIndex:0] objectForKey:@"totalno"] intValue] > 0)
    {
        NSDictionary *dic3 = [nearByDataArray objectAtIndex:0];
        showProgress(YES);
         ExploredetailViewController*fd = [self.storyboard instantiateViewControllerWithIdentifier:FoodViewController_STORYBOARD_ID];
        fd.selectionID = SELECTION_FOOD;
        fd.getDistrict = [dic3 objectForKey:@"district"];
        fd.getTripDic = _getTripDic;
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
            [self showViewController:fd sender:nil];
        }else{
            [self.navigationController pushViewController:fd animated:YES];
        }
        showProgress(NO);
    }
}

- (IBAction)prayerAction:(id)sender {
    if([[[nearByDataArray objectAtIndex:1] objectForKey:@"totalno"] intValue] > 0)
    {
        NSDictionary *dic3 = [nearByDataArray objectAtIndex:1];
        showProgress(YES);
        FoodViewController *fd = [self.storyboard instantiateViewControllerWithIdentifier:FoodViewController_STORYBOARD_ID];
        fd.selectionID = SELECTION_PRAYER;
        fd.getDistrict = [dic3 objectForKey:@"district"];
        fd.getTripDic = _getTripDic;

        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
            [self showViewController:fd sender:nil];
        }else{
            [self.navigationController pushViewController:fd animated:YES];
        }
        showProgress(NO);
    }
}
- (IBAction)thingsAction:(id)sender {
    if([[[nearByDataArray objectAtIndex:2] objectForKey:@"totalno"] intValue] > 0)
    {
        NSDictionary *dic3 = [nearByDataArray objectAtIndex:2];
        showProgress(YES);
        FoodViewController *fd = [self.storyboard instantiateViewControllerWithIdentifier:FoodViewController_STORYBOARD_ID];
        fd.selectionID = SELECTION_THINGS;
        fd.getDistrict = [dic3 objectForKey:@"district"];
        fd.getTripDic = _getTripDic;

        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
            [self showViewController:fd sender:nil];
        }else{
            [self.navigationController pushViewController:fd animated:YES];
        }
        showProgress(NO);
    }
}

- (IBAction)saveAction:(id)sender
{
    if(_getTripDic)
    {
        AddTripViewController *fd = [self.storyboard instantiateViewControllerWithIdentifier:ADD_TRIP_STORYBOARD_ID];
        fd.getTripDic = _getTripDic;
        fd.elementID = elementID;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8"))
        {
            [self showViewController:fd sender:nil];
        }
        else
        {
            [self.navigationController pushViewController:fd animated:YES];
        }
    }
    else
    {
        //Explore active here
        MyTripsViewController *fd = [self.storyboard instantiateViewControllerWithIdentifier:MY_TRIP_SUMMARY_STORYBOARD_ID];
        fd.elementID = elementID;
        fd.isExploreActive = YES;
        fd.cityID = _cityID;
        fd.selectedCityDictionary = _selectedCityDictionary;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
            [self showViewController:fd sender:nil];
        }else{
            [self.navigationController pushViewController:fd animated:YES];
        }
    }
}

- (IBAction)callAction:(id)sender{
    NSDictionary *dic3 = [dataArray objectAtIndex:0];
    NSString *phoneNumber = [dic3 objectForKey:@"phone"];
    NSString *phoneURLString = [NSString stringWithFormat:@"tel:%@", phoneNumber];
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:phoneURLString]])
    {
        NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
        [[UIApplication sharedApplication] openURL:phoneURL];
    }else
    {
        UIAlertView *warning =[[UIAlertView alloc] initWithTitle:@"Note" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [warning show];
    }
}
@end
