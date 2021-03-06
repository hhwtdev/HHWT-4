//
//  ExploreViewController.m
//  HHWT
//
//  Created by  kumar on 04/02/16.
//  Copyright (c) 2016 Sam Software. All rights reserved.
//

#import "ExploreViewController.h"
#import "ExploreTableViewCell.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "DiscoverViewController.h"
#import "VoteForCityViewController.h"
#import "ExploreNewCell.h"
#import "Explore2.h"

@interface ExploreViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSMutableData *mutableData;
    NSMutableArray *cityListArray;
}
@end

@implementation ExploreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Explore";
    
    [_exploreCollectionView registerNib:[UINib nibWithNibName:@"ExploreNewCell" bundle:nil] forCellWithReuseIdentifier:@"exploreCell"];
    
    cityListArray = [NSMutableArray new];
    showProgress(YES);
    [self performSelector:@selector(fetchCities) withObject:nil afterDelay:0.2f];
}



- (void)fetchCities
{
    NSString *urlString = [NSString stringWithFormat:@"http://www.hhwt.tech/hhwt_webservice/get_cities.php"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    [theRequest addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPMethod:@"POST"];
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
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:mutableData options: NSJSONReadingMutableContainers error: nil];
    if([[jsonDict objectForKey:@"Status"] integerValue] == 1) {
        cityListArray = [NSMutableArray arrayWithArray:[jsonDict objectForKey:@"categorylist"]];
        [_exploreCollectionView reloadData];
    }else {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[jsonDict objectForKey:@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show];
    }
    showProgress(NO);
}

#pragma mark - UICollectionViewDataSource methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
    return UIEdgeInsetsMake(5,5,0,5);  // top, left, bottom, right
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    float widthVal = self.view.frame.size.width - 15;
    
    return CGSizeMake(widthVal/2.0f, widthVal/2.0f);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return cityListArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ExploreNewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"exploreCell" forIndexPath:indexPath];
    NSDictionary *dataDic = [cityListArray objectAtIndex:indexPath.row];
    NSString *imgURL;
    if([[dataDic objectForKey:@"img"] length] == 0)
        imgURL = @"";
    else
        imgURL = [dataDic objectForKey:@"img"];
    [cell.img sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"placeHolder.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    cell.lbl1.text = [[dataDic objectForKey:@"city"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //Country
    cell.lbl2.text = [[dataDic objectForKey:@"country"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dataDic = [cityListArray objectAtIndex:indexPath.row];
    Explore2 *dis = [self.storyboard instantiateViewControllerWithIdentifier:EXPLORE_2];
    dis.selectedCityDictionary = dataDic;
    
    
    self.hidesBottomBarWhenPushed = YES;
    
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
        [self showViewController:dis sender:nil];
    }else{
        [self.navigationController pushViewController:dis animated:YES];
    }
    self.hidesBottomBarWhenPushed=NO;

}

- (IBAction)voteForCity:(id)sender {
    VoteForCityViewController *dis = [self.storyboard instantiateViewControllerWithIdentifier:VOTE_FOR_CITY_STORYBOARD_ID];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")){
        [self showViewController:dis sender:nil];
    }else{
        [self.navigationController pushViewController:dis animated:YES];
    }
}

@end
