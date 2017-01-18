//
//  ToursDetail.m
//  HHWT
//
//  Created by SampathKumar on 31/07/16.
//  Copyright © 2016 Sam Software. All rights reserved.
//

#import "ToursDetail.h"
#import "TourDetailTableViewCell.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "TourDetailModel.h"
#import "TourDetail2.h"

@interface ToursDetail ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableData *mutableData;
    NSMutableArray *placeArray;
}

@end

@implementation ToursDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    placeArray = [[NSMutableArray alloc]init];
    showProgress(YES);
    self.title = @"Tour Detail";
    [self performSelector:@selector(fetchPlaces) withObject:nil afterDelay:0.2f];
}

-(void)fetchPlaces
{
    NSString *urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/tourcontent.php"];
    NSString *parameter;
    parameter = [NSString stringWithFormat:@"id=%@",[_selectedCityDictionary objectForKey:@"sno"]];
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
    if([[jsonDict objectForKey:@"success"] integerValue] == 1) {
        
        if([[jsonDict objectForKey:@"tours_content"] count] > 0) {
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
                [placeArray addObject:modelData];
            }
        }
        [_tableView reloadData];
    }else {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[jsonDict objectForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
    }
    showProgress(NO);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return placeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"detailTour";
    TourDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil)
    {
        cell = [[TourDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:MyIdentifier];
    }
    
    TourDetailModel *getData = [placeArray objectAtIndex:indexPath.row];
    cell.lblDesc.text = getData.contentString;
    cell.lblDollar.text = [NSString stringWithFormat:@"%@",getData.rateVal];
    cell.lblDollarFomatt.text = [NSString stringWithFormat:@"From %@",getData.currency];
    cell.ratingsView.rating = getData.totalReviews;
    cell.lblRatings.text = [NSString stringWithFormat:@"%d Reviews",getData.totalReviews];

    NSString *imgURL;
    if([getData.imgOne length] == 0)
        imgURL = @"";
    else
        imgURL = getData.imgOne;
    
    cell.loading.hidden = NO;
    [cell.loading startAnimating];
    [cell.img sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"placeHolder.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        cell.loading.hidden = YES;
        [cell.loading stopAnimating];
    }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 270.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TourDetailModel *getData = [placeArray objectAtIndex:indexPath.row];
    TourDetail2 *dis = [self.storyboard instantiateViewControllerWithIdentifier:TOURS_DETAIL2_STORYBOARD_ID];
    dis.selectedTour = getData;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
        [self showViewController:dis sender:nil];
    }else{
        [self.navigationController pushViewController:dis animated:YES];
    }
}



@end
