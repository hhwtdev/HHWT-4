//
//  DetailTableViewController.m
//  HHWT
//
//  Created by Priya on 09/11/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import "DetailTableViewController.h"
#import "UIImageView+WebCache.h"
#import "ASStarRatingView.h"
#import "NewDealsTableViewCell.h"

@interface DetailTableViewController ()
{
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    NSMutableArray *arrSpecialDeals;
    NSMutableData *mutableData;
}

@end

@implementation DetailTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = [_dictDetails objectForKey:@"name"];
    arrSpecialDeals = [[NSMutableArray alloc] init];
    arrSpecialDeals = [_dictDetails objectForKey:@"tourdetails"];
    
    showProgress(YES);
    self.attractionsArr = [[NSMutableArray alloc] init];
    self.foodPlacesArr = [[NSMutableArray alloc] init];
    self.prayerSpacesArr = [[NSMutableArray alloc] init];
    self.datasIdStr =@"3";
    [self fetchDatas:self.datasIdStr];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"NewDealsTableViewCell" bundle:nil] forCellReuseIdentifier:@"NewDealsTableViewCell"];
}


-(void)fetchDatas :(NSString *)cidStr
{
    NSString *urlString = @"";
    NSString *parameter = @"";
    
    urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/get_category_value_bydistrict.php"];
    parameter = [NSString stringWithFormat:@"cid=%@&district=%@",cidStr,[_dictDetails objectForKey:@"district"]];
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
    [[[UIAlertView alloc] initWithTitle:@"Error" message:ERROR_MSG delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
    return;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if ([self.datasIdStr isEqualToString:@"3"])
    {
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:mutableData options: NSJSONReadingMutableContainers error: nil];
        
        self.attractionsArr =[jsonDict valueForKey:@"categorylistvalues"];
        if (self.attractionsArr.count ==0)
        {
            NSLog(@"No Attractions");
        }
        else
        {
            NSLog(@"Available Attractions %lu",(unsigned long)self.attractionsArr.count);
        }
        self.datasIdStr =@"1";
        [self fetchDatas:self.datasIdStr];
    }
    else if ([self.datasIdStr isEqualToString:@"1"])
    {
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:mutableData options: NSJSONReadingMutableContainers error: nil];
        self.foodPlacesArr =[jsonDict valueForKey:@"categorylistvalues"];
        if (self.foodPlacesArr.count ==0)
        {
            NSLog(@"No FoodPlaces");
        }
        else
        {
            NSLog(@"Available FoodPlaces %lu",(unsigned long)self.foodPlacesArr.count);
        }
        self.datasIdStr =@"2";
        [self fetchDatas:self.datasIdStr];
    }
    else if ([self.datasIdStr isEqualToString:@"2"])
    {
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:mutableData options: NSJSONReadingMutableContainers error: nil];
        self.prayerSpacesArr =[jsonDict valueForKey:@"categorylistvalues"];
        if (self.prayerSpacesArr.count ==0)
        {
            NSLog(@"No PrayerSpaces");
        }
        else
        {
            NSLog(@"Available PrayerSpaces %lu",(unsigned long)self.prayerSpacesArr.count);
        }
        [self.tableView reloadData];
        showProgress(NO);
        self.datasIdStr =@"";
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 14;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 3;
    }
    else if (section == 1)
    {
        return 1;
    }
    else if (section == 2)
    {
        if (arrSpecialDeals.count == 0)
        {
            return 0;
        }
        else
        {
            if (arrSpecialDeals.count >= 2)
            {
                return 2;
            }
            else
            {
                return arrSpecialDeals.count;
            }
        }
    }
    else if (section == 3)
    {
        if (arrSpecialDeals.count == 0 || arrSpecialDeals.count < 2)
        {
            return 0;
        }
        else
        {
            return 1;
        }
    }
    else if (section == 4)
    {
        return 1;
    }
    else if (section == 5)
    {
        if (self.attractionsArr.count ==0)
        {
            return 0;
        }
        else if (self.attractionsArr.count >=2)
        {
            return 2;
        }
        else
        {
            return self.attractionsArr.count;
        }
        
    }
    else if (section == 6)
    {
        if (self.attractionsArr.count ==0 || self.attractionsArr.count <2)
        {
            return 0;
        }
        else if (self.attractionsArr.count >=2)
        {
            return 1;
        }
    }
    else if (section == 7)
    {
        if (self.foodPlacesArr.count ==0)
        {
            return 0;
        }
        else if (self.foodPlacesArr.count >=2)
        {
            return 2;
        }
        else
        {
            return self.foodPlacesArr.count;
        }
    }
    else if (section == 8)
    {
        if (self.foodPlacesArr.count ==0 || self.foodPlacesArr.count <2)
        {
            return 0;
        }
        else if (self.foodPlacesArr.count >=2)
        {
            return 1;
        }
    }
    else if (section == 9)
    {
        if (self.prayerSpacesArr.count ==0)
        {
            return 0;
        }
        else if (self.prayerSpacesArr.count >=2)
        {
            return 2;
        }
        else
        {
            return self.prayerSpacesArr.count;
        }
    }
    else if (section == 10)
    {
        if (self.prayerSpacesArr.count ==0 || self.prayerSpacesArr.count <2)
        {
            return 0;
        }
        else if (self.prayerSpacesArr.count >=2)
        {
            return 1;
        }
    }
    else if (section == 11)
    {
        return 1;
    }
    else if (section == 12)
    {
        return 1;
    }
    return 0;
}
-(void)labelTapped
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[_dictDetails objectForKey:@"hhwtlink"]]];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            static NSString *CellIdentifier = @"ImageCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,
                                                                       self.view.frame.size.width,
                                                                       200)];
            scrollView.tag = 100;
            scrollView.pagingEnabled = YES;
            scrollView.delegate = self;
            [scrollView setShowsHorizontalScrollIndicator:NO];
            
            NSArray *photosArray = (NSArray *)[_dictDetails objectForKey:@"photos"];
            NSString *imgURL;
            
            scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * photosArray.count, scrollView.frame.size.height);
            [cell.contentView addSubview:scrollView];
            
            pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, scrollView.frame.size.height-44, self.view.frame.size.width, 37)];
            [scrollView addSubview:pageControl];
            pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, scrollView.frame.size.height-44, self.view.frame.size.width, 37)];
            [cell.contentView addSubview:pageControl];
            
            if (photosArray.count >0) {
                
                
                pageControl.numberOfPages = photosArray.count;
                pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
                pageControl.tintColor = [UIColor grayColor];
                pageControl.currentPage = 0;
                pageControl.hidesForSinglePage = YES;
                
                [cell.contentView addSubview:pageControl];
                
                [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
            }
            
            
            for (int i = 0; i < photosArray.count; i++){
                CGRect frame;
                frame.origin.x = scrollView.frame.size.width * i;
                frame.origin.y = 0;
                frame.size = scrollView.frame.size;
                
                
                UIImageView * imageFood = [[UIImageView alloc] initWithFrame:frame];
                imageFood.tag = i;
                if(photosArray.count == 0)
                    imgURL = @"";
                else
                    imgURL = [[photosArray objectAtIndex:i] valueForKey:@"photourl"];
                imageFood.contentMode = UIViewContentModeScaleAspectFill;
                [scrollView addSubview:imageFood];
                [imageFood sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"placeHolder.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    //  activityIndication.hidden = YES;
                    // [activityIndication stopAnimating];
                }];
                
                
            }
            
            return cell;
        }
        else if (indexPath.row == 1)
        {
            UITableViewCell *summaryCell = [tableView dequeueReusableCellWithIdentifier:@"SummaryCell" forIndexPath:indexPath];
            UITextView *summary = (UITextView *)[summaryCell viewWithTag:20];
            summary.text = [_dictDetails objectForKey:@"description"];
            return summaryCell;
            
        }
        
        else if (indexPath.row == 2)
        {
            UITableViewCell *addressCell = [tableView dequeueReusableCellWithIdentifier:@"AddressCell" forIndexPath:indexPath];
            UILabel *lblName = (UILabel *)[addressCell viewWithTag:1];
            lblName.text = [_dictDetails objectForKey:@"activity"];
            
            UILabel *lblAddress = (UILabel *)[addressCell viewWithTag:2];
            lblAddress.text = [_dictDetails objectForKey:@"address"];
            
            UILabel *lblTiming = (UILabel *)[addressCell viewWithTag:3];
            lblTiming.numberOfLines = 0;
            //lblTiming.lineBreakMode = NSLineBreakByWordWrapping;
            lblTiming.text = [NSString stringWithFormat:@"%@ - %@\n%@",[_dictDetails objectForKey:@"openhrs"],[_dictDetails objectForKey:@"closehrs"],[_dictDetails objectForKey:@"timeremaining"]];;
            
            UILabel *lblAmount = (UILabel *)[addressCell viewWithTag:4];
            lblAmount.text = [NSString stringWithFormat:@"%@ KRW",[_dictDetails objectForKey:@"price"]];
            
            UILabel *lblPhone = (UILabel *)[addressCell viewWithTag:5];
            lblPhone.text = [_dictDetails objectForKey:@"phone"];
            
            UILabel *lblWebsite = (UILabel *)[addressCell viewWithTag:6];
            lblWebsite.text =@"View Website";
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped)];
            tapGestureRecognizer.numberOfTapsRequired = 1;
            [lblWebsite addGestureRecognizer:tapGestureRecognizer];
            lblWebsite.userInteractionEnabled = YES;
            
            return addressCell;
            
        }
    }
    else if (indexPath.section == 1)
    {
         UITableViewCell *reviewCell = [tableView dequeueReusableCellWithIdentifier:@"ReviewCell" forIndexPath:indexPath];
        UILabel *lblRating = (UILabel *)[reviewCell viewWithTag:7];
        lblRating.text = [_dictDetails objectForKey:@"rating"];
        
        ASStarRatingView *ratingView = (ASStarRatingView *)[reviewCell viewWithTag:8];
        ratingView.canEdit = NO;
        ratingView.maxRating = 5;
        ratingView.rating = [[_dictDetails objectForKey:@"rating"] floatValue];
        
        return reviewCell;
    }
    else if (indexPath.section == 2)
    {
        UITableViewCell *SpecialDealsCell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SpecialDealsCell" forIndexPath:indexPath];
        SpecialDealsCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSDictionary *datas =[arrSpecialDeals objectAtIndex:indexPath.row];
        UILabel *nameLabel = (UILabel *)[SpecialDealsCell viewWithTag:1002];
        nameLabel.text = [NSString stringWithFormat:@"%@",[datas valueForKey:@"content"]];
        
        UILabel *priceLabel = (UILabel *)[SpecialDealsCell viewWithTag:1003];
        priceLabel.text = [NSString stringWithFormat:@"From %@ %@",[datas valueForKey:@"currency"],[datas valueForKey:@"rate"]];
        
        UIImageView * imageDeals = (UIImageView *)[SpecialDealsCell viewWithTag:1001];
        NSString *imgURL =[NSString stringWithFormat:@"%@",[datas valueForKey:@"image_one"]];
        [imageDeals sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"placeHolder.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
        return SpecialDealsCell;
    }
    else if (indexPath.section == 3)
    {
        UITableViewCell *SpecialDealsViewAllCell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SpecialDealsViewAllCell" forIndexPath:indexPath];
        SpecialDealsViewAllCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return SpecialDealsViewAllCell;
    }
    else if (indexPath.section == 4)
    {
        UITableViewCell *WhatsNearbyCell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"WhatsNearbyCell" forIndexPath:indexPath];
        WhatsNearbyCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return WhatsNearbyCell;
    }
    else if (indexPath.section == 5)
    {
        UITableViewCell *AttractionsCell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"AttractionsCell" forIndexPath:indexPath];
        AttractionsCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (self.attractionsArr.count >= 2)
        {
            NSArray *IndexArr;
            
            if (indexPath.row ==0)
            {
                IndexArr =[self.attractionsArr objectAtIndex:0];
            }
            else if (indexPath.row ==1)
            {
                IndexArr =[self.attractionsArr objectAtIndex:1];
            }
            UILabel *nameLabel = (UILabel *)[AttractionsCell viewWithTag:1005];
            nameLabel.text =[NSString stringWithFormat:@"%@",[IndexArr valueForKey:@"name"]];
            
            UILabel *subLabel = (UILabel *)[AttractionsCell viewWithTag:1006];
            subLabel.text =[NSString stringWithFormat:@"%@",[IndexArr valueForKey:@"activity"]];
            
            UILabel *ratingLabel = (UILabel *)[AttractionsCell viewWithTag:1007];
            ratingLabel.text = [NSString stringWithFormat:@"%@",[IndexArr valueForKey:@"rating"]];
            
            UILabel *distanceLabel = (UILabel *)[AttractionsCell viewWithTag:1008];
            distanceLabel.text = @"Within 500 meters";
            
            ASStarRatingView *ratingView = (ASStarRatingView *)[AttractionsCell viewWithTag:1009];
            ratingView.canEdit = NO;
            ratingView.maxRating = 5;
            ratingView.rating = [[NSString stringWithFormat:@"%@",[IndexArr valueForKey:@"rating"]] floatValue];
            
            UIImageView * imageDeals = (UIImageView *)[AttractionsCell viewWithTag:1004];
            NSArray *photosArray = (NSArray *)[IndexArr valueForKey:@"photos"];
            NSString *imgURL =@"";
            if(photosArray.count == 0)
                imgURL = @"";
            else
                imgURL = [[photosArray objectAtIndex:0] valueForKey:@"photourl"];
            NSLog(@"Image %@",imgURL);
            [imageDeals sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"placeHolder.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            }];
        }
        else
        {
            if (indexPath.row ==0)
            {
                NSArray *IndexArr =[self.attractionsArr objectAtIndex:0];
                
                UILabel *nameLabel = (UILabel *)[AttractionsCell viewWithTag:1005];
                nameLabel.text =[NSString stringWithFormat:@"%@",[IndexArr valueForKey:@"name"]];
                
                UILabel *subLabel = (UILabel *)[AttractionsCell viewWithTag:1006];
                subLabel.text =[NSString stringWithFormat:@"%@",[IndexArr valueForKey:@"activity"]];
                
                UILabel *ratingLabel = (UILabel *)[AttractionsCell viewWithTag:1007];
                ratingLabel.text = [NSString stringWithFormat:@"%@",[IndexArr valueForKey:@"rating"]];
                
                UILabel *distanceLabel = (UILabel *)[AttractionsCell viewWithTag:1008];
                distanceLabel.text = @"Within 500 meters";
                
                ASStarRatingView *ratingView = (ASStarRatingView *)[AttractionsCell viewWithTag:1009];
                ratingView.canEdit = NO;
                ratingView.maxRating = 5;
                ratingView.rating = [[NSString stringWithFormat:@"%@",[IndexArr valueForKey:@"rating"]] floatValue];
                
                UIImageView * imageDeals = (UIImageView *)[AttractionsCell viewWithTag:1004];
                NSArray *photosArray = (NSArray *)[IndexArr valueForKey:@"photos"];
                NSString *imgURL =@"";
                if(photosArray.count == 0)
                    imgURL = @"";
                else
                    imgURL = [[photosArray objectAtIndex:0] valueForKey:@"photourl"];
                [imageDeals sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"placeHolder.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                }];

            }
        }
        return AttractionsCell;
    }
    else if (indexPath.section == 6)
    {
        UITableViewCell *AttractionsViewAllCell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"AttractionsViewAllCell" forIndexPath:indexPath];
        AttractionsViewAllCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return AttractionsViewAllCell;
    }
    else if (indexPath.section == 7)
    {
        UITableViewCell *FoodPlacesCell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"FoodPlacesCell" forIndexPath:indexPath];
        FoodPlacesCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (self.foodPlacesArr.count >= 2)
        {
            NSArray *IndexArr;
            
            if (indexPath.row ==0)
            {
                IndexArr =[self.foodPlacesArr objectAtIndex:0];
            }
            else if (indexPath.row ==1)
            {
                IndexArr =[self.foodPlacesArr objectAtIndex:1];
            }
            UILabel *nameLabel = (UILabel *)[FoodPlacesCell viewWithTag:1011];
            nameLabel.text =[NSString stringWithFormat:@"%@",[IndexArr valueForKey:@"name"]];
            
            UILabel *subLabel = (UILabel *)[FoodPlacesCell viewWithTag:1012];
            subLabel.text =[NSString stringWithFormat:@"%@",[IndexArr valueForKey:@"activity"]];
            
            UILabel *ratingLabel = (UILabel *)[FoodPlacesCell viewWithTag:1013];
            ratingLabel.text = [NSString stringWithFormat:@"%@",[IndexArr valueForKey:@"rating"]];
            
            UILabel *distanceLabel = (UILabel *)[FoodPlacesCell viewWithTag:1014];
            distanceLabel.text = @"Within 500 meters";
            
            ASStarRatingView *ratingView = (ASStarRatingView *)[FoodPlacesCell viewWithTag:1015];
            ratingView.canEdit = NO;
            ratingView.maxRating = 5;
            ratingView.rating = [[NSString stringWithFormat:@"%@",[IndexArr valueForKey:@"rating"]] floatValue];
            
            UIImageView * imageDeals = (UIImageView *)[FoodPlacesCell viewWithTag:1010];
            NSArray *photosArray = (NSArray *)[IndexArr valueForKey:@"photos"];
            NSString *imgURL =@"";
            if(photosArray.count == 0)
                imgURL = @"";
            else
                imgURL = [[photosArray objectAtIndex:0] valueForKey:@"photourl"];
            [imageDeals sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"placeHolder.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            }];
        }
        else
        {
            if (indexPath.row ==0)
            {
                NSArray *IndexArr =[self.foodPlacesArr objectAtIndex:0];
                
                UILabel *nameLabel = (UILabel *)[FoodPlacesCell viewWithTag:1011];
                nameLabel.text =[NSString stringWithFormat:@"%@",[IndexArr valueForKey:@"name"]];
                
                UILabel *subLabel = (UILabel *)[FoodPlacesCell viewWithTag:1012];
                subLabel.text =[NSString stringWithFormat:@"%@",[IndexArr valueForKey:@"activity"]];
                
                UILabel *ratingLabel = (UILabel *)[FoodPlacesCell viewWithTag:1013];
                ratingLabel.text = [NSString stringWithFormat:@"%@",[IndexArr valueForKey:@"rating"]];
                
                UILabel *distanceLabel = (UILabel *)[FoodPlacesCell viewWithTag:1014];
                distanceLabel.text = @"Within 500 meters";
                
                ASStarRatingView *ratingView = (ASStarRatingView *)[FoodPlacesCell viewWithTag:1015];
                ratingView.canEdit = NO;
                ratingView.maxRating = 5;
                ratingView.rating = [[NSString stringWithFormat:@"%@",[IndexArr valueForKey:@"rating"]] floatValue];
                
                UIImageView * imageDeals = (UIImageView *)[FoodPlacesCell viewWithTag:1010];
                NSArray *photosArray = (NSArray *)[IndexArr valueForKey:@"photos"];
                NSString *imgURL =@"";
                if(photosArray.count == 0)
                    imgURL = @"";
                else
                    imgURL = [[photosArray objectAtIndex:0] valueForKey:@"photourl"];
                [imageDeals sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"placeHolder.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                }];
                
            }
        }
        return FoodPlacesCell;
    }
    else if (indexPath.section == 8)
    {
        UITableViewCell *FoodPlacesViewAllCell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"FoodPlacesViewAllCell" forIndexPath:indexPath];
        FoodPlacesViewAllCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return FoodPlacesViewAllCell;
    }
    else if (indexPath.section == 9)
    {
        UITableViewCell *PrayerSpacesCell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PrayerSpacesCell" forIndexPath:indexPath];
        PrayerSpacesCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (self.prayerSpacesArr.count >= 2)
        {
            NSArray *IndexArr;
            
            if (indexPath.row ==0)
            {
                IndexArr =[self.prayerSpacesArr objectAtIndex:0];
            }
            else if (indexPath.row ==1)
            {
                IndexArr =[self.prayerSpacesArr objectAtIndex:1];
            }
            UILabel *nameLabel = (UILabel *)[PrayerSpacesCell viewWithTag:1017];
            nameLabel.text =[NSString stringWithFormat:@"%@",[IndexArr valueForKey:@"name"]];
            
            UILabel *subLabel = (UILabel *)[PrayerSpacesCell viewWithTag:1018];
            subLabel.text =[NSString stringWithFormat:@"%@",[IndexArr valueForKey:@"activity"]];
            
            UILabel *ratingLabel = (UILabel *)[PrayerSpacesCell viewWithTag:1019];
            ratingLabel.text = [NSString stringWithFormat:@"%@",[IndexArr valueForKey:@"rating"]];
            
            UILabel *distanceLabel = (UILabel *)[PrayerSpacesCell viewWithTag:1020];
            distanceLabel.text = @"Within 500 meters";
            
            ASStarRatingView *ratingView = (ASStarRatingView *)[PrayerSpacesCell viewWithTag:1021];
            ratingView.canEdit = NO;
            ratingView.maxRating = 5;
            ratingView.rating = [[NSString stringWithFormat:@"%@",[IndexArr valueForKey:@"rating"]] floatValue];
            
            UIImageView * imageDeals = (UIImageView *)[PrayerSpacesCell viewWithTag:1016];
            NSArray *photosArray = (NSArray *)[IndexArr valueForKey:@"photos"];
            NSString *imgURL =@"";
            if(photosArray.count == 0)
                imgURL = @"";
            else
                imgURL = [[photosArray objectAtIndex:0] valueForKey:@"photourl"];
            [imageDeals sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"placeHolder.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            }];

        }
        else
        {
            if (indexPath.row ==0)
            {
                NSArray *IndexArr =[self.prayerSpacesArr objectAtIndex:0];
                
                UILabel *nameLabel = (UILabel *)[PrayerSpacesCell viewWithTag:1017];
                nameLabel.text =[NSString stringWithFormat:@"%@",[IndexArr valueForKey:@"name"]];
                
                UILabel *subLabel = (UILabel *)[PrayerSpacesCell viewWithTag:1018];
                subLabel.text =[NSString stringWithFormat:@"%@",[IndexArr valueForKey:@"activity"]];
                
                UILabel *ratingLabel = (UILabel *)[PrayerSpacesCell viewWithTag:1019];
                ratingLabel.text = [NSString stringWithFormat:@"%@",[IndexArr valueForKey:@"rating"]];
                
                UILabel *distanceLabel = (UILabel *)[PrayerSpacesCell viewWithTag:1020];
                distanceLabel.text = @"Within 500 meters";
                
                ASStarRatingView *ratingView = (ASStarRatingView *)[PrayerSpacesCell viewWithTag:1021];
                ratingView.canEdit = NO;
                ratingView.maxRating = 5;
                ratingView.rating = [[NSString stringWithFormat:@"%@",[IndexArr valueForKey:@"rating"]] floatValue];
                
                UIImageView * imageDeals = (UIImageView *)[PrayerSpacesCell viewWithTag:1016];
                NSArray *photosArray = (NSArray *)[IndexArr valueForKey:@"photos"];
                NSString *imgURL =@"";
                if(photosArray.count == 0)
                    imgURL = @"";
                else
                    imgURL = [[photosArray objectAtIndex:0] valueForKey:@"photourl"];
                [imageDeals sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"placeHolder.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                }];
                
            }
        }
        return PrayerSpacesCell;
    }
    else if (indexPath.section == 10)
    {
        UITableViewCell *PrayerSpacesViewAllCell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PrayerSpacesViewAllCell" forIndexPath:indexPath];
        PrayerSpacesViewAllCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return PrayerSpacesViewAllCell;
    }
    else if (indexPath.section == 11)
    {
        UITableViewCell *PeopleAlsoViewedViewAllCell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PeopleAlsoViewedViewAllCell" forIndexPath:indexPath];
        PeopleAlsoViewedViewAllCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return PeopleAlsoViewedViewAllCell;
    }
    else if (indexPath.section == 12)
    {
        UITableViewCell *cell3 = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"actionCell" forIndexPath:indexPath];
        UIButton *btnLocation = (UIButton *)[cell3 viewWithTag:61];
        [btnLocation addTarget:self action:@selector(actionLocation:) forControlEvents:UIControlEventTouchUpInside];
        UIButton *btnSave = (UIButton *)[cell3 viewWithTag:62];
        [btnSave addTarget:self action:@selector(actionSave:) forControlEvents:UIControlEventTouchUpInside];
        UIButton *btnShare = (UIButton *)[cell3 viewWithTag:63];
        [btnShare addTarget:self action:@selector(actionShare:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell3;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2)
    {
        NSDictionary *getDic =[arrSpecialDeals objectAtIndex:indexPath.row];
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
        
        TourDetailModel *getData = modelData;
        TourDetail2 *dis = [self.storyboard instantiateViewControllerWithIdentifier:TOURS_DETAIL2_STORYBOARD_ID];
        dis.selectedTour = getData;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8"))
        {
            [self showViewController:dis sender:nil];
        }else
        {
            [self.navigationController pushViewController:dis animated:YES];
        }
        
    }
    else if (indexPath.section == 3)
    {
        ViewAllViewController *fd = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewAllViewController"];
        self.hidesBottomBarWhenPushed = YES;
        
        fd.keyStr = @"Special";
        fd.datasArr = [arrSpecialDeals mutableCopy];
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8"))
        {
            [self showViewController:fd sender:nil];
        }
        else
        {
            [self.navigationController pushViewController:fd animated:YES];
        }
    }
    else if (indexPath.section == 5)
    {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        DetailTableViewController *detail = [story instantiateViewControllerWithIdentifier:@"DetailTableViewController"];
        detail.selectedCityDict = _selectedCityDict;
        detail.dictDetails = [self.attractionsArr objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:detail animated:YES];
    }
    else if (indexPath.section == 6)
    {
        ViewAllViewController *fd = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewAllViewController"];
        self.hidesBottomBarWhenPushed = YES;
        
        fd.keyStr = @"Attractions";
        fd.datasArr = [self.attractionsArr mutableCopy];
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8"))
        {
            [self showViewController:fd sender:nil];
        }
        else
        {
            [self.navigationController pushViewController:fd animated:YES];
        }

    }
    else if (indexPath.section == 7)
    {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        DetailTableViewController *detail = [story instantiateViewControllerWithIdentifier:@"DetailTableViewController"];
        detail.selectedCityDict = _selectedCityDict;
        detail.dictDetails = [self.foodPlacesArr objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:detail animated:YES];
    }
    else if (indexPath.section == 8)
    {
        ViewAllViewController *fd = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewAllViewController"];
        self.hidesBottomBarWhenPushed = YES;
        
        fd.keyStr = @"Food Places";
        fd.datasArr = [self.foodPlacesArr mutableCopy];
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8"))
        {
            [self showViewController:fd sender:nil];
        }
        else
        {
            [self.navigationController pushViewController:fd animated:YES];
        }
    }
    else if (indexPath.section == 9)
    {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        DetailTableViewController *detail = [story instantiateViewControllerWithIdentifier:@"DetailTableViewController"];
        detail.selectedCityDict = _selectedCityDict;
        detail.dictDetails = [self.prayerSpacesArr objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:detail animated:YES];
    }
    else if (indexPath.section == 10)
    {
        ViewAllViewController *fd = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewAllViewController"];
        self.hidesBottomBarWhenPushed = YES;
        
        fd.keyStr = @"Prayer Spaces";
        fd.datasArr = [self.prayerSpacesArr mutableCopy];
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8"))
        {
            [self showViewController:fd sender:nil];
        }
        else
        {
            [self.navigationController pushViewController:fd animated:YES];
        }
    }
    else if (indexPath.section == 11)
    {
        NSLog(@"People also viewed");
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2)
    {
        if (arrSpecialDeals.count == 0)
        {
            return 0;
        }
        else
        {
            return 50;
        }
    }
    else if (section == 5)
    {
        if (self.attractionsArr.count ==0)
        {
            return 0;
        }
        else
        {
            return 40;
        }
    }
    else if (section == 7)
    {
        if (self.foodPlacesArr.count ==0)
        {
            return 0;
        }
        else
        {
            return 40;
        }
    }
    else if (section == 9)
    {
        if (self.prayerSpacesArr.count ==0)
        {
            return 0;
        }
        else
        {
            return 40;
        }
    }
    else
    {
        return 1;
    }
     
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    if (section == 2)
    {
        if (arrSpecialDeals.count != 0)
        {
            UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(15,0, tableView.frame.size.width, 50)];
            label.text =@"Special Deals";
            label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
            [headerView addSubview:label];
            headerView.backgroundColor = [UIColor whiteColor];
        }
    }
    else if (section ==5)
    {
        UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(15,0, tableView.frame.size.width, 50)];
        label.font =[UIFont systemFontOfSize:14];
        label.textColor =[UIColor grayColor];
        label.text =@"Attractions";
        label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [headerView addSubview:label];
        headerView.backgroundColor = [UIColor whiteColor];
    }
    else if (section ==7)
    {
        UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(15,0, tableView.frame.size.width, 50)];
        label.font =[UIFont systemFontOfSize:14];
        label.textColor =[UIColor grayColor];
        label.text =@"Food Places";
        label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [headerView addSubview:label];
        headerView.backgroundColor = [UIColor whiteColor];
    }
    else if (section ==9)
    {
        UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(15,0, tableView.frame.size.width, 50)];
        label.font =[UIFont systemFontOfSize:14];
        label.textColor =[UIColor grayColor];
        label.text =@"Prayer Spaces";
        label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [headerView addSubview:label];
        headerView.backgroundColor = [UIColor whiteColor];
    }
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            return 200;
        }
        else if (indexPath.row == 1)
            return 100;
        else if (indexPath.row == 2)
            return 260;

    }
    else if (indexPath.section == 1)
    {
        return 100;
    }
    else if (indexPath.section == 2)
    {
        return 200;
    }
    else if (indexPath.section == 3)
    {
        return 50;
    }
    else if (indexPath.section == 4)
    {
        return 40;
    }
    else if (indexPath.section == 5)
    {
        return 123;
    }
    else if (indexPath.section == 6)
    {
        return 50;
    }
    else if (indexPath.section == 7)
    {
        return 123;
    }
    else if (indexPath.section == 8)
    {
        return 50;
    }
    else if (indexPath.section == 9)
    {
        return 123;
    }
    else if (indexPath.section == 10)
    {
        return 50;
    }
    else if (indexPath.section == 11)
    {
        return 50;
    }
    else if (indexPath.section == 12)
    {
        return 60;
    }
       return 0;
}


- (void)presentActivityController:(UIActivityViewController *)controller
{
    controller.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:controller animated:YES completion:nil];
    
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.barButtonItem = self.navigationItem.leftBarButtonItem;
    
    controller.completionWithItemsHandler = ^(NSString *activityType,
                                              BOOL completed,
                                              NSArray *returnedItems,
                                              NSError *error){
        if (completed)
        {
            NSLog(@"We used activity type%@", activityType);
        }
        else
        {
            NSLog(@"We didn't want to share anything after all.");
        }
        if (error)
        {
            NSLog(@"An Error occured: %@, %@", error.localizedDescription, error.localizedFailureReason);
        }
    };
}
- (IBAction)changePage:(id)sender
{
    NSInteger page = pageControl.currentPage;
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
}
-(IBAction)actionShare:(id)sender
{
    NSString *theMessage = [NSString stringWithFormat:@"%@",[_dictDetails objectForKey:@"hhwtlink"]];
    NSArray *items = @[theMessage];
    UIActivityViewController *controller = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
    [self.navigationController presentViewController:controller animated:YES completion:nil];
}
-(IBAction)actionSave:(id)sender
{
    MyTripsViewController *fd = [self.storyboard instantiateViewControllerWithIdentifier:MY_TRIP_SUMMARY_STORYBOARD_ID];
    fd.elementID = [NSString stringWithFormat:@"%@",[self.dictDetails valueForKey:@"sno"]];
    fd.isExploreActive = YES;
    fd.cityID = [NSString stringWithFormat:@"%@",[self.selectedCityDict valueForKey:@"sno"]];
    fd.selectedCityDictionary = self.selectedCityDict;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8"))
    {
        [self showViewController:fd sender:nil];
    }
    else
    {
        [self.navigationController pushViewController:fd animated:YES];
    }
}
-(IBAction)actionLocation:(id)sender
{
    LocationViewController *exp = [self.storyboard instantiateViewControllerWithIdentifier:LOCATION_STORYBOARD_ID];
    self.hidesBottomBarWhenPushed=YES;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8"))
    {
        [self showViewController:exp sender:nil];
    }
    else
    {
        [self.navigationController pushViewController:exp animated:YES];
    }
}


@end
